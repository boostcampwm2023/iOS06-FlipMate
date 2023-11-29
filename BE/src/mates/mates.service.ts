import {
  Injectable,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Mates } from './mates.entity';
import { Repository } from 'typeorm';
import { MatesDto } from './dto/response/mates.dto';
import { UsersModel } from 'src/users/entity/users.entity';
import { RedisService } from 'src/common/redis.service';
import { getImageUrl } from 'src/common/utils';
import { ConfigService } from '@nestjs/config';
import { ENV } from 'src/common/const/env-keys.const';

@Injectable()
export class MatesService {
  constructor(
    @InjectRepository(Mates)
    private matesRepository: Repository<Mates>,
    @InjectRepository(UsersModel)
    private userRepository: Repository<UsersModel>,
    private redisService: RedisService,
    private configService: ConfigService,
  ) {}

  async getMates(user_id: number, date: string): Promise<object[]> {
    const studyTimeByFollowing = await this.userRepository.query(
      `
        SELECT u.id, u.nickname, u.image_url, COALESCE(SUM(s.learning_time), 0) AS total_time
        FROM users_model u
        LEFT JOIN mates m ON m.following_id = u.id
        LEFT JOIN study_logs s ON s.user_id = u.id AND s.date = ?
        WHERE m.follower_id = ? 
        GROUP BY u.id
        ORDER BY total_time DESC
      `,
      [date, user_id],
    );
    return Promise.all(
      studyTimeByFollowing.map(async (record) => {
        const started_at = await this.redisService.get(`${record.id}`);
        return {
          ...record,
          image_url: getImageUrl(
            this.configService.get(ENV.CDN_ENDPOINT),
            record.image_url,
          ),
          total_time: parseInt(record.total_time),
          started_at,
        };
      }),
    );
  }

  async getMatesStatus(user_id: number): Promise<object[]> {
    const result = await this.matesRepository.find({
      where: { follower_id: { id: user_id } },
    });
    const userIds = result.map(({ following_id: { id } }) => id);
    return Promise.all(
      userIds.map(async (id) => {
        const started_at = await this.redisService.get(`${id}`);
        return { id, started_at };
      }),
    );
  }

  async addMate(
    user: UsersModel,
    following_nickname: string,
  ): Promise<MatesDto> {
    const following = await this.userRepository.findOne({
      where: { nickname: following_nickname },
    });

    if (user.id === following?.id) {
      throw new BadRequestException('자신을 친구 추가 할 수 없습니다.');
    }

    if (!user || !following) {
      throw new NotFoundException('해당 유저는 존재하지 않습니다.');
    }

    const isExist = await this.matesRepository.findOne({
      where: { follower_id: user, following_id: following },
    });

    if (isExist) {
      throw new BadRequestException('이미 친구 관계입니다.');
    }

    const mate = this.matesRepository.create({
      follower_id: user,
      following_id: following,
    });

    const result = await this.matesRepository.save(mate);
    return this.entityToDto(result);
  }

  async deleteMate(user: UsersModel, following_id: number): Promise<void> {
    const following = await this.userRepository.findOne({
      where: { id: following_id },
    });
    const result = await this.matesRepository.delete({
      follower_id: user,
      following_id: following,
    });

    if (result.affected === 0) {
      throw new NotFoundException('해당 친구 관계는 존재하지 않습니다.');
    }
  }

  entityToDto(mate: Mates): MatesDto {
    const { id, follower_id, following_id } = mate;
    const mateDto = {
      id: id,
      follower_id: follower_id.id,
      following_id: following_id.id,
    };
    return mateDto;
  }
}

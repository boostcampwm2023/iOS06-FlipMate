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
import { getImageUrl } from 'src/common/utils/utils';
import { ConfigService } from '@nestjs/config';
import { ENV } from 'src/common/const/env-keys.const';
import { StudyLogsService } from 'src/study-logs/study-logs.service';
import moment from 'moment';
import { MATES_MAXIMUM } from 'src/common/const/service-var.const';

@Injectable()
export class MatesService {
  constructor(
    @InjectRepository(Mates)
    private matesRepository: Repository<Mates>,
    @InjectRepository(UsersModel)
    private userRepository: Repository<UsersModel>,
    private redisService: RedisService,
    private configService: ConfigService,
    private studyLogsService: StudyLogsService,
  ) {}

  async getMateAndMyStats(
    user_id: number,
    following_id: number,
    date: string,
  ): Promise<object> {
    const start_date = moment(date).subtract(6, 'days').format('YYYY-MM-DD');
    const my_daily_data = await this.studyLogsService.calculateTotalTimes(
      user_id,
      start_date,
      date,
    );
    const following_daily_data =
      await this.studyLogsService.calculateTotalTimes(
        following_id,
        start_date,
        date,
      );
    // 랭킹1위 카테고리 조회 로직 - ToDo
    const following_primary_category =
      await this.studyLogsService.getPrimaryCategory(
        following_id,
        start_date,
        date,
      );

    return {
      my_daily_data,
      following_daily_data,
      following_primary_category,
    };
  }

  getFollowersInfo(user_id: number) {
    return this.matesRepository.query(
      `SELECT u.id, u.nickname, u.image_url 
       FROM mates 
       INNER JOIN users_model as u ON u.id = mates.follower_id 
       WHERE mates.following_id = ? AND mates.is_blocked = false
       ORDER BY u.nickname`,
      [user_id],
    );
  }

  getFollowingsInfo(user_id: number) {
    return this.matesRepository.query(
      `SELECT u.id, u.nickname, u.image_url 
       FROM mates 
       INNER JOIN users_model as u ON u.id = mates.following_id 
       WHERE mates.follower_id = ?
       ORDER BY u.nickname`,
      [user_id],
    );
  }

  async getMates(
    user_id: number,
    datetime: string,
    timezone: string,
  ): Promise<object[]> {
    if (!user_id || !datetime || !timezone) {
      throw new BadRequestException('인자의 형식이 잘못되었습니다.');
    }
    const offset = timezone[0] === ' ' ? `+${timezone.trim()}` : timezone;
    const nowUserTime = moment(`${datetime}${offset}`)
      .utcOffset(offset)
      .format('YYYY-MM-DD HH:mm:ss');

    const studyTimeByFollowing = await this.getMatesStudyTime(
      nowUserTime,
      offset,
      user_id,
    );
    return Promise.all(
      studyTimeByFollowing.map(async (record) => {
        const started_at = await this.redisService.hget(
          `${record.id}`,
          'started_at',
        );
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

  private getMatesStudyTime(
    followerDate: string,
    followerTimezone: string,
    followerId: number,
  ) {
    return this.userRepository.query(
      `
        SELECT u.id, u.nickname, u.image_url, COALESCE(SUM(s.learning_time), 0) AS total_time
        FROM users_model u
        LEFT JOIN mates m ON m.following_id = u.id
        LEFT JOIN study_logs s ON s.user_id = u.id AND s.date = DATE(CONVERT_TZ(?, ?, u.timezone))
        WHERE m.follower_id = ? 
        GROUP BY u.id, m.is_fixed
        ORDER BY m.is_fixed DESC, u.is_studying DESC, total_time DESC
      `,
      [followerDate, followerTimezone, followerId],
    );
  }

  async getMatesStatus(user_id: number): Promise<object[]> {
    const result = await this.matesRepository.find({
      where: { follower_id: { id: user_id } },
    });
    const userIds = result.map((following) => following.following_id.id);
    return Promise.all(
      userIds.map(async (id) => {
        const started_at = await this.redisService.hget(`${id}`, 'started_at');
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

    const matesCount = await this.matesRepository.count({
      where: { follower_id: user },
    });

    if (matesCount >= MATES_MAXIMUM) {
      throw new BadRequestException(
        `친구는 최대 ${MATES_MAXIMUM}명까지 추가할 수 있습니다.`,
      );
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

  async findMate(user: UsersModel, following_nickname: string) {
    let statusCode = 20000;
    const following = await this.userRepository.findOne({
      where: { nickname: following_nickname },
    });

    if (user.id === following?.id) {
      statusCode = 20001; //자신을 친구 추가 할 수 없습니다.
    }

    if (!user || !following) {
      throw new NotFoundException('해당 유저는 존재하지 않습니다.');
    }

    const isExist = await this.matesRepository.findOne({
      where: { follower_id: user, following_id: following },
    });

    if (isExist) {
      statusCode = 20002; //이미 친구 관계입니다.
    }

    return {
      statusCode,
      image_url: getImageUrl(
        this.configService.get(ENV.CDN_ENDPOINT),
        following.image_url,
      ),
    };
  }

  async deleteMate(user: UsersModel, following_id: number): Promise<void> {
    const following = await this.userRepository.findOne({
      where: { id: following_id },
    });

    if (!following) {
      throw new NotFoundException('해당 유저는 존재하지 않습니다.');
    }

    const result = await this.matesRepository.delete({
      follower_id: user,
      following_id: following,
    });

    if (!result) {
      throw new NotFoundException('해당 친구 관계는 존재하지 않습니다.');
    }
  }

  async fixationMate(
    id: number,
    following_id: number,
    is_fixed: boolean,
  ): Promise<void> {
    const result = await this.matesRepository.update(
      {
        follower_id: { id: id },
        following_id: { id: following_id },
      },
      { is_fixed: is_fixed },
    );

    if (!result) {
      throw new NotFoundException('해당 친구 관계는 존재하지 않습니다.');
    }
  }

  async blockMate(
    id: number,
    follower_id: number,
    is_blocked: boolean,
  ): Promise<void> {
    const result = await this.matesRepository.update(
      {
        follower_id: { id: follower_id },
        following_id: { id: id },
      },
      { is_blocked: is_blocked },
    );

    if (!result) {
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

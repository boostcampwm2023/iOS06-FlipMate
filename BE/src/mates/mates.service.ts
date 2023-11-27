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

@Injectable()
export class MatesService {
  constructor(
    @InjectRepository(Mates)
    private matesRepository: Repository<Mates>,
    @InjectRepository(UsersModel)
    private userRepository: Repository<UsersModel>,
  ) {}

  async getMates(user_id: number): Promise<MatesDto[]> {
    const result = await this.matesRepository.find({
      where: { follower_id: { id: user_id } },
    });
    return result.map((mate) => this.entityToDto(mate));
  }

  async addMate(
    user_id: number,
    following_nickname: string,
  ): Promise<MatesDto> {
    const user = await this.userRepository.findOne({
      where: { id: user_id },
    });
    const following = await this.userRepository.findOne({
      where: { nickname: following_nickname },
    });

    if (user_id === following.id) {
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

  async deleteMate(user_id, following_id): Promise<void> {
    const result = await this.matesRepository.delete({
      follower_id: user_id,
      following_id: following_id,
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

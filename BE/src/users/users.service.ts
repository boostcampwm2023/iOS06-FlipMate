import { BadRequestException, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { UsersModel } from './entity/users.entity';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(UsersModel)
    private usersRepository: Repository<UsersModel>,
  ) {}

  async createUser(user: UsersModel): Promise<UsersModel> {
    try {
      const userObject = this.usersRepository.create({
        nickname: user.nickname,
        email: user.email,
      });
      return await this.usersRepository.save(userObject);
    } catch (error) {
      if (error.code === 'ER_DUP_ENTRY' || error.errno === 1062) {
        throw new BadRequestException(
          '닉네임 또는 이메일이 이미 사용 중입니다.',
        );
      }
      throw error;
    }
  }

  async updateUser(
    user_id: number,
    user: UsersModel,
    image_url?: string,
  ): Promise<UsersModel> {
    const selectedUser = await this.usersRepository.findOne({
      where: { id: user_id },
    });
    if (user.nickname) {
      selectedUser.nickname = user.nickname;
    }
    if (image_url) {
      selectedUser.image_url = image_url;
    }

    const updatedUser = await this.usersRepository.save(selectedUser);
    return updatedUser;
  }

  async isUniqueNickname(nickname: string): Promise<object> {
    const isDuplicated = await this.usersRepository.exist({
      where: { nickname },
    });

    return {
      is_unique: !isDuplicated,
    };
  }

  async findUserByEmail(email: string): Promise<UsersModel> {
    const selectedUser = await this.usersRepository.findOne({
      where: { email },
    });

    return selectedUser;
  }
}

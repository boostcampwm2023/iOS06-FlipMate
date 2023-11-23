import { BadRequestException, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { UsersModel } from './entity/users.entity';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(UsersModel)
    private usersRepository: Repository<UsersModel>,
  ) {}

  async createUser(user: CreateUserDto): Promise<UsersModel> {
    try {
      const userObject = this.usersRepository.create({
        nickname: user.nickname,
        email: user.email,
        image_url: user.image_url,
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

  async updateUser(user_id: number, user: UpdateUserDto): Promise<UsersModel> {
    const selectedUser = await this.usersRepository.findOne({
      where: { id: user_id },
    });
    if (user.nickname) {
      selectedUser.nickname = user.nickname;
    }
    if (user.image_url) {
      selectedUser.image_url = user.image_url;
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

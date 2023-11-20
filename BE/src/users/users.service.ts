import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { UsersModel } from './entity/users.entity';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(UsersModel)
    private usersRepository: Repository<UsersModel>,
  ) {}

  async createUser(user: UserCreateDto): Promise<UsersModel> {
    const users = this.usersRepository.create(user);
    return this.usersRepository.save(users);
  }

  async findUserByEmail(email: string): Promise<UsersModel> {
    const user = await this.usersRepository.findOne({
      where: { google_email: email },
    });
    return user;
  }
}

export type UserCreateDto = {
  nickname: string;
  google_id: string;
  image_url: string;
};

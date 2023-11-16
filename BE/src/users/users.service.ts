import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Users } from './users.entity';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(Users)
    private usersRepository: Repository<Users>,
  ) {}

  async createUser(user: UserCreateDto): Promise<Users> {
    const users = this.usersRepository.create(user);
    return this.usersRepository.save(users);
  }

  async findUserByEmail(email: string): Promise<Users> {
    const user = await this.usersRepository.findOne({
      where: { google_id: email },
    });
    return user;
  }
}

export type UserCreateDto = {
  nickname: string;
  google_id: string;
  image_url: string;
};

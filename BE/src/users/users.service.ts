import { BadRequestException, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { UsersModel } from './entity/users.entity';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { ConfigService } from '@nestjs/config';
import { v4 } from 'uuid';
import { GreenEyeResponse } from './interface/greeneye.interface';


@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(UsersModel)
    private usersRepository: Repository<UsersModel>,
    private config: ConfigService,
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

  async findUserById(user_id: number): Promise<UsersModel> {
    const selectedUser = await this.usersRepository.findOne({
      where: { id: user_id },
    });

    return selectedUser;

  async isNormalImage(image_url: string): Promise<boolean> {
    const THRESHOLD = 0.5;
    const response = await this.requestClovaGreenEye(image_url);
    const result = response.images[0].result;
    const message = response.images[0].message;
    if (message !== 'SUCCESS') {
      throw new BadRequestException('이미지 인식 실패');
    }
    const normalScore = result.normal.confidence;
    const isNormal = normalScore > THRESHOLD ? true : false;

    return isNormal;
  }

  async requestClovaGreenEye(image_url: string): Promise<GreenEyeResponse> {
    const APIURL = this.config.get<string>('GREENEYE_URL');
    const CLIENT_SECRET = this.config.get<string>('GREENEYE_SECRET');
    const UUID = v4();
    try {
      const response = await fetch(APIURL, {
        method: 'POST',
        headers: {
          'X-GREEN-EYE-SECRET': CLIENT_SECRET,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          version: 'V1',
          requestId: UUID,
          timestamp: Date.now(),
          images: [
            {
              name: `${UUID}_profile`,
              url: image_url,
            },
          ],
        }),
      });

      return response.json();
    } catch (error) {
      throw new BadRequestException('이미지 검사 요청 실패');
    }

  }
}

import { BadRequestException, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { UsersModel } from './entity/users.entity';
import { ConfigService } from '@nestjs/config';
import { v4 } from 'uuid';
import { GreenEyeResponse } from './interface/greeneye.interface';
import { S3Service } from 'src/common/s3.service';
import * as path from 'path';
import { ENV } from 'src/common/const/env-keys.const';
import { UpdateUserDto } from './dto/update-user.dto';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(UsersModel)
    private usersRepository: Repository<UsersModel>,
    private s3Service: S3Service,
    private config: ConfigService,
  ) {}

  async createUser(user: UsersModel): Promise<UsersModel> {
    try {
      const userObject = this.usersRepository.create({
        nickname: user.nickname,
        email: user.email,
        image_url: null,
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

  async getUserProfileByNickname(nickname: string): Promise<string> {
    const user = await this.usersRepository.findOne({
      where: { nickname },
    });
    if (!user) {
      throw new BadRequestException('해당 유저가 존재하지 않습니다.');
    }
    return path.join(
      this.config.get(ENV.CDN_ENDPOINT),
      user.image_url ?? 'default.png',
    );
  }

  async updateUser(
    user_id: number,
    user: UpdateUserDto,
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
  }

  async isNormalImage(image: Express.Multer.File): Promise<boolean> {
    const THRESHOLD = 0.5;
    const response = await this.requestClovaGreenEye(image);
    const result = response.images[0].result;
    const message = response.images[0].message;
    if (message !== 'SUCCESS') {
      throw new BadRequestException('이미지 인식 실패');
    }
    const normalScore = result.normal.confidence;
    const isNormal = normalScore > THRESHOLD ? true : false;

    return isNormal;
  }

  async requestClovaGreenEye(
    image: Express.Multer.File,
  ): Promise<GreenEyeResponse> {
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
              data: image.buffer.toString('base64'),
            },
          ],
        }),
      });

      return response.json();
    } catch (error) {
      throw new BadRequestException('이미지 검사 요청 실패');
    }
  }

  async s3Upload(file: Express.Multer.File): Promise<string> {
    return this.s3Service.uploadFile(file);
  }
}

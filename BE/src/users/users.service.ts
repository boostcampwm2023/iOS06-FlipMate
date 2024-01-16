import { BadRequestException, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { UsersModel } from './entity/users.entity';
import { ConfigService } from '@nestjs/config';
import { v4 } from 'uuid';
import { GreenEyeResponse } from './interface/greeneye.interface';
import { S3Service } from 'src/common/s3.service';
import { ENV } from 'src/common/const/env-keys.const';
import { UpdateUserDto } from './dto/update-user.dto';
import { getImageUrl } from 'src/common/utils/utils';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(UsersModel)
    private usersRepository: Repository<UsersModel>,
    private s3Service: S3Service,
    private config: ConfigService,
  ) {}

  async getFollowsCount(user_id: number) {
    const [followsCount] = await this.usersRepository.query(
      `SELECT 
        (SELECT COUNT(*) FROM mates WHERE following_id = ? AND is_blocked = false) AS follower_count,
        (SELECT COUNT(*) FROM mates WHERE follower_id = ?) AS following_count`,
      [user_id, user_id],
    );
    return {
      follower_count: +followsCount.follower_count,
      following_count: +followsCount.following_count,
    };
  }

  async createUser(user: UsersModel): Promise<UsersModel> {
    try {
      const userObject = this.usersRepository.create({
        nickname: user.nickname,
        email: user.email,
        image_url: null,
        auth_type: user.auth_type,
      });
      return await this.usersRepository.save(userObject);
    } catch (error) {
      if (error.code === 'ER_DUP_ENTRY' || error.errno === 1062) {
        throw new BadRequestException({
          statusCode: 40000,
          message: '닉네임 또는 이메일이 이미 사용 중입니다.',
          error: 'Bad request',
        });
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
    return getImageUrl(this.config.get(ENV.CDN_ENDPOINT), user.image_url);
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
    try {
      const updatedUser = await this.usersRepository.save(selectedUser);
      return updatedUser;
    } catch (error) {
      if (error.code === 'ER_DUP_ENTRY' || error.errno === 1062) {
        throw new BadRequestException({
          statusCode: 40000,
          message: '닉네임이 이미 사용 중입니다.',
          error: 'Bad request',
        });
      }
      throw error;
    }
  }

  async updateTimezone(user_id: number, timezone: string): Promise<UsersModel> {
    const selectedUser = await this.usersRepository.findOne({
      where: { id: user_id },
    });
    selectedUser.timezone = timezone;
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

  async findUserByEmailAndAuthType(
    email: string,
    auth_type: string,
  ): Promise<UsersModel> {
    const authEnumStr = auth_type.toUpperCase();
    const selectedUser = await this.usersRepository.findOne({
      where: { email, auth_type: auth_type[authEnumStr] },
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
      throw new BadRequestException({
        statusCode: 40002,
        message: '이미지 인식 실패',
        error: 'Bad request',
      });
    }
    const normalScore = result.normal.confidence;
    const isNormal = normalScore > THRESHOLD ? true : false;

    return isNormal;
  }

  async requestClovaGreenEye(
    image: Express.Multer.File,
  ): Promise<GreenEyeResponse> {
    const APIURL = this.config.get<string>(ENV.GREENEYE_URL);
    const CLIENT_SECRET = this.config.get<string>(ENV.GREENEYE_SECRET);
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
      throw new BadRequestException({
        statusCode: 40002,
        message: '이미지 인식 실패',
        error: 'Bad request',
      });
    }
  }

  async s3Upload(file: Express.Multer.File): Promise<string> {
    return this.s3Service.uploadFile(file);
  }

  remove(user_id: number) {
    if (!user_id) {
      throw new BadRequestException('인자의 형식이 잘못되었습니다.');
    }
    return this.usersRepository.delete(user_id);
  }
}

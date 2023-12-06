import { Test, TestingModule } from '@nestjs/testing';
import { UsersService } from './users.service';
import { S3Service } from 'src/common/s3.service';
import { MockConfigService } from '../../test/mock-service/mock-config-service';
import { ConfigService } from '@nestjs/config';
import { getRepositoryToken } from '@nestjs/typeorm';
import { MockUsersRepository } from '../../test/mock-repo/mock-user-repo';
import { UsersModel } from './entity/users.entity';
import path from 'path';
import { BadRequestException } from '@nestjs/common';

class MockS3Service {}

describe('UsersService', () => {
  let service: UsersService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UsersService,
        {
          provide: getRepositoryToken(UsersModel),
          useClass: MockUsersRepository,
        },
        { provide: S3Service, useClass: MockS3Service },
        { provide: ConfigService, useClass: MockConfigService },
      ],
    }).compile();

    service = module.get<UsersService>(UsersService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('.createUser', () => {
    it('유효한 유저 정보를 받으면 유저를 생성한다.', async () => {
      const user = {
        nickname: 'test',
        email: 'test@test.com',
      } as UsersModel;
      const result = await service.createUser(user);
      expect(result).toStrictEqual({
        id: 4,
        nickname: user.nickname,
        email: user.email,
        image_url: null,
      });
    });
  });

  describe('.getUserProfileByNickname', () => {
    it('유효한 닉네임을 받으면 유저 프로필을 반환한다.', async () => {
      const result = await service.getUserProfileByNickname('어린콩');
      const expected = path.join('http://cdn.com', 'image.png');
      expect(result).toStrictEqual(expected);
    });

    it('유효하지 않은 닉네임을 받으면 에러를 반환한다.', async () => {
      await expect(
        service.getUserProfileByNickname('asdfasdf'),
      ).rejects.toThrow(BadRequestException);
    });

    it('프로필 이미지가 없으면 null을 반환한다.', async () => {
      const result = await service.getUserProfileByNickname('어린콩2');
      expect(result).toBeNull();
    });
  });

  describe('.updateUser', () => {
    const userId = 2;
    const user = {
      nickname: 'test',
    } as UsersModel;
    it('유효한 유저 정보를 받으면 유저 정보를 업데이트한다.', async () => {
      const result = await service.updateUser(userId, user);
      expect(result).toStrictEqual({
        id: userId,
        nickname: user.nickname,
        auth_type: 'google',
        email: 'yeim.de@gmail.com',
        image_url: null,
      });
    });

    it('이미지 url을 받으면 유저 정보를 업데이트한다.', async () => {
      const image_url = 'test.png';
      const result = await service.updateUser(userId, user, image_url);
      expect(result).toStrictEqual({
        id: userId,
        nickname: user.nickname,
        auth_type: 'google',
        email: 'yeim.de@gmail.com',
        image_url,
      });
    });
  });
});

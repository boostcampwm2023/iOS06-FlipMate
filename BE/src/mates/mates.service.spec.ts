import { Test, TestingModule } from '@nestjs/testing';
import { MatesService } from './mates.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Mates } from './mates.entity';
import { MockMatesRepository } from '../../test/mock-repo/mock-mates-repo';
import { UsersModel } from 'src/users/entity/users.entity';
import { MockUsersRepository } from '../../test/mock-repo/mock-user-repo';
import { StudyLogsService } from 'src/study-logs/study-logs.service';
import { MockStudyLogsService } from '../../test/mock-service/mock-study-logs-service';
import { ConfigService } from '@nestjs/config';
import { RedisService } from 'src/common/redis.service';
import { MockRedisService } from '../../test/mock-service/mock-redis-service';
import { BadRequestException, NotFoundException } from '@nestjs/common';

class MockConfigService {
  private ENV = {
    CDN_ENDPOINT: 'http://cdn.com',
  };
  get(key: string) {
    return this.ENV[key.split('.')[1]];
  }
}
describe('MatesService', () => {
  let service: MatesService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        MatesService,
        {
          provide: getRepositoryToken(Mates),
          useClass: MockMatesRepository,
        },
        {
          provide: getRepositoryToken(UsersModel),
          useClass: MockUsersRepository,
        },
        {
          provide: RedisService,
          useClass: MockRedisService,
        },
        {
          provide: StudyLogsService,
          useClass: MockStudyLogsService,
        },
        {
          provide: ConfigService,
          useClass: MockConfigService,
        },
      ],
    }).compile();

    service = module.get<MatesService>(MatesService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
  const user = {
    id: 1,
    nickname: '어린콩',
    auth_type: 'google',
    email: '',
    image_url: null,
  } as UsersModel;
  describe('.addMate()', () => {
    it('유효한 데이터가 주어지면 성공적으로 친구 추가를 해야한다.', async () => {
      const result = await service.addMate(user, '어린콩3');
      expect(result).toStrictEqual({
        id: 2,
        follower_id: 1,
        following_id: 3,
      });
    });

    it.todo('친구는 최대 10명까지 추가할 수 있다.');

    it('자신을 친구 추가 할 수 없다.', async () => {
      expect(service.addMate(user, '어린콩')).rejects.toThrow(
        BadRequestException,
      );
    });

    it('존재하지 않는 유저를 친구 추가 할 수 없다.', async () => {
      expect(service.addMate(user, '어린콩4')).rejects.toThrow(
        NotFoundException,
      );
    });

    it('이미 친구 관계인 유저에게 친구 신청을 할 수 없다.', async () => {
      expect(service.addMate(user, '어린콩2')).rejects.toThrow(
        BadRequestException,
      );
    });
  });

  describe('.deleteMate()', () => {
    it('유효한 데이터가 주어지면 성공적으로 친구 삭제를 해야한다.', async () => {
      const result = await service.deleteMate(user, 2);
      expect(result).toStrictEqual(undefined);
    });

    it('존재하지 않는 유저를 친구 삭제 할 수 없다.', () => {
      expect(service.deleteMate(user, 100)).rejects.toThrow(NotFoundException);
    });

    it('친구 관계가 아닌 유저를 친구 삭제 할 수 없다.', () => {
      expect(service.deleteMate(user, 3)).rejects.toThrow(NotFoundException);
    });
  });

  describe('.getMatesStatus()', () => {
    it('유효한 데이터가 주어지면 성공적으로 친구 상태를 가져온다.', async () => {
      const result = await service.getMatesStatus(1);
      expect(result).toStrictEqual([
        { id: 2, started_at: '2023-11-29 16:00:00' },
      ]);
    });
  });

  describe('.getMates()', () => {
    it('유효한 데이터가 주어지면 성공적으로 친구들을 가져온다.', async () => {
      const result = await service.getMates(1, '2023-11-29');
      expect(result).toStrictEqual([
        {
          id: 2,
          nickname: '어린콩2',
          image_url: null,
          total_time: 825,
          started_at: '2023-11-29 16:00:00',
        },
      ]);
    });
    it('친구가 없는 유저는 빈 배열을 가져온다.', async () => {
      const result = await service.getMates(3, '2023-11-29');
      expect(result).toStrictEqual([]);
    });
  });

  describe('.getMateAndMyStats()', () => {
    it('유효한 데이터가 주어지면 성공적으로 친구들의 학습시간과 내 학습시간을 가져온다.', async () => {
      const result = await service.getMateAndMyStats(1, 2, '2023-11-29');
      expect(result).toStrictEqual({
        my_daily_data: [0, 0, 0, 0, 0, 0, 827],
        following_daily_data: [0, 0, 0, 0, 0, 0, 825],
        following_primary_category: null,
      });
    });
  });

  it('학습 시간이 존재하지 않는 경우 모든 값이 0인 배열을 반환한다.', async () => {
    const result = await service.getMateAndMyStats(1, 2, '2023-12-29');
    expect(result).toStrictEqual({
      my_daily_data: [0, 0, 0, 0, 0, 0, 0],
      following_daily_data: [0, 0, 0, 0, 0, 0, 0],
      following_primary_category: null,
    });
  });
});

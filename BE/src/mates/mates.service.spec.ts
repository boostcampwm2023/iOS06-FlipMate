import { Test, TestingModule } from '@nestjs/testing';
import { MatesService } from './mates.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Mates } from './mates.entity';
import { UsersModel } from 'src/users/entity/users.entity';
import { StudyLogsService } from 'src/study-logs/study-logs.service';
import { MockStudyLogsService } from '../../test/mock-service/mock-study-logs-service';
import { ConfigService } from '@nestjs/config';
import { RedisService } from 'src/common/redis.service';
import { MockRedisService } from '../../test/mock-service/mock-redis-service';
import { BadRequestException, NotFoundException } from '@nestjs/common';
import { MockConfigService } from '../../test/mock-service/mock-config-service';
import { Repository } from 'typeorm';

describe('MatesService', () => {
  let service: MatesService;
  let repository: Repository<Mates>;
  let redisService: RedisService;
  let studyLogsService: StudyLogsService;
  let usersRepository: Repository<UsersModel>;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        MatesService,
        {
          provide: getRepositoryToken(Mates),
          useClass: Repository,
        },
        {
          provide: getRepositoryToken(UsersModel),
          useClass: Repository,
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
    redisService = module.get<RedisService>(RedisService);
    studyLogsService = module.get<StudyLogsService>(StudyLogsService);
    repository = module.get<Repository<Mates>>(getRepositoryToken(Mates));
    usersRepository = module.get<Repository<UsersModel>>(
      getRepositoryToken(UsersModel),
    );
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
      jest.spyOn(usersRepository, 'findOne').mockResolvedValueOnce({
        id: 3,
        nickname: '어린콩3',
        image_url: null,
      } as UsersModel);
      jest.spyOn(repository, 'count').mockResolvedValueOnce(1);
      jest.spyOn(repository, 'findOne').mockResolvedValueOnce(null);
      jest.spyOn(repository, 'create').mockResolvedValueOnce({
        id: 2,
        follower_id: { id: 1 },
        following_id: { id: 3 },
        fixation: false,
      } as never);
      jest.spyOn(repository, 'save').mockResolvedValueOnce({
        id: 2,
        follower_id: { id: 1 } as UsersModel,
        following_id: { id: 3 } as UsersModel,
        is_fixed: false,
      });
      const result = await service.addMate(user, '어린콩3');
      expect(result).toStrictEqual({
        id: 2,
        follower_id: 1,
        following_id: 3,
      });
    });

    it('친구는 최대 10명까지 추가할 수 있다.', async () => {
      jest.spyOn(usersRepository, 'findOne').mockResolvedValueOnce({
        id: 3,
        nickname: '어린콩3',
        image_url: null,
      } as UsersModel);
      jest.spyOn(repository, 'count').mockResolvedValueOnce(10);
      expect(service.addMate(user, '어린콩3')).rejects.toThrow(
        BadRequestException,
      );
    });

    it('자신을 친구 추가 할 수 없다.', async () => {
      jest.spyOn(usersRepository, 'findOne').mockResolvedValueOnce({
        id: 1,
        nickname: '어린콩',
        image_url: null,
      } as UsersModel);
      expect(service.addMate(user, '어린콩')).rejects.toThrow(
        BadRequestException,
      );
    });

    it('존재하지 않는 유저를 친구 추가 할 수 없다.', async () => {
      jest.spyOn(usersRepository, 'findOne').mockResolvedValueOnce(null);
      expect(service.addMate(user, '어린콩4')).rejects.toThrow(
        NotFoundException,
      );
    });

    it('이미 친구 관계인 유저에게 친구 신청을 할 수 없다.', async () => {
      jest.spyOn(usersRepository, 'findOne').mockResolvedValueOnce({
        id: 3,
        nickname: '어린콩3',
        image_url: null,
      } as UsersModel);
      jest.spyOn(repository, 'count').mockResolvedValueOnce(1);
      jest.spyOn(repository, 'findOne').mockResolvedValueOnce({
        id: 1,
        follower_id: { id: 1 } as UsersModel,
        following_id: { id: 3 } as UsersModel,
        is_fixed: false,
      });
      expect(service.addMate(user, '어린콩2')).rejects.toThrow(
        BadRequestException,
      );
    });
  });

  describe('.deleteMate()', () => {
    it('유효한 데이터가 주어지면 성공적으로 친구 삭제를 해야한다.', async () => {
      const data = {
        id: 1,
        follower_id: { id: 1 } as UsersModel,
        following_id: { id: 2 } as UsersModel,
      };
      jest
        .spyOn(usersRepository, 'findOne')
        .mockResolvedValueOnce({ id: 2 } as UsersModel);
      jest.spyOn(repository, 'delete').mockResolvedValueOnce(data as never);
      const result = await service.deleteMate(user, 2);
      expect(result).toStrictEqual(undefined);
    });

    it('존재하지 않는 유저를 친구 삭제 할 수 없다.', () => {
      jest.spyOn(usersRepository, 'findOne').mockResolvedValueOnce(null);
      expect(service.deleteMate(user, 100)).rejects.toThrow(NotFoundException);
    });

    it('친구 관계가 아닌 유저를 친구 삭제 할 수 없다.', () => {
      jest
        .spyOn(usersRepository, 'findOne')
        .mockResolvedValueOnce({ id: 2 } as UsersModel);
      jest.spyOn(repository, 'delete').mockResolvedValueOnce(null);
      expect(service.deleteMate(user, 3)).rejects.toThrow(NotFoundException);
    });
  });

  describe('.getMatesStatus()', () => {
    it('유효한 데이터가 주어지면 성공적으로 친구 상태를 가져온다.', async () => {
      jest.spyOn(repository, 'find').mockResolvedValueOnce([
        {
          id: 1,
          follower_id: { id: 1 } as UsersModel,
          following_id: { id: 2 } as UsersModel,
          is_fixed: false,
        },
      ]);
      jest
        .spyOn(redisService, 'hget')
        .mockResolvedValueOnce('2023-11-29 16:00:00');
      const result = await service.getMatesStatus(1);
      expect(result).toStrictEqual([
        { id: 2, started_at: '2023-11-29 16:00:00' },
      ]);
    });
  });

  describe('.getMates()', () => {
    it('유효한 데이터가 주어지면 성공적으로 친구들을 가져온다.', async () => {
      jest
        .spyOn(usersRepository, 'query')
        .mockResolvedValueOnce([
          { id: 2, nickname: '어린콩2', total_time: 825 },
        ]);
      jest
        .spyOn(redisService, 'hget')
        .mockResolvedValueOnce('2023-11-29 16:00:00');
      const result = await service.getMates(1, '2023-11-29T16:00:00', '+09:00');
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
      jest.spyOn(usersRepository, 'query').mockResolvedValueOnce([]);
      const result = await service.getMates(3, '2023-11-29T16:00:00', '+09:00');
      expect(result).toStrictEqual([]);
    });
  });

  describe('.getMateAndMyStats()', () => {
    it('유효한 데이터가 주어지면 성공적으로 친구들의 학습시간과 내 학습시간을 가져온다.', async () => {
      jest
        .spyOn(studyLogsService, 'calculateTotalTimes')
        .mockResolvedValueOnce([0, 0, 0, 0, 0, 0, 827]);
      jest
        .spyOn(studyLogsService, 'calculateTotalTimes')
        .mockResolvedValueOnce([0, 0, 0, 0, 0, 0, 825]);
      jest
        .spyOn(studyLogsService, 'getPrimaryCategory')
        .mockResolvedValueOnce(null);
      const result = await service.getMateAndMyStats(1, 2, '2023-11-29');
      expect(result).toStrictEqual({
        my_daily_data: [0, 0, 0, 0, 0, 0, 827],
        following_daily_data: [0, 0, 0, 0, 0, 0, 825],
        following_primary_category: null,
      });
    });
  });

  describe('.findMate()', () => {
    it('유효한 데이터가 주어지면 20000코드를 준다.', async () => {
      jest.spyOn(usersRepository, 'findOne').mockResolvedValueOnce({
        id: 3,
        nickname: '어린콩3',
        image_url: null,
      } as UsersModel);
      jest.spyOn(repository, 'findOne').mockResolvedValueOnce(null);
      const result = await service.findMate(user, '어린콩3');
      expect(result).toStrictEqual({
        statusCode: 20000,
        image_url: null,
      });
    });

    it('자신을 검색하면 20001코드를 준다.', async () => {
      jest.spyOn(usersRepository, 'findOne').mockResolvedValueOnce(user);
      jest.spyOn(repository, 'findOne').mockResolvedValueOnce(null);
      const result = await service.findMate(user, '어린콩');
      expect(result).toStrictEqual({
        statusCode: 20001,
        image_url: null,
      });
    });

    it('이미 친구 관계인 유저를 검색하면 20002코드를 준다.', async () => {
      jest.spyOn(usersRepository, 'findOne').mockResolvedValueOnce({
        id: 2,
        nickname: '어린콩2',
        image_url: null,
      } as UsersModel);
      jest.spyOn(repository, 'findOne').mockResolvedValueOnce({
        id: 1,
        follower_id: { id: 1 } as UsersModel,
        following_id: { id: 2 } as UsersModel,
        is_fixed: false,
      });
      const result = await service.findMate(user, '어린콩2');
      expect(result).toStrictEqual({
        statusCode: 20002,
        image_url: null,
      });
    });

    it('존재하지 않는 유저를 검색하면 에러를 던진다.', async () => {
      jest.spyOn(usersRepository, 'findOne').mockResolvedValueOnce(null);
      expect(service.findMate(user, '어린콩4')).rejects.toThrow(
        NotFoundException,
      );
    });
  });
});

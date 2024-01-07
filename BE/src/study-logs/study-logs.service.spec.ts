import { Test, TestingModule } from '@nestjs/testing';
import { StudyLogsService } from './study-logs.service';
import { StudyLogs } from './study-logs.entity';
import { Repository } from 'typeorm';
import { getRepositoryToken } from '@nestjs/typeorm';
import { UsersModel } from 'src/users/entity/users.entity';
import { RedisService } from 'src/common/redis.service';
import { BadRequestException } from '@nestjs/common';

describe('StudyLogsService', () => {
  let service: StudyLogsService;
  let repository: Repository<StudyLogs>;
  let usersRepository: Repository<UsersModel>;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        StudyLogsService,
        {
          provide: getRepositoryToken(StudyLogs),
          useClass: Repository,
        },
        {
          provide: getRepositoryToken(UsersModel),
          useClass: Repository,
        },
        {
          provide: RedisService,
          useValue: {}, // RedisService를 모킹 (필요한 메서드 제공)
        },
      ],
    }).compile();

    service = module.get<StudyLogsService>(StudyLogsService);
    repository = module.get<Repository<StudyLogs>>(
      getRepositoryToken(StudyLogs),
    );
    usersRepository = module.get<Repository<UsersModel>>(
      getRepositoryToken(UsersModel),
    );
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('.calculateTotalTimes()', () => {
    const userId = 1;
    const startDate = '2023-01-01';
    const endDate = '2023-01-07';
    it('유효하지 않은 파라미터에 대해 오류를 발생시켜야 한다', async () => {
      expect(service.calculateTotalTimes(null, null, null)).rejects.toThrow(
        BadRequestException,
      );
      expect(service.calculateTotalTimes(1, null, null)).rejects.toThrow(
        BadRequestException,
      );
      expect(
        service.calculateTotalTimes(null, startDate, endDate),
      ).rejects.toThrow(BadRequestException);
    });
    it('정상적인 범위에서 올바른 결과값을 반환해야 한다.', async () => {
      const expectedOutput = [3600, 7200, 0, 0, 3600, 7200, 1800];

      jest.spyOn(repository, 'query').mockResolvedValueOnce([
        { date: '2023-01-01', daily_sum: '3600' },
        { date: '2023-01-02', daily_sum: '7200' },
        { date: '2023-01-05', daily_sum: '3600' },
        { date: '2023-01-06', daily_sum: '7200' },
        { date: '2023-01-07', daily_sum: '1800' },
      ]);

      const result = await service.calculateTotalTimes(
        userId,
        startDate,
        endDate,
      );

      expect(result).toEqual(expectedOutput);
    });
    it('일치하는 데이터가 없을 때, 0으로 채워진 배열을 반환해야 한다.', async () => {
      const expectedOutput = [0, 0, 0, 0, 0, 0, 0];
      jest.spyOn(repository, 'query').mockResolvedValueOnce([]);

      const result = await service.calculateTotalTimes(
        userId,
        startDate,
        endDate,
      );

      expect(result).toEqual(expectedOutput);
    });
    it('단일 날짜에 대해 올바른 학습 시간을 반환해야 한다.', async () => {
      const expectedOutput = [3600];

      jest
        .spyOn(repository, 'query')
        .mockResolvedValueOnce([{ date: '2023-01-01', daily_sum: '3600' }]);

      const result = await service.calculateTotalTimes(
        userId,
        startDate,
        startDate,
      );

      expect(result).toEqual(expectedOutput);
    });
    it('잘못된 날짜 범위에 대해 오류를 발생시켜야 한다.', async () => {
      expect(
        service.calculateTotalTimes(userId, endDate, startDate),
      ).rejects.toThrow(BadRequestException);
    });
  });

  describe('.calculateLearningTimes()', () => {
    it('학습한 시간이 자정을 지나는 경우 날짜 별로 시간을 나눈다 (한국 시간)', () => {
      const result = service.calculateLearningTimes(
        '2023-11-12T01:00:00+09:00',
        7200,
      );
      expect(result).toEqual([
        {
          started_at: '2023-11-11T14:00:00.000Z',
          date: '2023-11-11',
          learning_time: 3600,
        },
        {
          started_at: '2023-11-11T15:00:00.000Z',
          date: '2023-11-12',
          learning_time: 3600,
        },
      ]);
    });
    it('학습한 시간이 자정을 지나는 경우 날짜 별로 시간을 나눈다 (미국 시간)', () => {
      const result = service.calculateLearningTimes(
        '2023-11-12T01:00:00-0500',
        7200,
      );
      expect(result).toEqual([
        {
          started_at: '2023-11-12T04:00:00.000Z',
          date: '2023-11-11',
          learning_time: 3600,
        },
        {
          started_at: '2023-11-12T05:00:00.000Z',
          date: '2023-11-12',
          learning_time: 3600,
        },
      ]);
    });

    it('학습한 시간이 자정을 지나지 않는 경우, 하루에 대한 학습 시간을 반환한다. (한국 시간)', () => {
      const result = service.calculateLearningTimes(
        '2023-11-12T02:00:00+09:00',
        7200,
      );
      expect(result).toEqual([
        {
          started_at: '2023-11-11T15:00:00.000Z',
          date: '2023-11-12',
          learning_time: 7200,
        },
      ]);
    });

    it('학습한 시간이 자정을 지나지 않는 경우, 하루에 대한 학습 시간을 반환한다. (미국 시간)', () => {
      const result = service.calculateLearningTimes(
        '2023-11-12T02:00:00-0500',
        7200,
      );
      expect(result).toEqual([
        {
          started_at: '2023-11-12T05:00:00.000Z',
          date: '2023-11-12',
          learning_time: 7200,
        },
      ]);
    });
  });

  describe('calculatePercentage()', () => {
    it('유저의 총 학습 시간 기준 전체 유저의 학습 시간에 대한 백분율을 반환한다.', async () => {
      for (let i = 1; i <= 4; i++) {
        jest.spyOn(repository, 'query').mockResolvedValueOnce([
          { user_id: 1, total_time: 40000 },
          { user_id: 2, total_time: 20000 },
          { user_id: 3, total_time: 5000 },
          { user_id: 4, total_time: 1000 },
        ]);
        jest.spyOn(usersRepository, 'count').mockResolvedValueOnce(4);
        expect(await service.calculatePercentage(i, '', '')).toEqual(25 * i);
      }
    });
  });

  describe('getPrimaryCategory()', () => {
    it('유저가 해당 기간 동안 학습한 카테고리 중 가장 많이 학습한 카테고리를 반환한다.', async () => {
      jest
        .spyOn(repository, 'query')
        .mockResolvedValueOnce([{ id: 1, name: '1', total_time: 40000 }]);
      expect(await service.getPrimaryCategory(1, '', '')).toEqual('1');
    });

    it('유저가 해당 기간 동안 학습한 카테고리가 없을 경우 기타를 반환한다.', async () => {
      jest
        .spyOn(repository, 'query')
        .mockResolvedValueOnce([{ id: 1, name: null, total_time: 100 }]);
      expect(await service.getPrimaryCategory(1, '', '')).toEqual('기타');
    });

    it('유저가 해당 기간 동안 학습 기록이 없는 경우 null을 반환한다.', async () => {
      jest.spyOn(repository, 'query').mockResolvedValueOnce([]);
      expect(await service.getPrimaryCategory(1, '', '')).toEqual(null);
    });
  });

  describe('groupByCategory()', () => {
    it('유저의 해당 날짜 학습 기록을 카테고리로 묶어서 반환한다.', async () => {
      const result = [
        {
          id: 1,
          name: '카테고리1',
          color_code: '#000000',
          today_time: 3600,
        },
        {
          id: 2,
          name: '카테고리2',
          color_code: '#000000',
          today_time: 7200,
        },
      ];
      jest.spyOn(repository, 'query').mockResolvedValueOnce(result);
      jest
        .spyOn(repository, 'query')
        .mockResolvedValueOnce([{ date: '2023-01-01', daily_sum: 11800 }]);
      expect(await service.groupByCategory(1, '2023-01-01')).toEqual({
        total_time: 11800,
        categories: result,
      });
    });
  });
});

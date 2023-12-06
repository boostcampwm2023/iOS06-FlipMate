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
});

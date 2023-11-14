import { Test, TestingModule } from '@nestjs/testing';
import { StudyLogsService } from './study-logs.service';

describe('StudyLogsService', () => {
  let service: StudyLogsService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [StudyLogsService],
    }).compile();

    service = module.get<StudyLogsService>(StudyLogsService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});

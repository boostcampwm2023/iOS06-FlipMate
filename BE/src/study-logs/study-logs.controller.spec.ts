import { Test, TestingModule } from '@nestjs/testing';
import { StudyLogsController } from './study-logs.controller';

describe('StudyLogsController', () => {
  let controller: StudyLogsController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [StudyLogsController],
    }).compile();

    controller = module.get<StudyLogsController>(StudyLogsController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});

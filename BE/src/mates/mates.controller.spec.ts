import { Test, TestingModule } from '@nestjs/testing';
import { MatesController } from './mates.controller';

describe('MatesController', () => {
  let controller: MatesController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [MatesController],
    }).compile();

    controller = module.get<MatesController>(MatesController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});

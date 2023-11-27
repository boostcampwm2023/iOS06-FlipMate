import { Test, TestingModule } from '@nestjs/testing';
import { MatesService } from './mates.service';

describe('MatesService', () => {
  let service: MatesService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [MatesService],
    }).compile();

    service = module.get<MatesService>(MatesService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});

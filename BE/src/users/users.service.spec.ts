import { Test, TestingModule } from '@nestjs/testing';
import { UsersService } from './users.service';
import { S3Service } from 'src/common/s3.service';
import { MockConfigService } from '../../test/mock-service/mock-config-service';
import { ConfigService } from '@nestjs/config';
import { getRepositoryToken } from '@nestjs/typeorm';
import { MockUsersRepository } from '../../test/mock-repo/mock-user-repo';
import { UsersModel } from './entity/users.entity';

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
});

import { Test, TestingModule } from '@nestjs/testing';
import { CategoriesService } from './categories.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Categories } from './categories.entity';
import {
  BadRequestException,
  NotFoundException,
  UnauthorizedException,
} from '@nestjs/common';
import { UsersService } from 'src/users/users.service';
import { MockCategoriesRepository } from '../../test/mock-repo/mock-categories-repo';
import { MockUsersService } from '../../test/mock-service/mock-user-service';

describe('CategoriesService', () => {
  let service: CategoriesService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CategoriesService,
        {
          provide: getRepositoryToken(Categories),
          useClass: MockCategoriesRepository,
        },
        {
          provide: UsersService,
          useClass: MockUsersService,
        },
      ],
    }).compile();

    service = module.get<CategoriesService>(CategoriesService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('.create()', () => {
    const normalData = { name: 'Test Category', color_code: 'FFFFFFFF' };
    it('유효한 데이터로 카테고리를 성공적으로 생성해야 한다', async () => {
      const userId = 1;
      const result = await service.create(userId, normalData);
      expect(result).toStrictEqual({
        category_id: 3,
        name: normalData.name,
        color_code: normalData.color_code,
      });
    });
    it('존재하지 않는 유저 ID가 주어지면 오류를 발생시켜야 한다', async () => {
      const userId = 100;
      expect(service.create(userId, normalData)).rejects.toThrow(
        NotFoundException,
      );
    });
    it('유효하지 않은 파라미터에 대해 오류를 발생시켜야 한다', async () => {
      const userId = 1;
      const nullUserId = null;
      const nullData = null;
      expect(service.create(nullUserId, nullData)).rejects.toThrow(
        BadRequestException,
      );
      expect(service.create(userId, nullData)).rejects.toThrow(
        BadRequestException,
      );
      expect(service.create(nullUserId, normalData)).rejects.toThrow(
        BadRequestException,
      );
    });

    it.todo('카테고리는 최대 10개까지 추가할 수 있다');
  });

  describe('.findByUserId()', () => {
    const existUserId = 1;
    it('존재하는 유저 ID가 주어지면 카테고리들을 조회할 수 있어야 한다', async () => {
      const result = await service.findByUserId(existUserId);
      expect(result).toStrictEqual([
        { category_id: 1, name: '백준', color_code: 'FFFFFF' },
        { category_id: 2, name: '과학', color_code: 'BBBBBB' },
      ]);
    });

    it('카테고리가 없는 유저도 빈 배열을 줘야 한다', async () => {
      const emptyCatgoryUserId = 2;
      const result = await service.findByUserId(emptyCatgoryUserId);
      expect(result).toStrictEqual([]);
    });
    it('존재하지 않는 유저 ID가 주어지면 오류를 발생시켜야 한다', () => {
      const userId = 100;
      expect(service.findByUserId(userId)).rejects.toThrow(NotFoundException);
    });
    it('유효하지 않은 파라미터에 대해 오류를 발생시켜야 한다', () => {
      const nullUserId = null;
      expect(service.findByUserId(nullUserId)).rejects.toThrow(
        BadRequestException,
      );
    });
  });

  describe('.update()', () => {
    const normalData = { name: 'Test Category', color_code: 'FFFFFFFF' };
    it('유효한 데이터로 카테고리를 성공적으로 수정해야 한다', async () => {
      const result = await service.update(1, normalData, 1);
      expect(result).toStrictEqual({
        category_id: 1,
        name: normalData.name,
        color_code: normalData.color_code,
      });
    });
    it('해당 카테고리가 존재하지 않으면 오류를 발생시켜야 한다', async () => {
      const userId = 1;
      const categoryId = 100;
      expect(service.update(userId, normalData, categoryId)).rejects.toThrow(
        NotFoundException,
      );
    });
    it('해당 유저가 카테고리를 소유하지 않으면 오류를 발생시켜야 한다', async () => {
      const userId = 2;
      expect(service.update(userId, normalData, 1)).rejects.toThrow(
        UnauthorizedException,
      );
    });
    it('유효하지 않은 파라미터에 대해 오류를 발생시켜야 한다', async () => {
      const nullUserId = null;
      const nullData = null;
      const nullCategoryId = null;
      expect(
        service.update(nullUserId, nullData, nullCategoryId),
      ).rejects.toThrow(BadRequestException);
      expect(
        service.update(nullUserId, normalData, nullCategoryId),
      ).rejects.toThrow(BadRequestException);
      expect(service.update(nullUserId, nullData, 1)).rejects.toThrow(
        BadRequestException,
      );
      expect(service.update(1, nullData, nullCategoryId)).rejects.toThrow(
        BadRequestException,
      );
      expect(service.update(1, nullData, 1)).rejects.toThrow(
        BadRequestException,
      );
      expect(service.update(1, normalData, nullCategoryId)).rejects.toThrow(
        BadRequestException,
      );
    });

    it.todo('');
  });
  /**
   * async update(
      user_id: number,
      categoriesData: CategoryUpdateDto,
      id: number,
    )
   */
  // update Method

  // remove Method
});

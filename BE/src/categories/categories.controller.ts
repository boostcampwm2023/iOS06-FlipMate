import { Body, Controller, Get, Post } from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiCreatedResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { CategoriesService } from './categories.service';
import { Categories } from './categories.entity';

@ApiTags('Categories')
@Controller('categories')
export class CategoriesController {
  constructor(private readonly categoriesService: CategoriesService) {}

  @Get()
  @ApiOperation({ summary: '카테고리 조회' })
  @ApiCreatedResponse({
    type: [Categories],
    description: '카테고리 조회 성공',
  })
  @ApiBadRequestResponse({
    description: '잘못된 요청입니다.',
  })
  getCategories() {
    return this.categoriesService.findAll();
  }
}

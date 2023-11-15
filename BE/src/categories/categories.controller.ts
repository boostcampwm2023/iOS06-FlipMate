import { Body, Controller, Get, Patch, Post } from '@nestjs/common';
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
  getCategories(): Promise<Categories[]> {
    return this.categoriesService.findAll();
  }

  @Post()
  @ApiOperation({ summary: '카테고리 생성' })
  @ApiCreatedResponse({
    type: Categories,
    description: '카테고리 생성 성공',
  })
  @ApiBadRequestResponse({
    description: '잘못된 요청입니다.',
  })
  createCategories(@Body() categoriesData: Categories): Promise<Categories> {
    return this.categoriesService.create(categoriesData);
  }

  @Patch(':id')
  @ApiOperation({ summary: '카테고리 수정' })
  @ApiCreatedResponse({
    type: Categories,
    description: '카테고리 수정 성공',
  })
  @ApiBadRequestResponse({
    description: '잘못된 요청입니다.',
  })
  updateCategories(
    @Body() categoriesData: Categories,
    @Body() id: number,
  ): Promise<Categories> {
    return this.categoriesService.update(categoriesData, id);
  }
}

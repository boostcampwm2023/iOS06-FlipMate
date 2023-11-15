import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Patch,
  Post,
} from '@nestjs/common';
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

  @Patch(':category_id')
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
    @Param() category_id: number,
  ): Promise<Categories> {
    return this.categoriesService.update(categoriesData, category_id);
  }

  @Delete(':category_id')
  @ApiOperation({ summary: '카테고리 삭제' })
  @ApiCreatedResponse({
    type: Categories,
    description: '카테고리 삭제 성공',
  })
  @ApiBadRequestResponse({
    description: '잘못된 요청입니다.',
  })
  deleteCategories(@Param() category_id: number): Promise<void> {
    return this.categoriesService.remove(category_id);
  }
}

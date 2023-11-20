import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Patch,
  Post,
  Headers,
} from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiCreatedResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { CategoriesService } from './categories.service';
import { Categories } from './categories.entity';
import { CategoryGetDto } from './dto/get-categories.dto';
import { CategoryCreateDto } from './dto/create-categories.dto';

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
  getCategories(
    @Headers('authorization') CategoryGetDto,
  ): Promise<Categories[]> {
    // TODO: 유저 id를 받아올 방식 정하기
    return this.categoriesService.findByUserId(1);
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
  createCategories(
    @Body() categoriesData: CategoryCreateDto,
  ): Promise<CategoryCreateDto> {
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

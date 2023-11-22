import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Patch,
  Post,
  UseGuards,
} from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiOperation,
  ApiParam,
  ApiTags,
} from '@nestjs/swagger';
import { CategoriesService } from './categories.service';
import { CategoryCreateDto } from './dto/request/create-categories.dto';
import { CategoryUpdateDto } from './dto/request/update-categories.dto';
import { CategoryDto } from './dto/response/category.dto';
import { AccessTokenGuard } from 'src/auth/guard/bearer-token.guard';
import { User } from 'src/users/decorator/user.decorator';

@ApiTags('Categories')
@Controller('categories')
export class CategoriesController {
  constructor(private readonly categoriesService: CategoriesService) {}

  @Get()
  @UseGuards(AccessTokenGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: '카테고리 조회' })
  @ApiCreatedResponse({
    type: [CategoryDto],
    description: '카테고리 조회 성공',
  })
  @ApiBadRequestResponse({
    description: '잘못된 요청입니다.',
  })
  getCategories(@User('id') user_id: number): Promise<CategoryDto[]> {
    // TODO: 유저 id를 받아올 방식 정하기
    user_id;
    return this.categoriesService.findByUserId(1);
  }

  @Post()
  @UseGuards(AccessTokenGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: '카테고리 생성' })
  @ApiCreatedResponse({
    type: CategoryDto,
    description: '카테고리 생성 성공',
  })
  @ApiBadRequestResponse({
    description: '잘못된 요청입니다.',
  })
  createCategories(
    @User('id') user_id: number,
    @Body() categoriesData: CategoryCreateDto,
  ): Promise<CategoryCreateDto> {
    return this.categoriesService.create(user_id, categoriesData);
  }

  @Patch(':category_id')
  @UseGuards(AccessTokenGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: '카테고리 수정' })
  @ApiParam({
    name: 'category_id',
    description: '카테고리 id',
    type: Number,
    required: true,
  })
  @ApiCreatedResponse({
    type: CategoryDto,
    description: '카테고리 수정 성공',
  })
  @ApiBadRequestResponse({
    description: '잘못된 요청입니다.',
  })
  updateCategories(
    @User('id') user_id: number,
    @Body() categoriesData: CategoryUpdateDto,
    @Param('category_id') category_id: number,
  ): Promise<CategoryDto> {
    return this.categoriesService.update(user_id, categoriesData, category_id);
  }

  @Delete(':category_id')
  @UseGuards(AccessTokenGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: '카테고리 삭제' })
  @ApiParam({
    name: 'category_id',
    description: '카테고리 id',
    type: Number,
    required: true,
  })
  @ApiCreatedResponse({
    description: '카테고리 삭제 성공',
  })
  @ApiBadRequestResponse({
    description: '잘못된 요청입니다.',
  })
  deleteCategories(
    @User('id') user_id: number,
    @Param('category_id') category_id: number,
  ): Promise<void> {
    return this.categoriesService.remove(user_id, category_id);
  }
}

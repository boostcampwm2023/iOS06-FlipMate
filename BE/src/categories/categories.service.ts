import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Categories } from './categories.entity';
import { CategoryCreateDto } from './dto/request/create-categories.dto';
import { CategoryUpdateDto } from './dto/request/update-categories.dto';
import { CategoryDto } from './dto/response/category.dto';
import { UsersModel } from 'src/users/entity/users.entity';

@Injectable()
export class CategoriesService {
  constructor(
    @InjectRepository(Categories)
    private categoriesRepository: Repository<Categories>,
  ) {}

  async create(
    user_id: number,
    categoriesData: CategoryCreateDto,
  ): Promise<CategoryDto> {
    const user = { id: user_id } as UsersModel;
    const category = this.categoriesRepository.create({
      ...categoriesData,
      user_id: user,
    });
    const savedCategory = await this.categoriesRepository.save(category);
    return this.entityToDto(savedCategory);
  }

  async findByUserId(user_id: number): Promise<CategoryDto[]> {
    const categories = await this.categoriesRepository.find({
      where: { user_id: { id: user_id } },
      relations: ['user_id'],
    });
    const categoryDto = categories.map((category) => {
      return this.entityToDto(category);
    });
    return categoryDto;
  }

  async update(
    user_id: number,
    categoriesData: CategoryUpdateDto,
    id: number,
  ): Promise<CategoryDto> {
    // todo - user_id를 검증
    const category = await this.categoriesRepository.findOne({
      where: { id },
      relations: ['user_id'],
    });
    category.name = categoriesData.name;
    category.color_code = categoriesData.color_code;
    const updatedCategory = await this.categoriesRepository.save(category);
    return this.entityToDto(updatedCategory);
  }

  async remove(user_id: number, id: number): Promise<void> {
    // todo - user_id를 검증
    const result = await this.categoriesRepository.delete(id);
    if (result.affected === 0) {
      throw new NotFoundException('해당 카테고리가 존재하지 않습니다.');
    }
  }

  entityToDto(category: Categories): CategoryDto {
    const categoryDto: CategoryDto = {
      category_id: category.id,
      name: category.name,
      color_code: category.color_code,
    };
    return categoryDto;
  }
}

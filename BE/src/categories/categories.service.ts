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

  async create(categoriesData: CategoryCreateDto): Promise<CategoryDto> {
    const { user_id, ...data } = categoriesData;
    const user = { id: user_id } as UsersModel;
    const category = this.categoriesRepository.create({
      ...data,
      user_id: user,
    });
    const savedCategory = await this.categoriesRepository.save(category);
    return this.entityToDto(savedCategory);
  }

  async findAll(): Promise<Categories[]> {
    return this.categoriesRepository.find();
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
    categoriesData: CategoryUpdateDto,
    id: number,
  ): Promise<CategoryDto> {
    const category = await this.categoriesRepository.findOne({
      where: { id },
      relations: ['user_id'],
    });
    category.name = categoriesData.name;
    category.color_code = categoriesData.color_code;
    const updatedCategory = await this.categoriesRepository.save(category);
    return this.entityToDto(updatedCategory);
  }

  async remove(id: number): Promise<void> {
    const result = await this.categoriesRepository.delete(id);
    if (result.affected === 0) {
      throw new NotFoundException('해당 카테고리가 존재하지 않습니다.');
    }
  }

  entityToDto(category: Categories): CategoryDto {
    const categoryDto: CategoryDto = {
      id: category.id,
      user_id: category.user_id.id,
      name: category.name,
      color_code: category.color_code,
    };
    return categoryDto;
  }
}

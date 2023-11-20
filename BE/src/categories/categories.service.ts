import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Categories } from './categories.entity';
import { CategoryCreateDto } from './dto/request/create-categories.dto';
import { CategoryUpdateDto } from './dto/request/update-categories.dto';
import { CategoryDto } from './dto/response/category.dto';

@Injectable()
export class CategoriesService {
  constructor(
    @InjectRepository(Categories)
    private categoriesRepository: Repository<Categories>,
  ) {}

  async create(categoriesData: CategoryCreateDto): Promise<CategoryDto> {
    const category = this.categoriesRepository.create(categoriesData);
    return this.categoriesRepository.save(category);
  }

  async findAll(): Promise<Categories[]> {
    return this.categoriesRepository.find();
  }

  async findByUserId(user_id: number): Promise<CategoryDto[]> {
    return this.categoriesRepository.find({ where: { user_id: user_id } });
  }

  async update(
    categoriesData: CategoryUpdateDto,
    id: number,
  ): Promise<CategoryDto> {
    const category = await this.categoriesRepository.findOne({
      where: { id: id },
    });
    category.name = categoriesData.name;
    category.color_code = categoriesData.color_code;
    return this.categoriesRepository.save(category);
  }

  async remove(id: number): Promise<void> {
    const result = await this.categoriesRepository.delete(id);
    if (result.affected === 0) {
      throw new NotFoundException('해당 카테고리가 존재하지 않습니다.');
    }
  }
}

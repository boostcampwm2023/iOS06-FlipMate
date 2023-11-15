import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Categories } from './categories.entity';

@Injectable()
export class CategoriesService {
  constructor(
    @InjectRepository(Categories)
    private categoriesRepository: Repository<Categories>,
  ) {}

  async create(categoriesData: Categories): Promise<Categories> {
    const category = this.categoriesRepository.create(categoriesData);
    return this.categoriesRepository.save(category);
  }

  async findAll(): Promise<Categories[]> {
    return this.categoriesRepository.find();
  }

  async update(categoriesData: Categories, id: number): Promise<Categories> {
    const category = await this.categoriesRepository.findOne({
      where: { id: id },
    });
    category.name = categoriesData.name;
    category.color_code = categoriesData.color_code;
    return this.categoriesRepository.save(category);
  }
}

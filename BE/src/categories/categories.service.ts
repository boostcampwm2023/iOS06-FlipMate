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
}

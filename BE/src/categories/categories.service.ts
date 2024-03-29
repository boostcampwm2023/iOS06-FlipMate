import {
  BadRequestException,
  Injectable,
  NotFoundException,
  UnauthorizedException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Categories } from './categories.entity';
import { CategoryCreateDto } from './dto/request/create-categories.dto';
import { CategoryUpdateDto } from './dto/request/update-categories.dto';
import { CategoryDto } from './dto/response/category.dto';
import { UsersService } from 'src/users/users.service';
import { CATEGORIES_MAXIMUM } from 'src/common/const/service-var.const';

@Injectable()
export class CategoriesService {
  constructor(
    @InjectRepository(Categories)
    private categoriesRepository: Repository<Categories>,
    private usersService: UsersService,
  ) {}

  async create(
    user_id: number,
    categoriesData: CategoryCreateDto,
  ): Promise<CategoryDto> {
    if (!user_id || !categoriesData) {
      throw new BadRequestException('인자의 형식이 잘못되었습니다.');
    }
    const user = await this.usersService.findUserById(user_id);
    if (!user) {
      throw new NotFoundException('해당 id의 유저가 존재하지 않습니다.');
    }

    const categories = await this.categoriesRepository.find({
      where: { user_id: { id: user.id } },
    });
    const categoryCount = categories.length;
    if (categoryCount >= CATEGORIES_MAXIMUM) {
      throw new BadRequestException(
        `카테고리는 최대 ${CATEGORIES_MAXIMUM}개까지 생성할 수 있습니다.`,
      );
    }
    const categoryNames = categories.map((category) => category.name);
    if (categoryNames.includes(categoriesData.name)) {
      throw new BadRequestException('이미 존재하는 카테고리입니다.');
    }

    const category = this.categoriesRepository.create({
      ...categoriesData,
      user_id: user,
    });

    const savedCategory = await this.categoriesRepository.save(category);
    return this.entityToDto(savedCategory);
  }

  async findByUserId(user_id: number): Promise<CategoryDto[]> {
    if (!user_id) {
      throw new BadRequestException('인자의 형식이 잘못되었습니다.');
    }

    const user = await this.usersService.findUserById(user_id);
    if (!user) {
      throw new NotFoundException('해당 id의 유저가 존재하지 않습니다.');
    }

    const categories = await this.categoriesRepository.find({
      where: { user_id: { id: user.id } },
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
    if (!user_id || !categoriesData || !id) {
      throw new BadRequestException('인자의 형식이 잘못되었습니다.');
    }
    const category = await this.categoriesRepository.findOne({
      where: { id },
    });
    if (!category) {
      throw new NotFoundException('해당 카테고리가 존재하지 않습니다.');
    }
    if (category.user_id.id !== user_id) {
      throw new UnauthorizedException(
        '해당 유저가 카테고리를 소유하고 있지 않습니다.',
      );
    }
    category.name = categoriesData.name;
    category.color_code = categoriesData.color_code;
    const updatedCategory = await this.categoriesRepository.save(category);
    return this.entityToDto(updatedCategory);
  }

  async remove(user_id: number, id: number): Promise<void> {
    if (!user_id || !id) {
      throw new BadRequestException('인자의 형식이 잘못되었습니다.');
    }
    const record = await this.categoriesRepository.findOne({ where: { id } });
    if (!record) {
      throw new NotFoundException('해당 카테고리가 존재하지 않습니다.');
    }
    if (record.user_id.id !== user_id) {
      throw new UnauthorizedException(
        '해당 유저가 카테고리를 소유하고 있지 않습니다.',
      );
    }

    await this.categoriesRepository.delete(id);
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

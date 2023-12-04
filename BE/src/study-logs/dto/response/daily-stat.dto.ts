import { ApiProperty } from '@nestjs/swagger';
import { CategoryDto } from 'src/categories/dto/response/category.dto';

export class dailyStatDto {
  @ApiProperty({
    type: 'number',
    example: 10000,
    description: '해당 날짜의 총 학습 시간',
  })
  total_time: number;

  @ApiProperty({
    type: Array(CategoryDto),
    description: '학습 한 카테고리들',
  })
  categories: object[];

  @ApiProperty({
    type: 'number',
    example: '3',
    description: '해당 날짜에 유저의 학습 시간이 전체 유저 중 상위 몇 %인지',
  })
  percentage: number;
}

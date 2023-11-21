import { ApiProperty } from '@nestjs/swagger';

export class CategoryCreateDto {
  @ApiProperty({
    type: 'number',
    example: '1',
    description: '유저 id',
  })
  user_id: number;

  @ApiProperty({
    type: 'string',
    example: '백준',
    description: '카테고리 이름',
  })
  name: string;

  @ApiProperty({
    type: 'string',
    example: 'FFFFFFFF',
    description: '카테고리 색상',
  })
  color_code: string;
}

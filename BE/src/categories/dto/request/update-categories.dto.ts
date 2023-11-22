import { ApiProperty } from '@nestjs/swagger';

export class CategoryUpdateDto {
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

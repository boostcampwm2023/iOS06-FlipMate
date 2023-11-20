import { ApiProperty } from '@nestjs/swagger';
export class CategoryGetDto {
  @ApiProperty({
    type: 'number',
    example: '1',
    description: '유저 id',
  })
  user_id: number;
}

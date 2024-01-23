import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsNumber, Min } from 'class-validator';

export class PaginationQueryDto {
  @ApiProperty({
    type: 'number',
    example: 1,
    description: '현재 cursor 위치 (default: 1)',
  })
  @Type(() => Number) // Add this line
  @IsNumber()
  @Min(1)
  cursor: number = 1;
}

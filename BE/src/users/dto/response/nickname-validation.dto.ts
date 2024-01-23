import { ApiProperty } from '@nestjs/swagger';

export class NicknameValidationDto {
  @ApiProperty({
    type: 'boolean',
    example: true,
    description: '가능한지 여부',
  })
  is_unique: boolean;
}

import { PartialType } from '@nestjs/mapped-types';
import { UsersModel } from '../entity/users.entity';
import { ApiProperty } from '@nestjs/swagger';
import { IsOptional } from 'class-validator';

export class UpdateUserDto extends PartialType(UsersModel) {
  @ApiProperty({
    type: 'string',
    example: '어린콩',
    description: '닉네임',
  })
  @IsOptional()
  nickname?: string;

  @ApiProperty({
    type: 'string',
    example: 'https://sldkjfds/dsflkdsjf.png',
    description: '이미지 링크',
  })
  @IsOptional()
  image_url?: string;
}

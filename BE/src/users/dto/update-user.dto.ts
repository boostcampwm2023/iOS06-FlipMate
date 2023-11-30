import { PartialType } from '@nestjs/mapped-types';
import { UsersModel } from '../entity/users.entity';
import { ApiProperty } from '@nestjs/swagger';
import { IsOptional } from 'class-validator';

export class UpdateUserDto extends PartialType(UsersModel) {
  @ApiProperty({
    type: 'string',
    example: '어린콩',
    description: '닉네임',
    required: false,
  })
  @IsOptional()
  nickname?: string;

  @ApiProperty({
    type: 'string',
    format: 'binary',
    description: '이미지 파일',
    required: false,
  })
  @IsOptional()
  image?: Express.Multer.File;
}

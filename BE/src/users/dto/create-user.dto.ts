import { PickType } from '@nestjs/mapped-types';
import { UsersModel } from '../entity/users.entity';
import { ApiProperty } from '@nestjs/swagger';

export class CreateUserDto extends PickType(UsersModel, [
  'nickname',
  'email',
  'image_url',
]) {
  @ApiProperty({
    type: 'string',
    example: '어린콩',
    description: '닉네임',
  })
  nickname: string;

  @ApiProperty({
    type: 'string',
    example: 'https://sldkjfds/dsflkdsjf.png',
    description: '이미지 링크',
  })
  image_url: string;

  @ApiProperty({
    type: 'string',
    example: '2343242@ildskjf.com',
    description: '이메일',
  })
  email: string;
}

import { PickType } from '@nestjs/mapped-types';
import { UsersModel } from '../entity/users.entity';
import { ApiProperty } from '@nestjs/swagger';

export class CreateUserDto extends PickType(UsersModel, ['nickname', 'email']) {
  @ApiProperty({
    type: 'string',
    example: '어린콩',
    description: '닉네임',
    required: false,
  })
  nickname: string;

  @ApiProperty({
    type: 'string',
    example: '2343242@ildskjf.com',
    description: '이메일',
    required: true,
  })
  email: string;
}

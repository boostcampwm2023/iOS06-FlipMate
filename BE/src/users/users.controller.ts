import { Controller, Post, Delete, Patch, Get, Body } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { Users } from './users.entity';

@ApiTags('Users')
@Controller('users')
export class UsersController {
  @Post()
  @ApiOperation({ summary: '유저 회원 가입' })
  createUser(@Body() userData: Users) {}

  @Post('/auth')
  @ApiOperation({ summary: '유저 로그인' })
  authUser() {}

  @Delete()
  @ApiOperation({ summary: '유저 회원 탈퇴' })
  deleteUser() {}

  @Get('/nickname-validation')
  @ApiOperation({ summary: '유저 닉네임 중복 확인' })
  validateNickname() {}

  @Patch()
  @ApiOperation({ summary: '유저 정보 수정' })
  modifyUser() {}
}

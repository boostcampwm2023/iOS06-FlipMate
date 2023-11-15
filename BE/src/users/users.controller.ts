import { Controller, Post, Delete, Patch, Get } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';

@ApiTags('Users')
@Controller('users')
export class UsersController {
  @Post()
  @ApiOperation({ summary: '유저 회원 가입' })
  createUser() {}

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

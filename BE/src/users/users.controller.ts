import { Controller, Patch, Get } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';

@ApiTags('Users')
@Controller('users')
export class UsersController {
  @Get('/nickname-validation')
  @ApiOperation({ summary: '유저 닉네임 중복 확인' })
  validateNickname() {}

  @Patch()
  @ApiOperation({ summary: '유저 정보 수정' })
  updateInfo() {}
}

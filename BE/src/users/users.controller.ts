import { Controller, Get, Query } from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiOkResponse,
  ApiOperation,
  ApiQuery,
  ApiTags,
} from '@nestjs/swagger';
import { UsersService } from './users.service';

@ApiTags('Users')
@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get('/nickname-validation')
  @ApiOperation({ summary: '유저 닉네임 유효한지 확인' })
  @ApiQuery({
    name: 'nickname',
    example: '어린콩',
    required: true,
    type: String,
    description: '검증할 유저 닉네임',
  })
  @ApiOkResponse({
    type: Boolean,
    description: '닉네임 검증 확인 결과 true(사용가능), false(불가능)',
  })
  @ApiBadRequestResponse({
    description: '잘못된 요청',
  })
  async validateNickname(
    @Query('nickname') nickname: string,
  ): Promise<boolean> {
    return this.usersService.isUniqueNickname(nickname);
  }
}

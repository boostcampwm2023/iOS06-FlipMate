import { Controller, Get, Query } from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiOkResponse,
  ApiOperation,
  ApiQuery,
  ApiTags,
} from '@nestjs/swagger';

import { UsersService } from './users.service';
import { NicknameValidationDto } from './dto/response/nickname-validation.dto';
import { UserProfileDto } from './dto/response/user-profile.dto';
@ApiTags('로그인 페이지')
@Controller('user')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get('/nickname-validation')
  @ApiOperation({ summary: '유저 닉네임 유효한지 확인 (완)' })
  @ApiQuery({
    name: 'nickname',
    example: '어린콩',
    required: true,
    type: String,
    description: '검증할 유저 닉네임',
  })
  @ApiOkResponse({
    type: NicknameValidationDto,
    description: '닉네임 검증 확인 결과 true(사용가능), false(불가능)',
  })
  @ApiBadRequestResponse({
    description: '잘못된 요청',
  })
  async validateNickname(
    @Query('nickname') nickname: string,
  ): Promise<NicknameValidationDto> {
    return this.usersService.isUniqueNickname(nickname);
  }

  @Get('/profile')
  @ApiOperation({ summary: '유저 프로필 조회 (완)' })
  @ApiQuery({
    name: 'nickname',
    example: '어린콩',
    required: true,
    type: String,
    description: '검증할 유저 닉네임',
  })
  @ApiOkResponse({
    type: UserProfileDto,
    description: '유저 프로필 이미지 url',
  })
  @ApiBadRequestResponse({
    description: '잘못된 요청',
  })
  async getUserProfileByNickname(
    @Query('nickname') nickname: string,
  ): Promise<UserProfileDto> {
    return {
      image_url: await this.usersService.getUserProfileByNickname(nickname),
    };
  }
}

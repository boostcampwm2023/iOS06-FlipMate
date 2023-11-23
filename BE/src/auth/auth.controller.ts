import { AuthService } from './auth.service';

import {
  Controller,
  Get,
  UseGuards,
  Req,
  Res,
  Post,
  Body,
  Patch,
} from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { Response } from 'express';
import { AccessTokenGuard } from './guard/bearer-token.guard';
import { User } from 'src/users/decorator/user.decorator';
import {
  ApiBearerAuth,
  ApiExcludeEndpoint,
  ApiOperation,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { UsersService } from 'src/users/users.service';
import { UpdateUserDto } from 'src/users/dto/update-user.dto';
import { UsersModel } from 'src/users/entity/users.entity';

@ApiTags('로그인 페이지')
@Controller('auth')
export class AuthController {
  constructor(
    private readonly authService: AuthService,
    private readonly usersService: UsersService,
  ) {}

  @Get('google')
  @UseGuards(AuthGuard('google'))
  @ApiExcludeEndpoint()
  googleAuth(@Req() req) {
    const user = req.user;
    return this.authService.loginWithGoogle(user);
  }

  @Post('google/app')
  @ApiOperation({ summary: 'Google 아이폰용 로그인 (완)' })
  @ApiResponse({ status: 201, description: '인증 성공' })
  @ApiResponse({ status: 401, description: '인증 실패' })
  async googleAppAuth(@Body('access_token') accessToken: string) {
    const email = await this.authService.getUserInfo(accessToken);
    return this.authService.loginWithGoogle({ email, auth_type: 'google' });
  }

  @Get('logout')
  @UseGuards(AccessTokenGuard)
  @ApiExcludeEndpoint()
  logout(@User('id') userId: number, @Res() res: Response) {
    console.log(`${userId}를 로그아웃 시키는 로직`);
    res.redirect('/');
  }

  @Patch('info')
  @UseGuards(AccessTokenGuard)
  @ApiOperation({ summary: '유저 정보 설정 (완)' })
  @ApiResponse({ status: 200, description: '프로필 변경 성공' })
  @ApiResponse({ status: 400, description: '잘못된 요청' })
  @ApiResponse({ status: 401, description: '인증 실패' })
  @ApiBearerAuth()
  patchUser(
    @User('id') user_id: number,
    @Body() user: UpdateUserDto,
  ): Promise<UsersModel> {
    return this.usersService.updateUser(user_id, user);
  }
}

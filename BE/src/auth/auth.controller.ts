import { AuthService } from './auth.service';

import { Controller, Get, UseGuards, Req, Res } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { Response } from 'express';
import { AccessTokenGuard } from './guard/bearer-token.guard';
import { User } from 'src/users/decorator/user.decorator';
import {
  ApiBearerAuth,
  ApiOperation,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';

@ApiTags('auth')
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Get('google')
  @UseGuards(AuthGuard('google'))
  @ApiOperation({ summary: 'Google 로그인' })
  @ApiResponse({ status: 200, description: '로그인 성공' })
  @ApiResponse({ status: 401, description: '인증 실패' })
  googleAuth(@Req() req) {
    const user = req.user;
    return this.authService.loginWithGoogle(user);
  }

  @Get('logout')
  @UseGuards(AccessTokenGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: '로그아웃' })
  @ApiResponse({ status: 200, description: '로그아웃 성공' })
  @ApiResponse({ status: 401, description: '인증 실패' })
  logout(@User('id') userId: number, @Res() res: Response) {
    console.log(`${userId}를 로그아웃 시키는 로직`);
    res.redirect('/');
  }
}

import { AuthService } from './auth.service';

import { Controller, Get, UseGuards, Req, Res } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { Request, Response } from 'express';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Get('')
  @UseGuards(AuthGuard('google'))
  async googleAuth() {} // Google 로그인 페이지로 리디렉션합니다

  @Get('google')
  @UseGuards(AuthGuard('google'))
  googleAuthRedirect(@Req() req) {
    const user = req.user;
    return this.authService.loginWithGoogle(user);
  }

  @Get('logout')
  logout(@Req() req: Request, @Res() res: Response) {
    res.redirect('/');
  }
}

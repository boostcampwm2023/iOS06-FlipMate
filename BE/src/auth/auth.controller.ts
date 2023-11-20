import { AuthService } from './auth.service';

import { Controller, Get, UseGuards, Req, Res } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { Response } from 'express';
import { AccessTokenGuard } from './guard/bearer-token.guard';
import { User } from 'src/users/decorator/user.decorator';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Get('google')
  @UseGuards(AuthGuard('google'))
  googleAuth(@Req() req) {
    const user = req.user;
    return this.authService.loginWithGoogle(user);
  }

  @Get('logout')
  @UseGuards(AccessTokenGuard)
  logout(@User('id') userId: number, @Res() res: Response) {
    console.log(`${userId}를 로그아웃 시키는 로직`);
    res.redirect('/');
  }
}

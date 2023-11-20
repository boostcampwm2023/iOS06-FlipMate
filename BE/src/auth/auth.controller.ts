import { AuthService } from './auth.service';

import { Controller, Get, UseGuards, Req, Res } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { Request, Response } from 'express';
import { AccessTokenGuard } from './guard/bearer-token.guard';

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
  logout(@Req() req: Request, @Res() res: Response) {
    res.redirect('/');
  }
}

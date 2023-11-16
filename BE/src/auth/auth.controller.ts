import { AuthService } from './auth.service';

import { Controller, Get, UseGuards, Req, Res } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { Request, Response } from 'express';
import { UsersService } from 'src/users/users.service';

@Controller('auth')
export class AuthController {
  constructor(
    private readonly authService: AuthService,
    private readonly usersService: UsersService,
  ) {}

  @Get('')
  @UseGuards(AuthGuard('google'))
  async googleAuth() {} // Google 로그인 페이지로 리디렉션합니다

  @Get('google')
  @UseGuards(AuthGuard('google'))
  async googleAuthRedirect(@Req() req) {
    const user = req.user;
    const prevUser = await this.usersService.findUserByEmail(user.email);
    if (!prevUser) {
      const userEntity = {
        nickname: 'test',
        google_id: user.email,
        image_url: '',
      };
      await this.usersService.createUser(userEntity);
    }
    return { message: '로그인 성공' };
  }

  @Get('logout')
  logout(@Req() req: Request, @Res() res: Response) {
    res.redirect('/');
  }
}

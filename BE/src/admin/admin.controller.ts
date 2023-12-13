import { Body, Controller, Post } from '@nestjs/common';
import { ApiExcludeEndpoint } from '@nestjs/swagger';
import { AuthService } from 'src/auth/auth.service';
import { MATES_MAXIMUM } from 'src/common/const/service-var.const';
import { MatesService } from 'src/mates/mates.service';
import { UsersService } from 'src/users/users.service';

@Controller('admin')
export class AdminController {
  constructor(
    private readonly authService: AuthService,
    private readonly matesService: MatesService,
    private readonly usersService: UsersService,
  ) {}

  /**
   * mockUser를 생성하기 위한 Admin전용 함수입니다.
   */
  @ApiExcludeEndpoint()
  @Post('create-mock-user')
  async createMockUsers(@Body('emails') emails: Array<{ email: string }>) {
    const createdUsers = [];
    for (const { email } of emails) {
      const { access_token } = await this.authService.loginWithOAuth({
        email,
        auth_type: 'google',
      });
      const { nickname } = this.authService.verifyToken(access_token);
      createdUsers.push({ email, access_token, nickname });
    }

    for (let idx = 0; idx < createdUsers.length; idx++) {
      const email = createdUsers[idx].email;
      const me = await this.usersService.findUserByEmailAndAuthType(
        email,
        'google',
      );
      for (let i = 1; i <= MATES_MAXIMUM; i++) {
        const friendIdx = (idx + i) % createdUsers.length;
        const friendNickname = createdUsers[friendIdx].nickname;
        try {
          await this.matesService.addMate(me, friendNickname);
        } catch (e) {
          console.log(e);
        }
      }
    }
    return createdUsers;
  }
}

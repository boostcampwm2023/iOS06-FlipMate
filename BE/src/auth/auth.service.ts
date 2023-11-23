import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { UsersService } from 'src/users/users.service';

@Injectable()
export class AuthService {
  constructor(
    private readonly jwtService: JwtService,
    private readonly usersService: UsersService,
  ) {}

  public extractBearerTokenFromHeader(header: string) {
    const splitToken = header.split(' ');

    if (splitToken.length !== 2 || splitToken[0] !== 'Bearer') {
      throw new UnauthorizedException('잘못된 토큰입니다!');
    }

    const token = splitToken[1];

    return token;
  }

  public verifyToken(token: string) {
    try {
      return this.jwtService.verify(token);
    } catch (e) {
      throw new UnauthorizedException('유효하지 않은 토큰입니다!');
    }
  }

  private signToken(user) {
    const payload = {
      email: user.email,
      nickname: user.nickname,
      type: 'access',
      auth_type: 'google',
    };
    return this.jwtService.sign(payload);
  }

  public async loginWithGoogle(user) {
    const prevUser = await this.usersService.findUserByEmail(user.email);
    if (!prevUser) {
      const id = user.email.split('@')[0];
      const userEntity = {
        nickname:
          id + Buffer.from(user.email + user.auth_type).toString('base64'),
        email: user.email,
        image_url: '',
      };
      const newUser = await this.usersService.createUser(userEntity);
      return {
        access_token: this.signToken(newUser),
        is_member: false,
      };
    }
    return {
      access_token: this.signToken(prevUser),
      is_member: true,
    };
  }

  public async getUserInfo(accessToken: string): Promise<string> {
    const url = 'https://www.googleapis.com/oauth2/v2/userinfo';
    try {
      const response = await fetch(url, {
        method: 'GET',
        headers: {
          Authorization: `Bearer ${accessToken}`,
        },
      });
      if (!response.ok) {
        throw new UnauthorizedException('유효하지 않은 토큰입니다.');
      }
      const { email } = await response.json();
      return email;
    } catch (error) {
      throw error;
    }
  }
}

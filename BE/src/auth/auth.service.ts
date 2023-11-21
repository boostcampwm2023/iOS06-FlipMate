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
    };
    return this.jwtService.sign(payload);
  }

  public async loginWithGoogle(user) {
    let prevUser = await this.usersService.findUserByEmail(user.email);
    if (!prevUser) {
      const userEntity = {
        nickname: 'test',
        email: user.email,
        image_url: '',
      };
      prevUser = await this.usersService.createUser(userEntity);
    }
    return this.signToken(prevUser);
  }
}

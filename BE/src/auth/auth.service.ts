import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { UsersService } from 'src/users/users.service';

@Injectable()
export class AuthService {
  constructor(
    private readonly jwtService: JwtService,
    private readonly usersService: UsersService,
  ) {}
  private signToken(user) {
    const payload = {
      email: user.email,
      nickname: user.nickname,
      type: 'access',
    };
    return this.jwtService.sign(payload, {
      secret: 'slkdjf',
      expiresIn: 300,
    });
  }

  public async loginWithGoogle(user) {
    let prevUser = await this.usersService.findUserByEmail(user.email);
    if (!prevUser) {
      const userEntity = {
        nickname: 'test',
        google_id: user.email,
        image_url: '',
      };
      prevUser = await this.usersService.createUser(userEntity);
    }
    return this.signToken(prevUser);
  }
}

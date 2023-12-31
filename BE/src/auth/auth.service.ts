import {
  Injectable,
  NotFoundException,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { UsersModel } from 'src/users/entity/users.entity';
import { UsersService } from 'src/users/users.service';
import crypto from 'crypto';
import jwt from 'jsonwebtoken';

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
      auth_type: user.auth_type,
    };
    return this.jwtService.sign(payload);
  }

  public async loginWithOAuth(user) {
    const prevUser = await this.usersService.findUserByEmailAndAuthType(
      user.email,
      user.auth_type,
    );
    if (!prevUser) {
      const id = user.email.split('@')[0];
      const userEntity = {
        nickname:
          id.slice(0, 20) +
          Buffer.from(user.email + user.auth_type).toString('base64'),
        email: user.email,
        auth_type: user.auth_type,
      } as UsersModel;
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
        throw new UnauthorizedException('유효하지 않은 구글 토큰입니다.');
      }
      const { email } = await response.json();
      return email;
    } catch (error) {
      throw error;
    }
  }

  public async getAppleUserInfo(JWT: string): Promise<string> {
    const { header, payload } = this.jwtService.decode(JWT, { complete: true });

    if (!header || !payload)
      throw new UnauthorizedException('유효하지 않은 토큰입니다.');
    if (payload['iss'] !== 'https://appleid.apple.com')
      throw new UnauthorizedException('유효하지 않은 토큰입니다.');
    if (payload['exp'] < Date.now() / 1000)
      throw new UnauthorizedException('유효하지 않은 토큰입니다.');

    try {
      const url = 'https://appleid.apple.com/auth';
      const res = await fetch(`${url}/keys`, {
        method: 'GET',
      });
      if (!res.ok) {
        throw new NotFoundException('Apple 키를 찾을 수 없습니다.');
      }
      const { keys } = await res.json();

      const { kty, n, e } = keys.find((key) => key.kid === header['kid']);
      const pem = this.createPem(kty, n, e);
      const decoded = jwt.verify(JWT, pem, {
        algorithms: ['RS256'],
      });
      return decoded['email'];
    } catch (error) {
      if (error.message === 'invalid signature') {
        throw new UnauthorizedException('토큰 검증 실패');
      }
      throw error;
    }
  }

  private createPem(kty, n, e) {
    const JWK = crypto.createPublicKey({
      format: 'jwk',
      key: {
        kty,
        n,
        e,
      },
    });

    return JWK.export({
      type: 'pkcs1',
      format: 'pem',
    });
  }
}

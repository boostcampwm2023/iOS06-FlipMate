import { PassportStrategy } from '@nestjs/passport';
import { Strategy, VerifyCallback } from 'passport-google-oauth20';
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class GoogleStrategy extends PassportStrategy(Strategy, 'google') {
  constructor(private config: ConfigService) {
    super({
      clientID: config.get('GOOGLE_CLIENT_ID'),
      clientSecret: config.get('GOOGLE_CLIENT_SECRET'),
      callbackURL: 'http://localhost:3000/auth/google',
      scope: ['email'],
    });
  }

  async validate(
    accessToken: string,
    refreshToken: string,
    email: any,
    done: VerifyCallback,
  ): Promise<any> {
    const user = {
      email: email.emails[0].value,
      accessToken,
    };
    done(null, user);
  }
}

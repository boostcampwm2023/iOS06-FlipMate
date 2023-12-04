import { ConfigService } from '@nestjs/config';
import { ENV } from '../const/env-keys.const';

export const jwtConfig = (configService: ConfigService) => ({
  secret: configService.get<string>(ENV.JWT_SECRET),
  signOptions: { expiresIn: configService.get<number>(ENV.JWT_EXPIRES_IN) },
});

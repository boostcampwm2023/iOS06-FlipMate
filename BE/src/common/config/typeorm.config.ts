import { ConfigService } from '@nestjs/config';
import { TypeOrmModuleOptions } from '@nestjs/typeorm';
import { Categories } from 'src/categories/categories.entity';
import { Mates } from 'src/mates/mates.entity';
import { StudyLogs } from 'src/study-logs/study-logs.entity';
import { UsersModel } from 'src/users/entity/users.entity';
import { ENV } from '../const/env-keys.const';

export const typeormConfig = (config: ConfigService): TypeOrmModuleOptions => ({
  type: 'mysql',
  host: config.get<string>(ENV.DATABASE_HOST),
  port: config.get<number>(ENV.DATABASE_PORT),
  username: config.get<string>(ENV.DATABASE_USERNAME),
  password: config.get<string>(ENV.DATABASE_PASSWORD),
  database: config.get<string>(ENV.DATABASE_NAME),
  charset: 'utf8mb4_unicode_ci',
  entities: [StudyLogs, Categories, UsersModel, Mates],
  timezone: 'Z',
  synchronize: true,
});

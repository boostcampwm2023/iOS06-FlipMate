import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { StudyLogsModule } from './study-logs/study-logs.module';
import { StudyLogs } from './study-logs/study-logs.entity';
import { Categories } from './categories/categories.entity';
import { CategoriesModule } from './categories/categories.module';
import { MatesModule } from './mates/mates.module';
import { UsersModule } from './users/users.module';
import { Users } from './users/users.entity';
import { GoogleStrategy } from './google.strategy';
import { PassportModule } from '@nestjs/passport';
import { AuthModule } from './auth/auth.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    TypeOrmModule.forRootAsync({
      useFactory: (config: ConfigService) => ({
        type: 'mysql',
        host: config.get<string>('DATABASE_HOST'),
        port: config.get<number>('DATABASE_PORT'),
        username: config.get<string>('DATABASE_USERNAME'),
        password: config.get<string>('DATABASE_PASSWORD'),
        database: config.get<string>('DATABASE_NAME'),
        entities: [StudyLogs, Categories, Users],
        synchronize: true,
      }),
      inject: [ConfigService],
    }),
    StudyLogsModule,
    CategoriesModule,
    MatesModule,
    UsersModule,
    PassportModule,
    AuthModule,
  ],
  controllers: [AppController],
  providers: [AppService, GoogleStrategy],
})
export class AppModule {}

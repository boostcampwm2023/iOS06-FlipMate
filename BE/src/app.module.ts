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
import { UsersModel } from './users/entity/users.entity';
import { PassportModule } from '@nestjs/passport';
import { AuthModule } from './auth/auth.module';
import { ServeStaticModule } from '@nestjs/serve-static';
import { join } from 'path';

@Module({
  imports: [
    ServeStaticModule.forRoot({
      rootPath: join(__dirname, '../../..', 'apps'),
      serveRoot: '/',
      renderPath: '/',
    }),
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
        entities: [StudyLogs, Categories, UsersModel],
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
  providers: [AppService],
})
export class AppModule {}

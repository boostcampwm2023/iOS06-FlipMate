import { MiddlewareConsumer, Module, NestModule } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { StudyLogsModule } from './study-logs/study-logs.module';
import { CategoriesModule } from './categories/categories.module';
import { MatesModule } from './mates/mates.module';
import { UsersModule } from './users/users.module';
import { PassportModule } from '@nestjs/passport';
import { AuthModule } from './auth/auth.module';
import { ServeStaticModule } from '@nestjs/serve-static';
import { LoggingMiddleware } from './common/middleware/logging.middleware';
import { typeormConfig } from './common/config/typeorm.config';
import { staticConfig } from './common/config/static.config';

@Module({
  imports: [
    ServeStaticModule.forRoot(staticConfig),
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    TypeOrmModule.forRootAsync({
      useFactory: typeormConfig,
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
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer.apply(LoggingMiddleware).forRoutes('*');
  }
}

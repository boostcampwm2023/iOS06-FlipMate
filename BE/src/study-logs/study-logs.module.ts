import { Module } from '@nestjs/common';
import { StudyLogsService } from './study-logs.service';
import { StatsController, StudyLogsController } from './study-logs.controller';
import { StudyLogs } from './study-logs.entity';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthModule } from 'src/auth/auth.module';
import { UsersModule } from 'src/users/users.module';
import { RedisService } from 'src/common/redis.service';

@Module({
  imports: [TypeOrmModule.forFeature([StudyLogs]), AuthModule, UsersModule],
  providers: [StudyLogsService, RedisService],
  controllers: [StudyLogsController, StatsController],
  exports: [StudyLogsService, TypeOrmModule],
})
export class StudyLogsModule {}

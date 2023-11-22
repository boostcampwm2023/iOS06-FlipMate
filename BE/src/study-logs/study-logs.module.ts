import { Module } from '@nestjs/common';
import { StudyLogsService } from './study-logs.service';
import { StatsController, StudyLogsController } from './study-logs.controller';
import { StudyLogs } from './study-logs.entity';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthModule } from 'src/auth/auth.module';
import { UsersModule } from 'src/users/users.module';

@Module({
  imports: [TypeOrmModule.forFeature([StudyLogs]), AuthModule, UsersModule],
  providers: [StudyLogsService],
  controllers: [StudyLogsController, StatsController],
})
export class StudyLogsModule {}

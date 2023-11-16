import { Module } from '@nestjs/common';
import { StudyLogsService } from './study-logs.service';
import { StatsController, StudyLogsController } from './study-logs.controller';
import { StudyLogs } from './study-logs.entity';
import { TypeOrmModule } from '@nestjs/typeorm';

@Module({
  imports: [TypeOrmModule.forFeature([StudyLogs])],
  providers: [StudyLogsService],
  controllers: [StudyLogsController, StatsController],
})
export class StudyLogsModule {}

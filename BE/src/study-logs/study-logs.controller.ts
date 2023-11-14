import { Body, Controller, Post } from '@nestjs/common';
import { StudyLogsService } from './study-logs.service';
import { StudyLogs } from './study-logs.entity';

@Controller('study-logs')
export class StudyLogsController {
  constructor(private readonly studyLogsService: StudyLogsService) {}

  @Post()
  createStudyLogs(@Body() studyLogsData: StudyLogs): Promise<StudyLogs> {
    return this.studyLogsService.create(studyLogsData);
  }
}

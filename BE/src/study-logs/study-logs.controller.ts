import { Body, Controller, Post } from '@nestjs/common';
import { StudyLogsService } from './study-logs.service';
import { StudyLogs } from './study-logs.entity';
import {
  ApiBadRequestResponse,
  ApiCreatedResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';

@ApiTags('Timer')
@Controller('study-logs')
export class StudyLogsController {
  constructor(private readonly studyLogsService: StudyLogsService) {}

  @Post()
  @ApiOperation({ summary: '학습시간 생성 및 종료' })
  @ApiCreatedResponse({
    type: StudyLogs,
    description: '학습 기록이 성공적으로 생성되었습니다.',
  })
  @ApiBadRequestResponse({
    description: '잘못된 요청입니다.',
  })
  createStudyLogs(@Body() studyLogsData: StudyLogs): Promise<StudyLogs> {
    return this.studyLogsService.create(studyLogsData);
  }
}

import { Body, Controller, Get, Post, Query, UseGuards } from '@nestjs/common';
import { StudyLogsService } from './study-logs.service';
import { StudyLogs } from './study-logs.entity';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { StudyLogsCreateDto } from './dto/request/create-study-logs.dto';
import { StudyLogsDto } from './dto/response/study-logs.dto';
import { AccessTokenGuard } from 'src/auth/guard/bearer-token.guard';
import { User } from 'src/users/decorator/user.decorator';

@ApiTags('타이머 페이지')
@Controller('study-logs')
export class StudyLogsController {
  constructor(private readonly studyLogsService: StudyLogsService) {}

  @Post()
  @UseGuards(AccessTokenGuard)
  @ApiOperation({ summary: '학습시간 생성 및 종료 (완)' })
  @ApiCreatedResponse({
    type: StudyLogsCreateDto,
    description: '학습 기록이 성공적으로 생성되었습니다.',
  })
  @ApiBadRequestResponse({
    description: '잘못된 요청입니다.',
  })
  @ApiBearerAuth()
  createStudyLogs(
    @User('id') userId: number,
    @Body() studyLogsData: StudyLogsCreateDto,
  ): Promise<StudyLogsDto> {
    return this.studyLogsService.create(studyLogsData, userId);
  }

  @Get()
  @UseGuards(AccessTokenGuard)
  @ApiOperation({ summary: '학습시간 조회' })
  @ApiCreatedResponse({
    type: StudyLogs,
    description: '학습 기록이 성공적으로 조회되었습니다.',
  })
  @ApiBadRequestResponse({
    description: '잘못된 요청입니다.',
  })
  @ApiBearerAuth()
  getStudyLogs(@User('id') userId: number): Promise<StudyLogsDto[]> {
    return this.studyLogsService.findByUserId(userId);
  }
}

@ApiTags('통계 페이지')
@Controller('/study-logs/stats')
export class StatsController {
  @Get()
  @ApiOperation({ summary: '일간 통계 조회하기' })
  getStats(
    @Query('year') year: number,
    @Query('month') month: number,
    @Query('day') day: number,
  ) {
    return { year, month, day };
  }

  @Get('/weekly')
  @ApiOperation({ summary: '주간 통계 조회하기' })
  getWeeklyStats() {}

  @Get('/monthly')
  @ApiOperation({ summary: '주간 통계 조회하기' })
  getMonthlyStats() {}
}

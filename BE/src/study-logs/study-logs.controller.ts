import { Body, Controller, Get, Post, Query, UseGuards } from '@nestjs/common';
import { StudyLogsService } from './study-logs.service';
import { StudyLogs } from './study-logs.entity';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiOperation,
  ApiQuery,
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
    const { created_at, learning_time } = studyLogsData;
    studyLogsData.date = this.studyLogsService.calculateStartDay(
      new Date(created_at),
      learning_time,
    );

    return this.studyLogsService.create(studyLogsData, userId);
  }

  @Get()
  @UseGuards(AccessTokenGuard)
  @ApiOperation({ summary: '학습시간 조회 (완)' })
  @ApiCreatedResponse({
    type: StudyLogs,
    description: '학습 기록이 성공적으로 조회되었습니다.',
  })
  @ApiBadRequestResponse({
    description: '잘못된 요청입니다.',
  })
  @ApiQuery({
    name: 'date',
    example: '2023-11-22',
    description: '날짜',
  })
  @ApiBearerAuth()
  getStudyLogs(
    @User('id') userId: number,
    @Query('date') date: string,
  ): Promise<object> {
    return this.studyLogsService.groupByCategory(userId, date);
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

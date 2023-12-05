import { Body, Controller, Get, Post, Query, UseGuards } from '@nestjs/common';
import { StudyLogsService } from './study-logs.service';
import { StudyLogs } from './study-logs.entity';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiOkResponse,
  ApiOperation,
  ApiQuery,
  ApiTags,
} from '@nestjs/swagger';
import { StudyLogsCreateDto } from './dto/request/create-study-logs.dto';
import { AccessTokenGuard } from 'src/auth/guard/bearer-token.guard';
import { User } from 'src/users/decorator/user.decorator';
import { ResponseDto } from 'src/common/response.dto';
import { dailyStatDto } from './dto/response/daily-stat.dto';
import moment from 'moment';

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
  async createStudyLogs(
    @User('id') userId: number,
    @Body() studyLogsData: StudyLogsCreateDto,
  ): Promise<ResponseDto> {
    const { created_at, learning_time, type } = studyLogsData;
    if (type === 'start') {
      await this.studyLogsService.createStartLog(studyLogsData, userId);
      return new ResponseDto(200, 'OK');
    }
    studyLogsData.date = this.studyLogsService.calculateStartDay(
      new Date(created_at),
      learning_time,
    );
    await this.studyLogsService.createFinishLog(studyLogsData, userId);
    return new ResponseDto(200, 'OK');
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
  constructor(private readonly studyLogsService: StudyLogsService) {}

  @Get()
  @UseGuards(AccessTokenGuard)
  @ApiOperation({ summary: '일간 통계 조회하기' })
  @ApiOkResponse({
    type: dailyStatDto,
    description: '일간 통계 조회 성공',
  })
  @ApiBadRequestResponse({
    description: '잘못된 요청입니다.',
  })
  @ApiQuery({
    name: 'date',
    example: '2023-11-22',
    description: '통계 조회 할 날짜',
  })
  @ApiBearerAuth()
  async getStats(@User('id') userId: number, @Query('date') date: string) {
    const studyLogData = await this.studyLogsService.groupByCategory(
      userId,
      date,
    );
    return {
      ...studyLogData,
      percentage: await this.studyLogsService.calculatePercentage(
        userId,
        date,
        date,
      ),
    };
  }

  @Get('/weekly')
  @UseGuards(AccessTokenGuard)
  @ApiQuery({
    name: 'date',
    example: '2023-11-22',
    description: '통계 조회 할 날짜',
  })
  @ApiOperation({ summary: '주간 통계 조회하기' })
  async getWeeklyStats(
    @User('id') userId: number,
    @Query('date') date: string,
  ) {
    const start_date = moment(date).subtract(6, 'days').format('YYYY-MM-DD');
    const daily_data = await this.studyLogsService.calculateTotalTimes(
      userId,
      start_date,
      date,
    );
    return {
      daily_data: daily_data,
      total_time: daily_data.reduce((acc, cur) => acc + cur, 0),
      primary_category: null,
      percentage: await this.studyLogsService.calculatePercentage(
        userId,
        start_date,
        date,
      ),
    };
  }

  @Get('/monthly')
  @ApiOperation({ summary: '주간 통계 조회하기' })
  getMonthlyStats() {}
}

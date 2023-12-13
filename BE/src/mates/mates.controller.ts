import {
  Controller,
  Delete,
  Get,
  Param,
  Post,
  Body,
  UseGuards,
  Query,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiBody,
  ApiCreatedResponse,
  ApiOperation,
  ApiQuery,
  ApiTags,
} from '@nestjs/swagger';
import { User } from 'src/users/decorator/user.decorator';
import { MatesService } from './mates.service';
import { StatusMessageDto } from './dto/response/status-message.dto';
import { AccessTokenGuard } from 'src/auth/guard/bearer-token.guard';
import { UsersModel } from 'src/users/entity/users.entity';
import { ResponseDto } from 'src/common/response.dto';

@Controller('mates')
@ApiTags('소셜 페이지')
export class MatesController {
  constructor(private readonly matesService: MatesService) {}
  @Get()
  @UseGuards(AccessTokenGuard)
  @ApiBearerAuth()
  @ApiCreatedResponse({
    description: 'OK',
  })
  @ApiBody({
    schema: {
      properties: {
        date: {
          type: 'datetime',
          example: '2023-11-22T14:00:00+09:00',
          description: '날짜',
        },
      },
    },
  })
  @ApiOperation({ summary: '모든 친구들 조회하기 (완)' })
  getMates(
    @User('id') user_id: number,
    @Body('date') date: string,
  ): Promise<object> {
    return this.matesService.getMates(user_id, date);
  }

  @Get('/status')
  @UseGuards(AccessTokenGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: '현재 친구들 상태 polling 조회하기' })
  getMatesStatus(@User('id') user_id: number): Promise<object[]> {
    return this.matesService.getMatesStatus(user_id);
  }

  @Get('/:following_id/stats')
  @UseGuards(AccessTokenGuard)
  @ApiQuery({
    name: 'datetime',
    example: '2023-11-22T14:00:00',
    description: '날짜',
  })
  @ApiQuery({
    name: 'timezone',
    example: '+09:00',
    description: '타임존',
  })
  @ApiBearerAuth()
  @ApiOperation({ summary: '특정 친구의 통계 조회하기' })
  getMateStats(
    @User('id') user_id: number,
    @Param('following_id') following_id: number,
    @Query('datetime') datetime: string,
    @Query('timezone') timezone: string,
  ): Promise<object> {
    timezone = timezone[0] === '-' ? timezone : `+${timezone.trim()}`;
    return this.matesService.getMateAndMyStats(
      user_id,
      following_id,
      datetime,
      timezone,
    );
  }

  @Post()
  @UseGuards(AccessTokenGuard)
  @ApiBearerAuth()
  @ApiCreatedResponse({
    description: '친구가 성공적으로 구독되었습니다.',
  })
  @ApiBody({
    schema: {
      properties: {
        following_nickname: {
          type: 'string',
          description: '구독할 닉네임',
          example: '어린콩',
        },
      },
    },
  })
  @ApiOperation({ summary: '친구 구독하기 (완)' })
  async createMate(
    @User() user: UsersModel,
    @Body('following_nickname') following_nickname: string,
  ): Promise<ResponseDto> {
    await this.matesService.addMate(user, following_nickname);
    return { statusCode: 201, message: '친구가 성공적으로 구독되었습니다.' };
  }

  @Get('search')
  @UseGuards(AccessTokenGuard)
  @ApiBearerAuth()
  @ApiCreatedResponse({
    description: '닉네임을 검색',
  })
  @ApiBody({
    schema: {
      properties: {
        following_nickname: {
          type: 'string',
          description: '검색할 닉네임',
          example: '어린콩',
        },
      },
    },
  })
  @ApiOperation({ summary: '친구 검색하기 (완)' })
  async findMate(
    @User() user: UsersModel,
    @Query('nickname') nickname: string,
  ): Promise<object> {
    return this.matesService.findMate(user, nickname);
  }

  @Delete('')
  @UseGuards(AccessTokenGuard)
  @ApiBearerAuth()
  @ApiBody({
    schema: {
      properties: {
        following_id: {
          type: 'number',
          description: '구독 취소할 유저의 id',
          example: '2',
        },
      },
    },
  })
  @ApiOperation({ summary: '구독한 친구 구독 취소하기 (완)' })
  async deleteMate(
    @User() user: UsersModel,
    @Body('following_id') following_id: number,
  ): Promise<StatusMessageDto> {
    await this.matesService.deleteMate(user, following_id);

    return {
      statusCode: 200,
      message: '성공적으로 삭제되었습니다.',
    };
  }
}

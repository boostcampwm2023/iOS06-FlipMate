import {
  Controller,
  Delete,
  Get,
  Param,
  Post,
  Body,
  UseGuards,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiBody,
  ApiCreatedResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { User } from 'src/users/decorator/user.decorator';
import { MatesService } from './mates.service';
import { MatesDto } from './dto/response/mates.dto';
import { StatusMessageDto } from './dto/response/status-message.dto';
import { AccessTokenGuard } from 'src/auth/guard/bearer-token.guard';
import { UsersModel } from 'src/users/entity/users.entity';

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
  @ApiOperation({ summary: '모든 친구들 조회하기 (완)' })
  getMates(@User('id') user_id: number): Promise<object> {
    return this.matesService.getMates(user_id);
  }

  @Get('/status')
  @UseGuards(AccessTokenGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: '현재 친구들 상태 polling 조회하기' })
  getMatesStatus(@User('id') user_id: number): Promise<object[]> {
    return this.matesService.getMatesStatus(user_id);
  }

  @Get('/:mate_id/stats')
  @UseGuards(AccessTokenGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: '특정 친구의 통계 조회하기' })
  getMateStats(@Param('mate_id') id: string) {
    id;
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
  createMate(
    @User() user: UsersModel,
    @Body('following_nickname') following_nickname: string,
  ): Promise<MatesDto> {
    return this.matesService.addMate(user, following_nickname);
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

import { Controller, Delete, Get, Param, Post } from '@nestjs/common';
import { ApiCreatedResponse, ApiOperation, ApiTags } from '@nestjs/swagger';

@Controller('mates')
@ApiTags('소셜 페이지')
export class MatesController {
  @Get()
  @ApiOperation({ summary: '모든 친구들 조회하기' })
  getMates() {}

  @Get('/:mate_id/stats')
  @ApiOperation({ summary: '특정 친구의 통계 조회하기' })
  getMateStats(@Param('mate_id') id: string) {
    id;
  }

  @Post()
  @ApiCreatedResponse({
    description: '친구가 성공적으로 구독되었습니다.',
  })
  @ApiOperation({ summary: '친구 구독하기' })
  crateMate() {}

  @Delete('/:mate_id')
  @ApiOperation({ summary: '구독한 친구 구독 취소하기' })
  deleteMate(@Param('mate_id') id: string) {
    id;
  }
}

import { ApiProperty } from '@nestjs/swagger';

export class StudyLogsCreateDto {
  @ApiProperty({
    example: '2023-11-23',
    description: '학습을 시작한 날짜',
  })
  date: string;

  @ApiProperty({
    type: 'date',
    example: '2023-11-23 11:00:12',
    description: '학습을 시작/종료 시점의 시간',
  })
  created_at: string;

  @ApiProperty({
    type: 'enum',
    example: 'start',
    description: '학습이 시작인지 종료인지에 대한 타입',
  })
  type: 'start' | 'finish';

  @ApiProperty({
    type: 'number',
    example: 3600,
    description: '학습시간 (초 단위)',
  })
  learning_time: number;

  @ApiProperty({
    type: 'number',
    example: 1,
    description: '카테고리 아이디',
  })
  category_id: number;
}

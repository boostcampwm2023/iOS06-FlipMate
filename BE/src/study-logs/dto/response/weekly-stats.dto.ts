import { ApiProperty } from '@nestjs/swagger';

export class weeklyStatDto {
  @ApiProperty({
    type: 'number',
    example: 10000,
    description: '일주일동안의 총 학습 시간',
  })
  total_time: number;

  @ApiProperty({
    type: 'array',
    items: { type: 'number' },
    example: [0, 0, 13, 12, 33, 12, 4],
    description: '일주일동안 학습한 시간들 배열 (길이 7)',
  })
  daily_data: number[];

  @ApiProperty({
    type: 'string',
    example: '백준',
    description: '일주일동안 가장 주된 카테고리',
  })
  primary_category: string;

  @ApiProperty({
    type: 'number',
    example: '3.33',
    description: '해당 날짜에 유저의 학습 시간이 전체 유저 중 상위 몇 %인지',
  })
  percentage: number;
}

import { ApiProperty } from '@nestjs/swagger';

export class MatesDto {
  @ApiProperty({
    type: 'number',
    example: '1',
    description: '친구 관계 id',
  })
  id: number;

  @ApiProperty({
    type: 'number',
    example: 1,
    description: '구독의 주체 id (1이 2를 구독중)',
  })
  follower_id: number;

  @ApiProperty({
    type: 'number',
    example: 2,
    description: '구독 중인 친구 id',
  })
  following_id: number;
}

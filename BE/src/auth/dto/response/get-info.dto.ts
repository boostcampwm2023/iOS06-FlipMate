import { ApiProperty } from '@nestjs/swagger';

export class GetInfoDto {
  @ApiProperty({
    type: 'string',
    example: '어린콩',
    description: '닉네임',
  })
  nickname: string;

  @ApiProperty({
    type: 'string',
    example: 'example@co.kr',
    description: '이메일',
  })
  email: string;

  @ApiProperty({
    type: 'string',
    example: 'https://imageurl.com',
    description: '이미지 경로',
  })
  image_url: string;

  @ApiProperty({
    type: 'number',
    example: 20,
    description: '팔로워 수',
  })
  follower_count: number;

  @ApiProperty({
    type: 'number',
    example: 10,
    description: '팔로잉 수',
  })
  following_count: number;
}

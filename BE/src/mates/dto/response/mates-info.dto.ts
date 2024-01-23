import { ApiProperty } from '@nestjs/swagger';

export class MatesInfoDto {
  @ApiProperty({
    type: 'number',
    example: 1,
    description: '친구 관계 id',
  })
  id: number;

  @ApiProperty({
    type: 'string',
    example: '어린콩',
    description: '친구 닉네임',
  })
  nickname: string;

  @ApiProperty({
    type: 'string',
    example: 'https://imageurl.com',
    description: '친구 이미지 경로',
  })
  image_url: string;
}

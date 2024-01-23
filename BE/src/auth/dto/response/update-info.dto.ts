import { ApiProperty } from '@nestjs/swagger';

export class UpdateInfoDto {
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
}

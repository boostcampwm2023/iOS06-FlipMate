import { ApiProperty } from '@nestjs/swagger';

export class UserProfileDto {
  @ApiProperty({
    type: 'string',
    example: 'https://imgurl.com/path/file.png',
    description: '유저 프로필 사진',
  })
  image_url: string;
}

import { ApiProperty } from '@nestjs/swagger';

export class ResponseDto {
  @ApiProperty({
    type: 'number',
    example: 200,
    description: '상태 코드',
  })
  statusCode: number;

  @ApiProperty({
    type: 'string',
    example: '요청이 정상적으로 처리되었습니다.',
    description: '메세지',
  })
  message: string;

  constructor(statusCode: number, message: string) {
    this.statusCode = statusCode;
    this.message = message;
  }
}

import { ApiProperty } from '@nestjs/swagger';

export class StatusMessageDto {
  @ApiProperty({
    type: 'number',
    example: 200,
    description: '상태 코드',
  })
  statusCode: number;

  @ApiProperty({
    type: 'string',
    example: '성공적으로 삭제되었습니다.',
    description: '메시지',
  })
  message: string;
}

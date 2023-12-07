import { Controller, Get, UseGuards } from '@nestjs/common';
import { HeartbeatService } from './heartbeat.service';
import { User } from 'src/users/decorator/user.decorator';
import { AccessTokenGuard } from 'src/auth/guard/bearer-token.guard';

@Controller()
export class HeartbeatController {
  constructor(private readonly heartbeatsService: HeartbeatService) {}

  @UseGuards(AccessTokenGuard)
  @Get('/heartbeat')
  heartbeat(@User('id') userId: number) {
    this.heartbeatsService.recordHeartbeat(userId);
    return { statusCode: 200, message: 'OK' };
  }
}

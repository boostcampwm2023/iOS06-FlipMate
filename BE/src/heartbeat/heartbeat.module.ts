import { Module } from '@nestjs/common';
import { HeartbeatService } from './heartbeat.service';
import { HeartbeatController } from './heartbeat.controller';
import { AuthModule } from 'src/auth/auth.module';
import { UsersModule } from 'src/users/users.module';
import { RedisService } from 'src/common/redis.service';

@Module({
  imports: [AuthModule, UsersModule],
  controllers: [HeartbeatController],
  providers: [HeartbeatService, RedisService],
})
export class HeartbeatModule {}

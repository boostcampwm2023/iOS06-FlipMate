import { Module } from '@nestjs/common';
import { HeartbeatService } from './heartbeat.service';
import { HeartbeatController } from './heartbeat.controller';
import { AuthModule } from 'src/auth/auth.module';
import { UsersModule } from 'src/users/users.module';
import { RedisService } from 'src/common/redis.service';
import { StudyLogsModule } from 'src/study-logs/study-logs.module';

@Module({
  imports: [AuthModule, UsersModule, StudyLogsModule],
  controllers: [HeartbeatController],
  providers: [HeartbeatService, RedisService],
})
export class HeartbeatModule {}

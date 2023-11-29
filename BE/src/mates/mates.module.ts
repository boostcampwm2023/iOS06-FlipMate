import { Module } from '@nestjs/common';
import { MatesController } from './mates.controller';
import { MatesService } from './mates.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Mates } from './mates.entity';
import { AuthModule } from 'src/auth/auth.module';
import { UsersModule } from 'src/users/users.module';
import { RedisService } from 'src/common/redis.service';
import { StudyLogsModule } from 'src/study-logs/study-logs.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([Mates]),
    AuthModule,
    UsersModule,
    StudyLogsModule,
  ],
  controllers: [MatesController],
  providers: [MatesService, RedisService],
})
export class MatesModule {}

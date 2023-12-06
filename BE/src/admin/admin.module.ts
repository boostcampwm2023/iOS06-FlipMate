import { Module } from '@nestjs/common';
import { AdminController } from './admin.controller';
import { AuthModule } from 'src/auth/auth.module';
import { UsersModule } from 'src/users/users.module';
import { MatesModule } from 'src/mates/mates.module';

@Module({
  imports: [AuthModule, UsersModule, MatesModule],
  controllers: [AdminController],
})
export class AdminModule {}

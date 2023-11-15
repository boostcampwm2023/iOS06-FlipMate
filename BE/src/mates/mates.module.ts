import { Module } from '@nestjs/common';
import { MatesController } from './mates.controller';

@Module({
  controllers: [MatesController],
})
export class MatesModule {}

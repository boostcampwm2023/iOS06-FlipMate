import { Module } from '@nestjs/common';
import { UsersController } from './users.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UsersModel } from './entity/users.entity';
import { UsersService } from './users.service';
import { S3Service } from 'src/common/s3.service';

@Module({
  imports: [TypeOrmModule.forFeature([UsersModel])],
  exports: [UsersService, TypeOrmModule],
  controllers: [UsersController],
  providers: [UsersService, S3Service],
})
export class UsersModule {}

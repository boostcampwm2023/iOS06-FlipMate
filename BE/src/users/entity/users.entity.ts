import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import { IsEmail, IsOptional, IsString, Length } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { StudyLogs } from 'src/study-logs/study-logs.entity';
import { Categories } from 'src/categories/categories.entity';
import { AuthTypeEnum } from '../const/auth-type.const';
import { Mates } from 'src/mates/mates.entity';

@Entity()
export class UsersModel {
  @PrimaryGeneratedColumn()
  id: number;

  @ApiProperty({
    type: 'string',
    example: 'nickname123',
    description: '유저 닉네임',
  })
  @Column({
    length: 84,
    unique: true,
  })
  @IsString()
  @Length(1, 84)
  nickname: string;

  @ApiProperty({
    type: 'string',
    example: 'google_email@email.com',
    description: 'OAuth로 로그인 한 구글 계정 아이디',
  })
  @Column()
  @IsString()
  @IsEmail()
  email: string;

  @ApiProperty({
    type: 'string',
    example: 'https://imgurl.com/path/file.png',
    description: '유저 프로필 사진',
  })
  @Column({
    nullable: true,
  })
  @IsOptional()
  image_url?: string;

  @Column({
    type: 'enum',
    enum: AuthTypeEnum,
    default: AuthTypeEnum.GOOGLE,
  })
  auth_type: AuthTypeEnum;

  @Column({
    type: 'char',
    default: '+09:00',
    length: 6,
  })
  timezone: string;

  @Column({
    type: 'boolean',
    default: false,
  })
  is_studying: boolean;

  @OneToMany(() => StudyLogs, (studyLog) => studyLog.user_id)
  study_logs: StudyLogs[];

  @OneToMany(() => Categories, (category) => category.user_id)
  categories: Categories[];

  @OneToMany(() => Mates, (mate) => mate.follower_id)
  follower: Mates[];

  @OneToMany(() => Mates, (mate) => mate.following_id)
  following: Mates[];
}

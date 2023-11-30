import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  OneToMany,
  JoinColumn,
} from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';
import { UsersModel } from 'src/users/entity/users.entity';
import { StudyLogs } from 'src/study-logs/study-logs.entity';
import { IsString, Length, Matches } from 'class-validator';

@Entity()
export class Categories {
  @PrimaryGeneratedColumn()
  id: number;

  @ApiProperty({
    type: 'string',
    example: '백준',
    description: '카테고리 이름',
  })
  @Column({
    type: 'char',
    length: 50,
  })
  @IsString()
  @Length(1, 50)
  name: string;

  @ApiProperty({
    type: 'string',
    example: 'FFFFFFFF',
    description: '카테고리 색상',
  })
  @Column({
    type: 'char',
    length: 8,
  })
  @IsString()
  @Length(1, 8)
  @Matches(/^[0-9A-F]{1,8}$/i, {message: '올바른 색상 코드가 아닙니다.'})
  color_code: string;

  @ManyToOne(() => UsersModel, (user) => user.categories, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'user_id' })
  user_id: UsersModel;

  @OneToMany(() => StudyLogs, (studyLog) => studyLog.category_id)
  study_logs: StudyLogs[];
}

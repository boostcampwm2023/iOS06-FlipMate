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
  color_code: string;

  @ManyToOne(() => UsersModel, (user) => user.categories)
  @JoinColumn({ name: 'user_id' })
  user_id: UsersModel;

  @OneToMany(() => StudyLogs, (studyLog) => studyLog.category_id)
  study_logs: StudyLogs[];
}

import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { UsersModel } from 'src/users/entity/users.entity';
import { Categories } from 'src/categories/categories.entity';
import { IsNumber, IsString, Matches } from 'class-validator';

@Entity()
export class StudyLogs {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'date' })
  @IsString()
  @Matches(/^\d{4}-\d{2}-\d{2}$/i, { message: '올바른 날짜 형식이 아닙니다.' })
  date: Date;

  @Column({ type: 'datetime' })
  @IsString()
  @Matches(/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/i, {
    message: '올바른 시간 형식이 아닙니다.',
  })
  created_at: Date;

  @Column({ type: 'enum', enum: ['start', 'finish'] })
  @IsString()
  @Matches(/^(start|finish)$/i, { message: '올바른 타입이 아닙니다.' })
  type: 'start' | 'finish';

  @Column({ type: 'int', default: 0 })
  @IsNumber()
  learning_time: number;

  @Column({ type: 'boolean', default: true })
  is_finished: boolean;

  @ManyToOne(() => UsersModel, (user) => user.study_logs, {
    eager: true,
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'user_id' })
  user_id: UsersModel;

  @ManyToOne(() => Categories, (categories) => categories.study_logs, {
    eager: true,
    nullable: true,
    onDelete: 'SET NULL',
  })
  @JoinColumn({ name: 'category_id' })
  category_id: Categories;
}

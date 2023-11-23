import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { UsersModel } from 'src/users/entity/users.entity';
import { Categories } from 'src/categories/categories.entity';

@Entity()
export class StudyLogs {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'date' })
  date: Date;

  @Column({ type: 'datetime' })
  created_at: Date;

  @Column({ type: 'enum', enum: ['start', 'finish'] })
  type: 'start' | 'finish';

  @Column({ type: 'int', default: 0 })
  learning_time: number;

  @ManyToOne(() => UsersModel, (user) => user.study_logs, { eager: true })
  @JoinColumn({ name: 'user_id' })
  user_id: UsersModel;

  @ManyToOne(() => Categories, (categories) => categories.study_logs, {
    eager: true,
    nullable: true,
  })
  @JoinColumn({ name: 'category_id' })
  category_id: Categories;
}

import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity()
export class StudyLogs {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'date' })
  date: string;

  @Column({ type: 'datetime' })
  created_at: Date;

  @Column({ type: 'enum', enum: ['start', 'finish'] })
  type: 'start' | 'finish';
}

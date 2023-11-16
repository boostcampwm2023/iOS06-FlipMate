import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';

@Entity()
export class StudyLogs {
  @PrimaryGeneratedColumn()
  id: number;

  @ApiProperty({
    example: '2023-11-23',
    description: '학습을 시작한 날짜',
  })
  @Column({ type: 'date' })
  date: string;

  @ApiProperty({
    type: 'date',
    example: '2023-11-23 11:00:12',
    description: '학습을 시작/종료 시점의 시간',
  })
  @Column({ type: 'datetime' })
  created_at: Date;

  @ApiProperty({
    type: 'enum',
    example: 'start',
    description: '학습이 시작인지 종료인지에 대한 타입',
  })
  @Column({ type: 'enum', enum: ['start', 'finish'] })
  type: 'start' | 'finish';
}

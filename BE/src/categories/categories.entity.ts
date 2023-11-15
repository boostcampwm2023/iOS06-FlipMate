import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';

@Entity()
export class Categories {
  @PrimaryGeneratedColumn()
  id: number;

  @ApiProperty({
    type: 'char(50)',
    example: '백준',
    description: '카테고리 이름',
  })
  @Column({ type: 'char' })
  name: string;

  @ApiProperty({
    type: 'char(8)',
    example: 'FFFFFFFF',
    description: '카테고리 색상',
  })
  @Column({ type: 'char' })
  color_code: string;
}

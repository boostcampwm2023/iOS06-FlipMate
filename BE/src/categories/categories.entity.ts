import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';
import { UsersModel } from 'src/users/entity/users.entity';

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
  user: UsersModel;
}

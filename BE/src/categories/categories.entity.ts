import { Users } from 'src/users/users.entity';
import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';

@Entity()
export class Categories {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => Users, (user) => user.categories)
  user: number;

  @Column({
    type: 'char',
    length: 50,
  })
  name: string;

  @Column({
    type: 'char',
    length: 8,
  })
  color_code: string;
}

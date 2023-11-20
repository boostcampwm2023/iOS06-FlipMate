import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { UsersModel } from 'src/users/entity/users.entity';

@Entity()
export class Categories {
  @PrimaryGeneratedColumn()
  id: number;

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

  @ManyToOne(() => UsersModel, (user) => user.categories)
  @JoinColumn({ name: 'user_id' })
  user_id: UsersModel;
}

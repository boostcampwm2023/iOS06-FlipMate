import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { UsersModel } from 'src/users/entity/users.entity';

@Entity()
export class Mates {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => UsersModel, (user) => user.follower, { eager: true })
  @JoinColumn({ name: 'follower_id' })
  follower_id: UsersModel;

  @ManyToOne(() => UsersModel, (user) => user.following, { eager: true })
  @JoinColumn({ name: 'following_id' })
  following_id: UsersModel;
}

import {
  Entity,
  PrimaryGeneratedColumn,
  ManyToOne,
  JoinColumn,
  Column,
} from 'typeorm';
import { UsersModel } from 'src/users/entity/users.entity';

@Entity()
export class Mates {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => UsersModel, (user) => user.follower, {
    eager: true,
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'follower_id' })
  follower_id: UsersModel;

  @ManyToOne(() => UsersModel, (user) => user.following, {
    eager: true,
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'following_id' })
  following_id: UsersModel;

  @Column({ type: 'boolean', default: false })
  is_fixed: boolean;

  @Column({ type: 'boolean', default: false })
  is_blocked: boolean;
}

import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';
import { Categories } from 'src/categories/categories.entity';

@Entity()
export class Users {
  @PrimaryGeneratedColumn()
  id: number;

  @ApiProperty({
    type: 'string',
    example: 'nickname123',
    description: '유저 닉네임',
  })
  @Column({
    type: 'char',
    length: 50,
  })
  nickname: string;

  @ApiProperty({
    type: 'string',
    example: 'google_id123',
    description: 'OAuth로 로그인 한 구글 계정 아이디',
  })
  @Column({
    type: 'char',
    length: 255,
  })
  google_id: string;

  @ApiProperty({
    type: 'string',
    example: 'imgurl.com/path/file.png',
    description: '유저 프로필 사진',
  })
  @Column({
    type: 'char',
    length: 255,
  })
  image_url: string;

  @OneToMany(() => Categories, (category) => category.user_id)
  categories: Categories[];
}

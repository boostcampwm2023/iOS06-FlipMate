import { UsersModel } from 'src/users/entity/users.entity';
import usersData from '../mock-table/users.json';

export class MockUsersService {
  private data: UsersModel[] = usersData as UsersModel[];
  findUserById(user_id: number): Promise<object> {
    const user = this.data.find((user) => user.id === user_id);
    return Promise.resolve(user);
  }
}

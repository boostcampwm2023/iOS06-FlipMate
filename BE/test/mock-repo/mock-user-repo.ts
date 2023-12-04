import usersData from '../mock-table/users.json';
import mateData from '../mock-table/mates.json';
import studyLogsData from '../mock-table/study-logs.json';

export class MockUsersRepository {
  private data = usersData;
  private mate = mateData;
  private studyLogs = studyLogsData;

  create(entity: object): object {
    return {
      id: this.data.length + 1,
      ...entity,
    };
  }

  save(entity: object): Promise<object> {
    return Promise.resolve(entity);
  }

  find({ where: { id } }): Promise<object> {
    const user = this.data.find((user) => user.id === id);
    return Promise.resolve(user);
  }

  findOne({
    where,
  }: {
    where: { id?: number; nickname?: string };
  }): Promise<object> {
    if (where.id) {
      const user = this.data.find((user) => user.id === where.id);
      return Promise.resolve(user);
    }
    const user = this.data.find((user) => user.nickname === where.nickname);
    return Promise.resolve(user);
  }

  delete({ where: { id } }): Promise<object> {
    const user = this.data.find((user) => user.id === id);
    const index = this.data.indexOf(user);
    this.data.splice(index, 1);
    return Promise.resolve(user);
  }

  query(
    query: string,
    param: [date: string, user_id: number],
  ): Promise<object> {
    switch (query) {
      case `
        SELECT u.id, u.nickname, u.image_url, COALESCE(SUM(s.learning_time), 0) AS total_time
        FROM users_model u
        LEFT JOIN mates m ON m.following_id = u.id
        LEFT JOIN study_logs s ON s.user_id = u.id AND s.date = ?
        WHERE m.follower_id = ? 
        GROUP BY u.id
        ORDER BY total_time DESC
      `:
        const result = this.data
          .filter((user) =>
            this.mate.find(
              (mate) =>
                mate.follower_id === param[1] && mate.following_id === user.id,
            ),
          )
          .map((user) => {
            const total_time = this.studyLogs
              .filter(
                (studyLog) =>
                  studyLog.user_id === user.id && studyLog.date === param[0],
              )
              .reduce((acc, cur) => acc + cur.learning_time, 0);
            return {
              id: user.id,
              nickname: user.nickname,
              image_url: user.image_url,
              total_time,
            };
          })
          .sort((a, b) => b.total_time - a.total_time);
        return Promise.resolve(result);
    }
  }
}

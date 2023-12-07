import matesData from '../mock-table/mates.json';

export class MockMatesRepository {
  private data = matesData;
  create(entity: object): object {
    return {
      id: this.data.length + 1,
      ...entity,
    };
  }

  save(entity: object): Promise<object> {
    return Promise.resolve(entity);
  }

  find({ where }: { where: { follower_id } }): Promise<object> {
    const mates = this.data.filter(
      (mate) => mate.follower_id === where.follower_id.id,
    );
    const result = mates.map((mate) => ({
      id: mate.id,
      follower_id: { id: mate.follower_id },
      following_id: { id: mate.following_id },
    }));
    return Promise.resolve(result);
  }

  findOne({
    where,
  }: {
    where: { follower_id; following_id };
  }): Promise<object> {
    const mate = this.data.find(
      (mate) =>
        mate.follower_id === where.follower_id.id &&
        mate.following_id === where.following_id.id,
    );
    return Promise.resolve(mate);
  }

  delete({ follower_id, following_id }): Promise<object> {
    const mate = this.data.find(
      (mate) =>
        mate.follower_id === follower_id.id &&
        mate.following_id === following_id.id,
    );
    return Promise.resolve(mate);
  }

  count({ where: { follower_id } }): Promise<number> {
    const mates = this.data.filter(
      (mate) => mate.follower_id === follower_id.id,
    );
    return Promise.resolve(mates.length);
  }
}

export class MockRedisService {
  private redis: Map<string, object> = new Map();
  constructor() {}
  hset(key: string, field: string, value: string) {
    const data = {};
    data[field] = value;
    this.redis.set(key, data);
  }

  hget(key: string, field: string): Promise<string | null> {
    return Promise.resolve(this.redis.get(key)[field]);
  }

  async del(key: string): Promise<void> {
    await this.redis.delete(key);
  }
}

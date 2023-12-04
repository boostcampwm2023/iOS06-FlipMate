export class MockRedisService {
  private redis: Map<string, string> = new Map();
  constructor() {
    this.redis.set('2', '2023-11-29 16:00:00');
  }
  set(key: string, value: string) {
    this.redis.set(key, value);
  }

  get(key: string): Promise<string | null> {
    return Promise.resolve(this.redis.get(key));
  }

  async del(key: string): Promise<void> {
    await this.redis.delete(key);
  }
}

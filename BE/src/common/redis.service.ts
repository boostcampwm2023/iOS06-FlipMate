import { Injectable } from '@nestjs/common';
import { RedisClientType, createClient } from 'redis';

@Injectable()
export class RedisService {
  private client: RedisClientType;
  constructor() {
    this.client = createClient();
    this.client.connect();
  }
  async hset(key: string, field: string, value: string) {
    await this.client.hSet(key, field, value);
  }

  hget(key: string, field: string): Promise<string | null> {
    return this.client.hGet(key, field);
  }

  async hdel(key: string, field: string): Promise<void> {
    await this.client.hDel(key, field);
  }

  async del(key: string) {
    await this.client.del(key);
  }

  getKeys() {
    return this.client.keys('*');
  }
}

import { Injectable } from '@nestjs/common';
import { RedisClientType, createClient } from 'redis';

@Injectable()
export class RedisService {
  private client: RedisClientType;
  constructor() {
    this.client = createClient();
    this.client.connect();
  }
  set(key: string, value: string) {
    this.client.set(key, value);
  }

  get(key: string): Promise<string | null> {
    return this.client.get(key);
  }
}

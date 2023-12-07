import { Injectable } from '@nestjs/common';
import { RedisService } from 'src/common/redis.service';

@Injectable()
export class HeartbeatService {
  constructor(private redisService: RedisService) {}

  recordHeartbeat(userId: number) {
    this.redisService.hset(`${userId}`, 'received_at', `${Date.now()}`);
  }

  async startCheckingHeartbeats() {
    setInterval(async () => {
      const now = Date.now();
      const clients = await this.redisService.getKeys();
      for (const clientId of clients) {
        const received_at = await this.redisService.hget(
          `${clientId}`,
          'received_at',
        );
        if (now - +received_at > 30000) {
          await this.redisService.del(`${clientId}`);
        }
      }
    }, 10000);
  }
}

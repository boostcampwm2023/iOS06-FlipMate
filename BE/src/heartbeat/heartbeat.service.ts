import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Categories } from 'src/categories/categories.entity';
import { RedisService } from 'src/common/redis.service';
import { StudyLogs } from 'src/study-logs/study-logs.entity';
import { StudyLogsService } from 'src/study-logs/study-logs.service';
import { UsersModel } from 'src/users/entity/users.entity';
import { Repository } from 'typeorm';
import moment from 'moment';

@Injectable()
export class HeartbeatService {
  constructor(
    private redisService: RedisService,
    @InjectRepository(StudyLogs)
    private studyLogsRepository: Repository<StudyLogs>,
    @InjectRepository(UsersModel)
    private usersRepository: Repository<UsersModel>,
    private studyLogsService: StudyLogsService,
  ) {}

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
          await this.removeOldData(clientId);
          await this.redisService.del(`${clientId}`);
          await this.usersRepository.update(
            { id: +clientId },
            { is_studying: false },
          );
        }
      }
    }, 10000);
  }

  async removeOldData(clientId: string): Promise<void> {
    const started_at = await this.redisService.hget(
      `${clientId}`,
      'started_at',
    );
    const received_at = await this.redisService.hget(
      `${clientId}`,
      'received_at',
    );
    const category_id = await this.redisService.hget(
      `${clientId}`,
      'category_id',
    );

    const learning_time = moment(+received_at).diff(started_at, 's');
    const moment_received_at = moment(+received_at);
    const offset = await this.usersRepository.findOne({
      select: ['timezone'],
      where: { id: +clientId },
    });

    const received_at_with_offset = `${moment_received_at.format(
      'YYYY-MM-DD HH:mm:ss',
    )}${offset.timezone}`;

    const learningTimes = this.studyLogsService.calculateLearningTimes(
      received_at_with_offset,
      +learning_time,
    );

    for (const { started_at, date, learning_time } of learningTimes) {
      const studyLog = this.studyLogsRepository.create({
        type: 'finish',
        date,
        learning_time,
        created_at: started_at,
        user_id: { id: +clientId } as UsersModel,
        category_id: { id: +category_id || null } as Categories,
        is_finished: false,
      });
      console.log(studyLog);
      await this.studyLogsRepository.save(studyLog);
    }
  }
}

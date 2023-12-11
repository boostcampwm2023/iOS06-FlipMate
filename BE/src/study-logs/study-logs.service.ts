import { BadRequestException, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { StudyLogs } from './study-logs.entity';
import { StudyLogsCreateDto } from './dto/request/create-study-logs.dto';
import { UsersModel } from 'src/users/entity/users.entity';
import { Categories } from 'src/categories/categories.entity';
import { StudyLogsDto } from './dto/response/study-logs.dto';
import { transformDate } from 'src/common/utils/utils';
import { RedisService } from 'src/common/redis.service';
import moment from 'moment';

@Injectable()
export class StudyLogsService {
  constructor(
    @InjectRepository(StudyLogs)
    private studyLogsRepository: Repository<StudyLogs>,
    @InjectRepository(UsersModel)
    private usersRepository: Repository<UsersModel>,
    private redisService: RedisService,
  ) {}

  async createStartLog(
    studyLogsData: StudyLogsCreateDto,
    user_id: number,
  ): Promise<void> {
    const { created_at } = studyLogsData;
    await this.redisService.hset(`${user_id}`, 'started_at', `${created_at}`);
    await this.redisService.hset(`${user_id}`, 'received_at', `${Date.now()}`);
  }

  async createFinishLog(
    studyLogsData: StudyLogsCreateDto,
    user_id: number,
  ): Promise<void> {
    const { category_id } = studyLogsData;
    const user = { id: user_id } as UsersModel;
    const category = { id: category_id ?? null } as Categories;

    const learningTimes = this.calculateLearningTimes(
      studyLogsData.created_at,
      studyLogsData.learning_time,
    );

    for (const { started_at, date, learning_time } of learningTimes) {
      const studyLog = this.studyLogsRepository.create({
        type: 'finish',
        date,
        learning_time,
        created_at: started_at,
        user_id: user,
        category_id: category,
      });
      await this.studyLogsRepository.save(studyLog);
    }
    await this.redisService.del(`${user_id}`);
  }

  async findAll(): Promise<StudyLogs[]> {
    return this.studyLogsRepository.find();
  }

  calculateStartDay(created_at: Date, learning_time: number): Date {
    const STANDARD = 0;
    const standardMS = STANDARD * 60 * 60 * 1000;
    const millisecond =
      created_at.getTime() - learning_time * 1000 - standardMS;
    const started_at = new Date(millisecond);
    return started_at;
  }

  calculateLearningTimes(
    created_at: string,
    learning_time: number,
  ): { started_at: string; date: string; learning_time: number }[] {
    const offset = created_at.split(/\d\d:\d\d:\d\d/)[1];
    const finishedAt = moment(created_at).utcOffset(offset);
    const startedAt = finishedAt.clone().subtract(learning_time, 's');
    if (startedAt.get('date') !== finishedAt.get('date')) {
      return [
        {
          started_at: startedAt.toISOString(),
          date: startedAt.format('YYYY-MM-DD'),
          learning_time:
            startedAt.clone().endOf('day').diff(startedAt, 's') + 1,
        },
        {
          started_at: finishedAt.clone().startOf('day').toISOString(),
          date: finishedAt.format('YYYY-MM-DD'),
          learning_time: finishedAt
            .clone()
            .diff(finishedAt.clone().startOf('day'), 's'),
        },
      ];
    }
    return [
      {
        started_at: startedAt.toISOString(),
        date: startedAt.format('YYYY-MM-DD'),
        learning_time: learning_time,
      },
    ];
  }

  async calculateTotalTimes(
    user_id: number,
    start_date: string,
    end_date: string,
  ): Promise<number[]> {
    if (!user_id || !start_date || !end_date) {
      throw new BadRequestException('인자의 형식이 잘못되었습니다.');
    }
    const startMoment = moment(start_date);
    const diffDays = moment(end_date).diff(startMoment, 'days') + 1;
    if (diffDays <= 0) {
      throw new BadRequestException('startDate는 endDate보다 작아야 합니다.');
    }
    const result = Array.from({ length: diffDays }, () => 0);
    const daily_sums = await this.studyLogsRepository.query(
      `SELECT DATE(study_logs.date) as date, SUM(study_logs.learning_time) as daily_sum
       FROM study_logs
       WHERE study_logs.user_id = ?
       AND study_logs.date BETWEEN ? AND ?
       GROUP BY DATE(study_logs.date)
       ORDER BY DATE(study_logs.date) ASC`,
      [user_id, start_date, end_date],
    );

    daily_sums.forEach(({ date, daily_sum }) => {
      result[moment(date).diff(startMoment, 'days')] = +daily_sum;
    });
    return result;
  }

  async groupByCategory(user_id: number, date: string): Promise<object> {
    const studyLogsByCategory = await this.studyLogsRepository.query(
      `SELECT
        c.id,
        c.name,
        c.color_code,
        c.user_id,
        COALESCE(SUM(s.learning_time), 0) AS today_time
      FROM categories c
      LEFT JOIN study_logs s
        ON c.id = s.category_id
        AND s.date = ?
      WHERE c.user_id = ?
      GROUP BY
        c.id, c.name, c.color_code;
      `,
      [date, user_id],
    );

    const categories = studyLogsByCategory.map((studyLog) => ({
      id: studyLog.id,
      name: studyLog.name,
      color_code: studyLog.color_code,
      today_time: parseInt(studyLog.today_time),
    }));

    const result = {
      total_time: (await this.calculateTotalTimes(user_id, date, date))[0] ?? 0,
      categories,
    };

    return result;
  }

  async deleteRowsByUserId(id: number): Promise<void> {
    this.studyLogsRepository.delete({ user_id: { id: id } });
  }

  async calculatePercentage(
    userId: number,
    startDate: string,
    endDate: string,
  ): Promise<number> {
    const result = await this.studyLogsRepository.query(
      `
      SELECT user_id, SUM(learning_time) AS total_time
      FROM study_logs
      WHERE date BETWEEN ? AND ?
      GROUP BY user_id
      ORDER BY total_time DESC;
    `,
      [startDate, endDate],
    );
    const rank = result.findIndex((user) => user.user_id === userId) + 1;
    if (!rank) {
      return 100;
    }
    const userCount = await this.usersRepository.count();
    return (rank / userCount) * 100;
  }

  entityToDto(studyLog: StudyLogs): StudyLogsDto {
    const { id, date, created_at, type, learning_time, user_id, category_id } =
      studyLog;
    return {
      id,
      date: transformDate(date),
      created_at,
      type,
      learning_time,
      user_id: user_id.id,
      category_id: category_id.id,
    };
  }
}

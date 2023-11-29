import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { StudyLogs } from './study-logs.entity';
import { StudyLogsCreateDto } from './dto/request/create-study-logs.dto';
import { UsersModel } from 'src/users/entity/users.entity';
import { Categories } from 'src/categories/categories.entity';
import { StudyLogsDto } from './dto/response/study-logs.dto';
import { transformDate } from 'src/common/utils';
import { RedisService } from 'src/common/redis.service';
import * as moment from 'moment';

@Injectable()
export class StudyLogsService {
  constructor(
    @InjectRepository(StudyLogs)
    private studyLogsRepository: Repository<StudyLogs>,
    private redisService: RedisService,
  ) {}

  async createStartLog(
    studyLogsData: StudyLogsCreateDto,
    user_id: number,
  ): Promise<void> {
    const { created_at } = studyLogsData;
    this.redisService.set(`${user_id}`, `${created_at}`);
  }

  async createFinishLog(
    studyLogsData: StudyLogsCreateDto,
    user_id: number,
  ): Promise<StudyLogsDto> {
    const { category_id, ...data } = studyLogsData;
    const user = { id: user_id } as UsersModel;
    const category = { id: category_id ?? null } as Categories;

    const studyLog = this.studyLogsRepository.create({
      ...data,
      user_id: user,
      category_id: category,
    });
    const savedStudyLog = await this.studyLogsRepository.save(studyLog);
    await this.redisService.del(`${user_id}`);
    return this.entityToDto(savedStudyLog);
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

  async calculateTotalTimes(
    user_id: number,
    start_date: string,
    end_date: string,
  ): Promise<number[]> {
    const startMoment = moment(start_date);
    const diffDays = moment(end_date).diff(startMoment, 'days');
    const result = Array.from({ length: diffDays }, () => 0);
    const daily_sums = await this.studyLogsRepository
      .createQueryBuilder('study_logs')
      .select('study_logs.date', 'date')
      .addSelect('SUM(study_logs.learning_time)', 'daily_sum')
      .where('study_logs.user_id = :user_id', { user_id })
      .andWhere('study_logs.date BETWEEN :start_date AND :end_date', {
        start_date,
        end_date,
      })
      .groupBy('study_logs.date')
      .orderBy('study_logs.date', 'ASC')
      .getRawMany();

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
      total_time: (await this.calculateTotalTimes(user_id, date, date))[0],
      categories,
    };
    return result;
  }

  async deleteRowsByUserId(id: number): Promise<void> {
    this.studyLogsRepository.delete({ user_id: { id: id } });
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

import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { StudyLogs } from './study-logs.entity';
import { StudyLogsCreateDto } from './dto/request/create-study-logs.dto';
import { UsersModel } from 'src/users/entity/users.entity';
import { Categories } from 'src/categories/categories.entity';
import { StudyLogsDto } from './dto/response/study-logs.dto';
import { transformDate } from 'src/common/utils';

@Injectable()
export class StudyLogsService {
  constructor(
    @InjectRepository(StudyLogs)
    private studyLogsRepository: Repository<StudyLogs>,
  ) {}

  async create(
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
    return this.entityToDto(savedStudyLog);
  }

  async findAll(): Promise<StudyLogs[]> {
    return this.studyLogsRepository.find();
  }

  calculateStartDay(created_at: Date, learning_time: number): Date {
    const standardMS = 5 * 60 * 60 * 1000;
    const millisecond =
      created_at.getTime() - learning_time * 1000 - standardMS;
    const started_at = new Date(millisecond);
    return started_at;
  }

  private async calculateTotalTime(
    user_id: number,
    date: string,
  ): Promise<number> {
    const sum = await this.studyLogsRepository
      .createQueryBuilder('study_logs')
      .select('SUM(study_logs.learning_time)', 'sum')
      .where('study_logs.user_id = :user_id', { user_id })
      .andWhere('study_logs.date = :date', { date })
      .getRawOne();
    return parseInt(sum.sum);
  }

  async groupByCategory(user_id: number, date: string): Promise<object> {
    const studyLogsByCategory = await this.studyLogsRepository.query(
      `SELECT
      c.id as category_id,
      c.name,
      c.color_code,
      IFNULL(SUM(s.learning_time), 0) as today_time
      FROM
      study_logs s
      
      RIGHT OUTER JOIN
      categories c ON c.id = s.category_id
      AND s.user_id = ?
      AND DATE(s.date) = ?
      GROUP BY
      c.id, c.name, c.color_code;
      `,
      [user_id, date],
    );

    const categories = studyLogsByCategory.map((studyLog) => ({
      ...studyLog,
      today_time: parseInt(studyLog.today_time),
    }));

    const result = {
      total_time: await this.calculateTotalTime(user_id, date),
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

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

  private calculateTotalTime(studyLogs): number {
    return studyLogs.reduce((accumulator, studyLog) => {
      return accumulator + studyLog.today_time;
    }, 0);
  }

  async groupByCategory(user_id: number, date: string): Promise<object> {
    const studyLogsByCategory = await this.studyLogsRepository
      .createQueryBuilder('study_logs')
      .select('study_logs.category_id', 'category_id')
      .addSelect('SUM(study_logs.learning_time)', 'today_time')
      .addSelect('categories.name', 'name')
      .addSelect('categories.color_code', 'color_code')
      .leftJoin('study_logs.category_id', 'categories')
      .where('study_logs.date = :today', { today: date })
      .andWhere('study_logs.user_id = :user_id', { user_id })
      .groupBy('study_logs.category_id')
      .getRawMany();
    const categories = studyLogsByCategory.map((studyLog) => ({
      ...studyLog,
      today_time: parseInt(studyLog.today_time),
    }));

    const result = {
      total_time: this.calculateTotalTime(categories),
      categories: categories.filter((category) => category.name),
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

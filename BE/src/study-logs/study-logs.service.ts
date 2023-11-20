import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { StudyLogs } from './study-logs.entity';
import { StudyLogsCreateDto } from './dto/request/create-study-logs.dto';
import { UsersModel } from 'src/users/entity/users.entity';
import { Categories } from 'src/categories/categories.entity';
import { StudyLogsDto } from './dto/response/study-logs.dto';

@Injectable()
export class StudyLogsService {
  constructor(
    @InjectRepository(StudyLogs)
    private studyLogsRepository: Repository<StudyLogs>,
  ) {}

  async create(studyLogsData: StudyLogsCreateDto): Promise<StudyLogsDto> {
    const { user_id, category_id, ...data } = studyLogsData;
    const user = { id: user_id } as UsersModel;
    const category = { id: category_id } as Categories;

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

  async findByUserId(id: number): Promise<StudyLogsDto[]> {
    const studyLogs = await this.studyLogsRepository.find({
      where: { user_id: { id: id } },
    });
    return studyLogs.map((studyLog) => this.entityToDto(studyLog));
  }

  async deleteRowsByUserId(id: number): Promise<void> {
    this.studyLogsRepository.delete({ user_id: { id: id } });
  }

  entityToDto(studyLog: StudyLogs): StudyLogsDto {
    const { id, date, created_at, type, learning_time, user_id, category_id } =
      studyLog;
    return {
      id,
      date,
      created_at,
      type,
      learning_time,
      user_id: user_id.id,
      category_id: category_id.id,
    };
  }
}

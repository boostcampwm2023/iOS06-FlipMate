import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { StudyLogs } from './study-logs.entity';

@Injectable()
export class StudyLogsService {
  constructor(
    @InjectRepository(StudyLogs)
    private studyLogsRepository: Repository<StudyLogs>,
  ) {}

  async create(studyLogsData: StudyLogs): Promise<StudyLogs> {
    const studyLog = this.studyLogsRepository.create(studyLogsData);
    return this.studyLogsRepository.save(studyLog);
  }

  async findAll(): Promise<StudyLogs[]> {
    return this.studyLogsRepository.find();
  }
}

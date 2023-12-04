import moment from 'moment';
import studyLogsData from '../mock-table/study-logs.json';

export class MockStudyLogsService {
  private data = studyLogsData;

  calculateTotalTimes(id, start_date, end_date) {
    const startMoment = moment(start_date);
    const diffDays = moment(end_date).diff(startMoment, 'days') + 1;
    const result = Array.from({ length: diffDays }, () => 0);
    console.log(result);
    const daily_sums = this.data
      .filter(
        (studyLog) =>
          studyLog.user_id === id &&
          studyLog.date >= start_date &&
          studyLog.date <= end_date,
      )
      .reduce((acc, cur) => {
        const index = moment(cur.date).diff(startMoment, 'days');
        acc[index] += cur.learning_time;
        return acc;
      }, result);
    console.log(daily_sums);
    return daily_sums;
  }
}

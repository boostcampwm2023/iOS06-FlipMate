import { SharedArray } from 'k6/data';
import http from 'k6/http';
import { sleep, group } from 'k6';
import moment from 'https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.4/moment.min.js';

const HOST = 'http://localhost:3000';
const start_date = moment('2023-11-30');

const tokens = new SharedArray('possible tokens', function () {
  const mock_users = JSON.parse(open('./loadtest-mock.json'));
  return mock_users.map(({ access_token }) => access_token);
});

export const options = {
  //10초만에 사용자 200명 까지 증가했다가 2분동안 유지함
  scenarios: {
    statsDaily: {
      executor: 'ramping-vus',
      startVUs: 10,
      stages: [
        { duration: '10s', target: 100 },
        { duration: '2m', target: 100 },
      ],
      exec: 'statsDaily',
    },
    statsWeekly: {
      executor: 'ramping-vus',
      startVUs: 10,
      stages: [
        { duration: '10s', target: 100 },
        { duration: '2m', target: 100 },
      ],
      exec: 'statsWeekly',
    },
  },
  thresholds: {
    http_req_duration: ['avg<200', 'p(95)<500', 'max<1000'],
  },
};

function getParams() {
  const token = tokens[__VU % tokens.length];
  return {
    headers: {
      Authorization: `Bearer ${token}`,
    },
  };
}

export function statsDaily() {
  const params = getParams();
  group('일간 조회 7번', () => {
    let date = start_date;
    for (let i = 0; i < 7; i++) {
      //오늘, 1일전, 2일전, 3일전, 4일전, 5일전, 6일전 데이터 1초마다 조회
      http.get(
        `${HOST}/study-logs/stats?date=${date.format('YYYY-MM-DD')}`,
        params,
      );
      date = date.subtract(1, 'd');
      sleep(1);
    }
  });
}

export function statsWeekly() {
  const params = getParams();
  group('일주일간 조회', () => {
    //일주일 동안의 데이터 조회
    http.get(
      `${HOST}/study-logs/stats/weekly?date=${start_date.format('YYYY-MM-DD')}`,
      params,
    );
    sleep(1);
  });
}

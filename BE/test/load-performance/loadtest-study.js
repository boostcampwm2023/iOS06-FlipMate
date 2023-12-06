import { SharedArray } from 'k6/data';
import http from 'k6/http';
import { check, sleep, group } from 'k6';
import moment from 'https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.4/moment.min.js';
import faker from 'https://cdnjs.cloudflare.com/ajax/libs/Faker/3.1.0/faker.min.js';

const tokens = new SharedArray('possible tokens', function () {
  const mock_users = JSON.parse(open('./loadtest-mock.json'));
  return mock_users.map(({ access_token }) => access_token);
});

export let options = {
  stages: [
    { duration: '30s', target: 50 },
    { duration: '10s', target: 0 },
  ],
  thresholds: {
    http_req_duration: ['avg<200', 'p(95)<500', 'max<1000'],
    http_reqs: ['rate>100'],
  },
};

export default function () {
  const token = tokens[__VU % tokens.length];
  const url = 'http://localhost:3000/study-logs';
  const params = {
    headers: {
      Authorization: `Bearer ${token}`,
      'Content-Type': 'application/json',
    },
  };
  group('start 응답 시간이 1초 이내', function () {
    const start_date = moment(faker.date.between('2023-11-23', '2023-11-30'));

    const start_created_at = faker.date.between(
      start_date.format('YYYY-MM-DD'),
      start_date.add(1, 'd').subtract(1, 's').format('YYYY-MM-DD'),
    );
    const learning_time = faker.random.number({
      min: 60 * 30,
      max: 60 * 60 * 5,
    });

    const start_body = JSON.stringify({
      date: start_date,
      created_at: start_created_at,
      type: 'start',
      learning_time: 0,
    });
    check(http.post(url, start_body, params), {
      'start 응답 시간이 1초 이내': (r) => r.timings.duration < 1000,
    });
    sleep(4);
    const finish_body = JSON.stringify({
      date: start_date,
      created_at: moment(start_created_at).clone().add(learning_time, 's'),
      type: 'finish',
      learning_time: learning_time,
    });
    check(http.post(url, finish_body, params), {
      'finish 응답 시간이 1초 이내': (r) => r.timings.duration < 1000,
    });
  });
}

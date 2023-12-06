import { SharedArray } from 'k6/data';
import http from 'k6/http';
import { check, sleep, group } from 'k6';
import { setInterval, setTimeout, clearInterval } from 'k6/experimental/timers';
import moment from 'https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.4/moment.min.js';
import faker from 'https://cdnjs.cloudflare.com/ajax/libs/Faker/3.1.0/faker.min.js';

const tokens = new SharedArray('possible tokens', function () {
  const mock_users = JSON.parse(open('./loadtest-mock.json'));
  return mock_users.map(({ access_token }) => access_token);
});

export let options = {
  stages: [
    { duration: '30s', target: 50 },
    { duration: '20s', target: 0 },
  ],
  thresholds: {
    http_req_duration: ['avg<200', 'p(95)<500', 'max<1000'],
    http_reqs: ['rate>100'],
  },
};

export default function () {
  const token = tokens[__VU % tokens.length];
  const url = 'http://localhost:3000/mates';
  const params = {
    headers: {
      Authorization: `Bearer ${token}`,
      'Content-Type': 'application/json',
    },
  };

  const date = moment(faker.date.between('2023-11-23', '2023-11-30'));
  check(http.get(`${url}?date=${date}`, params), {
    '친구 조회 응답 시간이 1초 이내': (r) => r.timings.duration < 1000,
  });
  sleep(3);
}

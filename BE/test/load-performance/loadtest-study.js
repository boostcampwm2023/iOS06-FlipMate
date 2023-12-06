import { SharedArray } from 'k6/data';
import http from 'k6/http';
import { check, sleep, group } from 'k6';

const tokens = new SharedArray('possible tokens', function () {
  const mock_users = JSON.parse(open('./loadtest-mock.json'));
  return mock_users.map(({ access_token }) => access_token);
});

export let options = {
  stages: [
    { duration: '30s', target: 10 }, // 사용자 수를 1분 동안 500까지 증가

    { duration: '16s', target: 0 }, // 사용자 수를 10초 동안 0으로 감소
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
      'Content-Type': 'application/json', // JSON Content-Type 헤더 추가
    },
  };
  group('start 응답 시간이 1초 이내', function () {
    const start_body = JSON.stringify({
      date: '2023-11-23',
      created_at: '2023-11-23T23:01:02+09:00',
      type: 'start',
      learning_time: 0,
    });
    check(http.post(url, start_body, params), {
      'start 응답 시간이 1초 이내': (r) => r.timings.duration < 1000,
    });
    sleep(4);
    const finish_body = JSON.stringify({
      date: '2023-11-23',
      created_at: '2023-11-23T23:01:02+09:00',
      type: 'finish',
      learning_time: 2222,
    });
    check(http.post(url, finish_body, params), {
      'finish 응답 시간이 1초 이내': (r) => r.timings.duration < 1000,
    });
  });
}

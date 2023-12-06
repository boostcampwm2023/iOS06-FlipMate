import { SharedArray } from 'k6/data';
import http from 'k6/http';
import { check, sleep, group } from 'k6';

const tokens = new SharedArray('possible tokens', function () {
  const mock_users = JSON.parse(open('./loadtest-mock.json'));
  return mock_users.map(({ access_token }) => access_token);
});

export let options = {
  stages: [
    { duration: '30s', target: 100 }, // 사용자 수를 1분 동안 500까지 증가

    { duration: '5s', target: 0 }, // 사용자 수를 10초 동안 0으로 감소
  ],
  thresholds: {
    http_req_duration: ['avg<200', 'p(95)<500', 'max<1000'],
    http_reqs: ['rate>100'],
  },
};

export default function () {
  const token = tokens[__VU % tokens.length];
  const url = 'http://localhost:3000/categories';
  const params = {
    headers: {
      Authorization: `Bearer ${token}`,
      'Content-Type': 'application/json', // JSON Content-Type 헤더 추가
    },
  };
  group('category', function () {
    const category = JSON.stringify({
      name: '개발',
      color_code: 'AAAAAA',
    });

    const createResponse = http.post(url, category, params);
    const category_id = JSON.parse(createResponse.body).category_id;
    check(createResponse, {
      'category 생성 응답 시간이 1초 이내': (r) => r.timings.duration < 1000,
    });
    sleep(1);
    const deleteResponse = http.del(`${url}/${category_id}`, {}, params);
    check(deleteResponse, {
      'category 삭제 응답 시간이 1초 이내': (r) => r.timings.duration < 1000,
    });
  });
}

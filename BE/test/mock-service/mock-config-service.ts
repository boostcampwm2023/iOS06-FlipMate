export class MockConfigService {
  private ENV = {
    CDN_ENDPOINT: 'http://cdn.com',
  };
  get(key: string) {
    return this.ENV[key];
  }
}

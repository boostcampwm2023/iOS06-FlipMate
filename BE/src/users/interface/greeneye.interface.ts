export interface GreenEyeResponse {
  version: string;
  requestId: string;
  timestamp: number;
  images: [
    {
      message: string;
      name: string;
      result: {
        adult: { confidence: number };
        normal: { confidence: number };
        porn: { confidence: number };
        sexy: { confidence: number };
      };
      latency: number;
      confidence: number;
    },
  ];
}

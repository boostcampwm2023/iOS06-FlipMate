import { Injectable, NestMiddleware } from '@nestjs/common';
import { NextFunction } from 'express';

@Injectable()
export class LoggingMiddleware implements NestMiddleware {
  use(req: Request & { now: number }, res: Response, next: NextFunction) {
    req.now = Date.now();
    next();
  }
}

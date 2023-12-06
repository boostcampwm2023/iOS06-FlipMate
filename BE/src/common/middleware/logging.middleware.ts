import { Injectable, NestMiddleware } from '@nestjs/common';
import { NextFunction } from 'express';
import { v4 as uuid } from 'uuid';

@Injectable()
export class LoggingMiddleware implements NestMiddleware {
  use(
    req: Request & { now: number; id: string },
    res: Response,
    next: NextFunction,
  ) {
    req.now = Date.now();
    req.id = uuid();
    next();
  }
}

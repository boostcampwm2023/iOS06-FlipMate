import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
  Logger,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';

@Injectable()
export class LoggingInterceptor implements NestInterceptor {
  private readonly logger = new Logger(LoggingInterceptor.name);
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const ctx = context.switchToHttp();
    const request = ctx.getRequest();
    const response = ctx.getResponse();
    const { method, url, body } = request;
    this.logger.debug(
      `[📩 Req#${request.id.slice(0, 8)}] ${method} ${url} ${
        request.user.nickname
      }#${request.user.id}\n${JSON.stringify(body)}`,
    );
    return next.handle().pipe(
      tap((body) => {
        const requestToResponse: `${number}ms` = `${
          Date.now() - request.now
        }ms`;
        this.logger.debug(
          `[📤 Res#${request.id.slice(0, 8)}] ${
            response.statusCode
          } ${requestToResponse} \n ${JSON.stringify(body)}`,
        );
      }),
    );
  }
}

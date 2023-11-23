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
      `[Request] Method: ${method}, URL: ${url}, Body: ${JSON.stringify(body)}`,
    );

    return next
      .handle()
      .pipe(
        tap((body) =>
          this.logger.debug(
            `[Response] Status: ${response.statusCode}, Body: ${JSON.stringify(
              body,
            )}`,
          ),
        ),
      );
  }
}
import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpException,
  Logger,
} from '@nestjs/common';
import { LoggingInterceptor } from '../interceptor/logging.interceptor';

@Catch(HttpException)
export class HttpExceptionFilter implements ExceptionFilter {
  private readonly logger = new Logger(LoggingInterceptor.name);
  catch(exception: HttpException, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse();
    const request = ctx.getRequest();
    const status = exception.getStatus();

    const requestToResponse: `${number}ms` = request.now
      ? `${Date.now() - request.now}ms`
      : `0ms`;

    const errorResponse = {
      statusCode: exception.getResponse()['statusCode'] || status,
      message: exception?.message,
      error: exception?.getResponse()['error'],
      path: request.url,
      timestamp: new Date().toLocaleString('kr'),
    };
    this.logger.warn(
      `[Exception] ${status} ${exception?.message} ${requestToResponse}`,
    );

    response.status(status).json(errorResponse);
  }
}

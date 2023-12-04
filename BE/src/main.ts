import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { SwaggerModule } from '@nestjs/swagger';
import { ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { readFileSync } from 'fs';
import { WinstonModule } from 'nest-winston';
import { loggerConfig } from './common/config/logging.config';
import { LoggingInterceptor } from './common/interceptor/logging.interceptor';
import { HttpExceptionFilter } from './common/exception-filter/http-exception-filter';
import { swaggerConfig } from './common/config/swagger.config';
import { ENV } from './common/const/env-keys.const';

async function bootstrap() {
  const configService = new ConfigService();

  const ssl = configService.get<string>(ENV.SSL);
  let httpsOptions = null;
  if (ssl == 'true') {
    httpsOptions = {
      key: readFileSync(configService.get<string>(ENV.HTTPS_KEY_PATH)),
      cert: readFileSync(configService.get<string>(ENV.HTTPS_CERT_PATH)),
    };
  }

  const app = await NestFactory.create(AppModule, {
    httpsOptions,
    logger: WinstonModule.createLogger(loggerConfig),
  });

  const document = SwaggerModule.createDocument(app, swaggerConfig);
  SwaggerModule.setup('api', app, document);

  app.useGlobalPipes(new ValidationPipe());
  app.useGlobalInterceptors(new LoggingInterceptor());
  app.useGlobalFilters(new HttpExceptionFilter());

  await app.listen(configService.get<number>(ENV.PORT) || 3000);
}
bootstrap();

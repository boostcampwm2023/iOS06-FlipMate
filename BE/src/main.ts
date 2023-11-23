import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { readFileSync } from 'fs';
import { WinstonModule } from 'nest-winston';
import { loggerConfig } from './common/logging.config';
import { LoggingInterceptor } from './common/logging.interceptor';

async function bootstrap() {
  const configService = new ConfigService();

  let httpsOptions = null;
  const ssl = configService.get<string>('SSL');
  if (ssl == 'true') {
    httpsOptions = {
      key: readFileSync(configService.get<string>('HTTPS_KEY_PATH')),
      cert: readFileSync(configService.get<string>('HTTPS_CERT_PATH')),
    };
  }

  const app = await NestFactory.create(AppModule, {
    httpsOptions,
    logger: WinstonModule.createLogger(loggerConfig),
  });
  const config = new DocumentBuilder()
    .setTitle('StudyLog API')
    .setDescription('StudyLog 애플리케이션 API 문서')
    .setVersion('1.0')
    .addBearerAuth()
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);

  app.useGlobalPipes(new ValidationPipe());
  app.useGlobalInterceptors(new LoggingInterceptor());

  await app.listen(configService.get<number>('PORT') || 3000);
}
bootstrap();

import { DocumentBuilder } from '@nestjs/swagger';

export const swaggerConfig = new DocumentBuilder()
  .setTitle('StudyLog API')
  .setDescription('StudyLog 애플리케이션 API 문서')
  .setVersion('2.0')
  .addBearerAuth()
  .build();

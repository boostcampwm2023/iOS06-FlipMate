import * as path from 'path';
import * as multerS3 from 'multer-s3';
import { S3Client } from '@aws-sdk/client-s3';
import { v4 as uuid } from 'uuid';
import { BadRequestException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { MulterOptions } from '@nestjs/platform-express/multer/interfaces/multer-options.interface';
import { ENV } from './const/env-keys.const';

export const multerConfig = (configService: ConfigService): MulterOptions => ({
  fileFilter: (req, file, callback) => {
    const ext = path.extname(file.originalname);
    if (ext !== '.jpg' && ext !== '.jpeg' && ext !== '.png') {
      return callback(
        new BadRequestException('jpg/jpeg/png 파일만 업로드 가능합니다!'),
        false,
      );
    }
    return callback(null, true);
  },
  limits: { fileSize: 1024 * 1024 * 10 }, //10MB
  storage: multerS3({
    s3: new S3Client({
      endpoint: configService.get(ENV.IMAGE_ENDPOINT),
      credentials: {
        accessKeyId: configService.get(ENV.IMAGE_ACCESSKEY),
        secretAccessKey: configService.get(ENV.IMAGE_SECRETKEY),
      },
      region: configService.get(ENV.IMAGE_REGION),
    }),
    bucket: configService.get(ENV.IMAGE_BUCKET),
    key: function (req, file, callback) {
      const fileExtension = path.extname(file.originalname);
      callback(null, `IMG_${uuid()}${fileExtension}`);
    },
  }),
});

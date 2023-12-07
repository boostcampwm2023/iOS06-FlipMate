import path from 'path';
import { BadRequestException } from '@nestjs/common';
import { MulterOptions } from '@nestjs/platform-express/multer/interfaces/multer-options.interface';
import multer from 'multer';

export const multerConfig = (): MulterOptions => {
  const storage = multer.memoryStorage();
  const fileFilter = (req, file, callback) => {
    const ext = path.extname(file.originalname);
    if (ext !== '.jpg' && ext !== '.jpeg' && ext !== '.png') {
      return callback(
        new BadRequestException({
          statusCode: 40002,
          message: 'jpg/jpeg/png 파일만 업로드 가능합니다!',
          error: 'Bad Request',
        }),
      );
    }
    return callback(null, true);
  };
  const limits = { fileSize: 1024 * 1024 * 10 }; //10MB

  return {
    storage,
    fileFilter,
    limits,
  };
};

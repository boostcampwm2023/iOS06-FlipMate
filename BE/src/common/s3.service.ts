import { Injectable, InternalServerErrorException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { S3Client, PutObjectCommand } from '@aws-sdk/client-s3';
import sharp from 'sharp';
import { v4 as uuidv4 } from 'uuid';
import path from 'path';

@Injectable()
export class S3Service {
  private s3Client: S3Client;

  constructor(private configService: ConfigService) {
    this.s3Client = new S3Client({
      endpoint: this.configService.get('IMAGE_ENDPOINT'),
      credentials: {
        accessKeyId: this.configService.get('IMAGE_ACCESSKEY'),
        secretAccessKey: this.configService.get('IMAGE_SECRETKEY'),
      },
      region: this.configService.get('IMAGE_REGION'),
    });
  }

  async uploadFile(file: Express.Multer.File): Promise<string> {
    try {
      const buffer = await sharp(file.buffer).resize(800, 800).toBuffer();
      const fileName = `IMG_${uuidv4()}${path.extname(file.originalname)}`;

      await this.s3Client.send(
        new PutObjectCommand({
          Bucket: this.configService.get('IMAGE_BUCKET'),
          Key: fileName,
          Body: buffer,
        }),
      );

      return fileName;
    } catch (error) {
      throw new InternalServerErrorException(error);
    }
  }
}

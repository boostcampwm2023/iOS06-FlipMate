import { AuthService } from './auth.service';
import {
  Controller,
  Get,
  UseGuards,
  Req,
  Res,
  Post,
  Body,
  UseInterceptors,
  UploadedFile,
  BadRequestException,
  Patch,
  Delete,
} from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { Response } from 'express';
import { AccessTokenGuard } from './guard/bearer-token.guard';
import { User } from 'src/users/decorator/user.decorator';
import {
  ApiBearerAuth,
  ApiConsumes,
  ApiExcludeEndpoint,
  ApiOperation,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { UsersService } from 'src/users/users.service';
import { UpdateUserDto } from 'src/users/dto/update-user.dto';
import { FileInterceptor } from '@nestjs/platform-express';
import { ConfigService } from '@nestjs/config';
import { ENV } from 'src/common/const/env-keys.const';
import { getImageUrl } from 'src/common/utils/utils';
import { ResponseDto } from 'src/common/response.dto';

@ApiTags('로그인 페이지')
@Controller('auth')
export class AuthController {
  constructor(
    private readonly authService: AuthService,
    private readonly usersService: UsersService,
    private readonly configService: ConfigService,
  ) {}

  @Get('google')
  @UseGuards(AuthGuard('google'))
  @ApiExcludeEndpoint()
  googleAuth(@Req() req) {
    const user = req.user;
    return this.authService.loginWithOAuth(user);
  }

  @Post('google/app')
  @ApiOperation({ summary: 'Google 아이폰용 로그인 (완)' })
  @ApiResponse({ status: 201, description: '인증 성공' })
  @ApiResponse({ status: 401, description: '인증 실패' })
  async googleAppAuth(@Body('access_token') accessToken: string) {
    const email = await this.authService.getUserInfo(accessToken);
    return this.authService.loginWithOAuth({ email, auth_type: 'google' });
  }

  @Post('apple/app')
  @ApiOperation({ summary: 'Apple 아이폰용 로그인 (완)' })
  @ApiResponse({ status: 201, description: '인증 성공' })
  @ApiResponse({ status: 401, description: '인증 실패' })
  async appleAppAuth(@Body('identity_token') identity_token: string) {
    const email = await this.authService.getAppleUserInfo(identity_token);
    return this.authService.loginWithOAuth({ email, auth_type: 'apple' });
  }

  @Get('logout')
  @UseGuards(AccessTokenGuard)
  @ApiExcludeEndpoint()
  logout(@User('id') userId: number, @Res() res: Response) {
    console.log(`${userId}를 로그아웃 시키는 로직`);
    res.redirect('/');
  }

  @Patch('info')
  @UseGuards(AccessTokenGuard)
  @UseInterceptors(FileInterceptor('image'))
  @ApiOperation({ summary: '유저 정보 설정 (완)' })
  @ApiConsumes('multipart/form-data')
  @ApiResponse({ status: 200, description: '프로필 변경 성공' })
  @ApiResponse({ status: 400, description: '잘못된 요청' })
  @ApiResponse({ status: 401, description: '인증 실패' })
  @ApiBearerAuth()
  async patchUser(
    @User('id') user_id: number,
    @Body() user: UpdateUserDto,
    @UploadedFile() file: Express.Multer.File,
  ): Promise<any> {
    let image_url: string;
    if (file) {
      const isNomal = await this.usersService.isNormalImage(file);
      if (!isNomal) {
        throw new BadRequestException({
          statusCode: 40001,
          message: '유해한 이미지입니다.',
          error: 'Bad Request',
        });
      }
      image_url = await this.usersService.s3Upload(file);
    }
    const updatedUser = await this.usersService.updateUser(
      user_id,
      user,
      image_url,
    );
    return {
      nickname: updatedUser.nickname,
      email: updatedUser.email,
      image_url: getImageUrl(
        this.configService.get(ENV.CDN_ENDPOINT),
        updatedUser.image_url,
      ),
    };
  }

  @Get('info')
  @UseGuards(AccessTokenGuard)
  @ApiOperation({ summary: '유저 정보 조회 (완)' })
  @ApiResponse({ status: 200, description: '프로필 조회 성공' })
  @ApiResponse({ status: 400, description: '잘못된 요청' })
  @ApiResponse({ status: 401, description: '인증 실패' })
  @ApiBearerAuth()
  async getUser(@User('id') user_id: number): Promise<any> {
    const user = await this.usersService.findUserById(user_id);
    const followsCount = await this.usersService.getFollowsCount(user_id);
    return {
      follower_count: followsCount.follower_count,
      following_count: followsCount.following_count,
      nickname: user.nickname,
      email: user.email,
      image_url: getImageUrl(
        this.configService.get(ENV.CDN_ENDPOINT),
        user.image_url,
      ),
    };
  }

  @Patch('timezone')
  @UseGuards(AccessTokenGuard)
  @ApiOperation({ summary: '유저 타임존 설정 (완)' })
  @ApiResponse({ status: 200, description: '타임존 설정 성공' })
  @ApiResponse({ status: 400, description: '잘못된 요청' })
  @ApiResponse({ status: 401, description: '인증 실패' })
  @ApiBearerAuth()
  async patchTimezone(
    @User('id') user_id: number,
    @Body('timezone') timezone: string,
  ): Promise<ResponseDto> {
    await this.usersService.updateTimezone(user_id, timezone);
    return new ResponseDto(200, '타임존 설정 성공');
  }

  @Delete()
  @UseGuards(AccessTokenGuard)
  @ApiOperation({ summary: '유저 회원 탈퇴 (완)' })
  @ApiResponse({
    type: ResponseDto,
    description: '카테고리 삭제 성공',
  })
  @ApiBearerAuth()
  async deleteUser(@User('id') user_id: number): Promise<ResponseDto> {
    await this.usersService.remove(user_id);
    return new ResponseDto(200, '성공적으로 삭제되었습니다.');
  }
}

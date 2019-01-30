//
//  GFSelectPhoto.m
//  GFAPP
//
//  Created by gaoyafeng on 2018/7/5.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "GFSelectPhoto.h"

#import <AssetsLibrary/AssetsLibrary.h>


@interface GFSelectPhoto ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

/** 图片选择器 */
@property (strong,nonatomic)UIImagePickerController *imagePikerViewController;

/** 获取的信息 */
@property (nonatomic,copy) NSDictionary *infoDic;

@end

@implementation GFSelectPhoto
{
    UIImagePickerController *_imagePikerViewController;
    
    UIViewController *_currentVC;
    
    BlockAuthor _authorCallback;
    
    BlockPhoto _photoCallback;
}


+(instancetype)shareInstance
{
    static GFSelectPhoto *selectPhoto = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        selectPhoto = [[GFSelectPhoto alloc] init];
    });
    return selectPhoto;
}

- (instancetype)init{
    if ([super init]) {
        //初始化
        self.imagePikerViewController = [[UIImagePickerController alloc] init];
        self.imagePikerViewController.delegate = self;//通过代理来传递拍照的图片
        self.isEditing = NO;//默认不编辑
        self.cameraDevice = UIImagePickerControllerCameraDeviceFront;//默认为前置摄像头
        
        /**
         UIImagePickerControllerCameraCaptureModePhoto,
         UIImagePickerControllerCameraCaptureModeVideo
         */
        self.mediaType = UIImagePickerControllerCameraCaptureModePhoto;//默认获取媒体类型为照片
        self.maxVideoTime = 20;
    }
    return self;
}


///拍照取货
+ (void)takePhotosFormVC:(UIViewController *)superVC blockResult:(APPBackBlock)blockResult{
    
    [GFSelectPhoto shareInstance].isEditing = YES;
    [GFSelectPhoto shareInstance].mediaType = UIImagePickerControllerCameraCaptureModePhoto;
    //弹出选择器
    [[GFSelectPhoto shareInstance] alertSelectTypeWithVC:superVC authorBlock:^(NSInteger type) {
        //type:0:取消 1:相机权限未打开  2:相册权限未打开
        switch (type) {
            case 0:
                NSLog(@"取消");
                break;
            case 1:
                NSLog(@"相机权限未授权");
                /**
                [superVC showAlertMessage:@"相机权限未打开，请到->设置->隐私->相机选项中,允许闪送骑手端访问您的相机。" title:@"提示" btnTitle:@"确定" block:^{
                    
                }];
                 */
                break;
            case 2:
                NSLog(@"相册权限未授权");
                /**
                [superVC showAlertMessage:@"相册权限未打开，请到->设置->隐私->相册选项中，允许闪送骑手端访问您的相册。" title:@"提示" btnTitle:@"确定" block:^{
                    
                }];
                 */
                break;
                
            default:
                break;
        }
    } photoBlock:^(UIImage * _Nonnull photo, NSURL * _Nonnull mediaUrl) {
        
        blockResult(YES,photo);
    }];
    
}


///弹框提示选择 相册 && 相机
- (void)alertSelectTypeWithVC:(UIViewController *)viewController authorBlock:(BlockAuthor)authorCallback photoBlock:(BlockPhoto)photoCallback{
    
    //获取值
    _currentVC = viewController;
    _authorCallback = authorCallback;
    _photoCallback = photoCallback;
    
    //弹出提示框
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak typeof(self) weakSelf = self;
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开相机
        [weakSelf openImagePickerVCWith:0];
    }];
    [alertView addAction:cancleAction];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开相册
        [weakSelf openImagePickerVCWith:1];
    }];
    [alertView addAction:okAction];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //打开相册
        if (authorCallback) {
            authorCallback(0);
        }
        [weakSelf deallocCaptureVariable];//释放外部捕获的变量
    }]];
    
    [viewController presentViewController:alertView animated:YES completion:nil];
}

///释放外部捕获的资源
- (void)deallocCaptureVariable{
    
    _currentVC = nil;
    _authorCallback = nil;
    _photoCallback = nil;
}

#pragma mark - 打开相机 && 相册
- (void)openImagePickerVCWith:(NSInteger)type {
    
    //判断是否支持相机
    switch (type) {
        case 0:{
            //相机
            /**
            AVAuthorizationStatus AVstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];//相机权限
            if (AVstatus == AVAuthorizationStatusRestricted || AVstatus == AVAuthorizationStatusDenied) {
                //[XKTip showMessage:@"请打开相机权限"];
                //return;
            }
             */
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
                if ([[APPLoacalInfo alloc] init].cameraAuthorization) {
                    
                    //获取资源来源相机
                    _imagePikerViewController.sourceType = UIImagePickerControllerSourceTypeCamera;
                    
                    _imagePikerViewController.cameraDevice = _cameraDevice;//前置摄像头
                    
                    if (_mediaType == UIImagePickerControllerCameraCaptureModePhoto) {
                        //照片
                        _imagePikerViewController.mediaTypes = @[(NSString*)kUTTypeImage];
                    }else{
                        //视频
                        //设置图像选取控制器的类型为动态图像 kUTTypeMovie
                        _imagePikerViewController.mediaTypes = @[(NSString*)kUTTypeMovie];
                        
                        //控制菜单
                        _imagePikerViewController.showsCameraControls = YES;
                        
                        //设置摄像图像品质
                        _imagePikerViewController.videoQuality = UIImagePickerControllerQualityTypeMedium;
                        
                        //设置最长摄像时间
                        _imagePikerViewController.videoMaximumDuration = _maxVideoTime;
                    }
                    
                }else{
                    //没有打开相机权限
                    if (_authorCallback) {
                        _authorCallback(1);
                    }
                    [self deallocCaptureVariable];//释放外部捕获的变量
                }
            }
        }
            break;
        case 1:{
            //相册
            /**
            PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
            if (photoAuthorStatus == PHAuthorizationStatusRestricted || photoAuthorStatus == PHAuthorizationStatusDenied) {
                [XKTip showMessage:@"请打开相册权限"];
                return;
            }
             */
            //在用这些来源的时候最好检测以下设备是否支持
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                
                if ([[APPLoacalInfo alloc] init].photoAuthorization) {
                    
                    /**
                     UIImagePickerControllerSourceTypePhotoLibrary ,//来自图库
                     UIImagePickerControllerSourceTypeCamera ,//来自相机
                     UIImagePickerControllerSourceTypeSavedPhotosAlbum //相机胶卷
                     */
                    _imagePikerViewController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    if (_mediaType == UIImagePickerControllerCameraCaptureModePhoto) {
                        //照片
                        _imagePikerViewController.mediaTypes = @[(NSString*)kUTTypeImage];
                    }else{
                        //视频
                        //设置图像选取控制器的类型为动态图像
                        _imagePikerViewController.mediaTypes = @[(NSString*)kUTTypeMovie];
                    }
                    
                }else{
                    //没有打开相册权限
                    if (_authorCallback) {
                        _authorCallback(2);
                    }
                    [self deallocCaptureVariable];//释放外部捕获的变量
                }
            }
            
            /**
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
            {
                NSLog(@"支持相片库");
            }
             */
        }
            break;
            
        default:
            break;
    }
    
    //照片是否可以编辑
    _imagePikerViewController.allowsEditing = _isEditing;
    
    //弹出媒体捕捉器
    [_currentVC presentViewController:_imagePikerViewController animated:YES completion:nil];
}

#pragma mark -- UIImagePickerControllerDelegate,UINavigationControllerDelegate(在这里存储头像详细)
//选取照片的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    _infoDic = [info mutableCopy];
    [self selectImageFormPickerVCForMediaDicInfo:_infoDic];
}

/**
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    
    _infoDic = [editingInfo mutableCopy];
    [self selectImageFormPickerVCForMediaDicInfo:_infoDic];
}
 */

//点击取消按钮代理
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [_imagePikerViewController dismissViewControllerAnimated:YES completion:nil];
    [self deallocCaptureVariable];//释放外部捕获的变量
}


///选取图片
- (void)selectImageFormPickerVCForMediaDicInfo:(NSDictionary *)info{
    
    /**
     获取字段信息里面的key
     SString *const  UIImagePickerControllerMediaType ;指定用户选择的媒体类型（文章最后进行扩展）
     NSString *const  UIImagePickerControllerOriginalImage ;原始图片
     NSString *const  UIImagePickerControllerEditedImage ;修改后的图片
     NSString *const  UIImagePickerControllerCropRect ;裁剪尺寸
     NSString *const  UIImagePickerControllerMediaURL ;媒体的URL
     NSString *const  UIImagePickerControllerReferenceURL ;原件的URL
     NSString *const  UIImagePickerControllerMediaMetadata;当来数据来源是照相机的时候这个值才有效
     
     UIImagePickerControllerMediaType 包含着KUTTypeImage 和KUTTypeMovie
     
     KUTTypeImage 包含：
     const CFStringRef  kUTTypeImage ;抽象的图片类型
     const CFStringRef  kUTTypeJPEG ;
     const CFStringRef  kUTTypeJPEG2000 ;
     const CFStringRef  kUTTypeTIFF ;
     const CFStringRef  kUTTypePICT ;
     const CFStringRef  kUTTypeGIF ;
     const CFStringRef  kUTTypePNG ;
     const CFStringRef  kUTTypeQuickTimeImage ;
     const CFStringRef  kUTTypeAppleICNS
     const CFStringRef kUTTypeBMP;
     const CFStringRef  kUTTypeICO;
     
     KUTTypeMovie 包含：
     const CFStringRef  kUTTypeAudiovisualContent ;抽象的声音视频
     const CFStringRef  kUTTypeMovie ;抽象的媒体格式（声音和视频）
     const CFStringRef  kUTTypeVideo ;只有视频没有声音
     const CFStringRef  kUTTypeAudio ;只有声音没有视频
     const CFStringRef  kUTTypeQuickTimeMovie ;
     const CFStringRef  kUTTypeMPEG ;
     const CFStringRef  kUTTypeMPEG4 ;
     const CFStringRef  kUTTypeMP3 ;
     const CFStringRef  kUTTypeMPEG4Audio ;
     const CFStringRef  kUTTypeAppleProtectedMPEG4Audio;
      */
    
    //获取媒体类型
    NSString* mediaType = [_infoDic objectForKey:UIImagePickerControllerMediaType];
    
    //获取用户编辑之后的图像
    UIImage *selectImage;
    
    //获取视频文件的url
    NSURL* mediaURL;
    
    //判断是静态图像还是视频
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        
        if (_isEditing) {
            selectImage = _infoDic[UIImagePickerControllerEditedImage];
        }else{
            selectImage = _infoDic[UIImagePickerControllerOriginalImage];
        }
        
        //对选择的图片进行方向处理
        selectImage = [self fixOrientation:selectImage];
        
        
        //将该图像保存到媒体库中
        UIImageWriteToSavedPhotosAlbum(selectImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        
        
    }else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
        
        mediaURL = [_infoDic objectForKey:UIImagePickerControllerMediaURL];
        
        
        //拍摄的视频存储在缓存文件tmp文件下，用完了可以进行删除掉
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(mediaURL.path)) {
            
            UISaveVideoAtPathToSavedPhotosAlbum(mediaURL.path, self, @selector(video:didFinishSavingWithError:contextInfo:), NULL);
        }
        
        
        /**
        //创建ALAssetsLibrary对象并将视频保存到媒体库
        ALAssetsLibrary* assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:mediaURL completionBlock:^(NSURL *assetURL, NSError *error) {
            if (!error) {
                NSLog(@"captured video saved with no error.");
            }else{
                NSLog(@"error occured while saving the video:%@", error);
            }
        }];
         */
        

    }
    
    [_imagePikerViewController dismissViewControllerAnimated:YES completion:nil];
    
    //选取照片进行回调
    if (_photoCallback) {
        _photoCallback(selectImage,mediaURL);
    }
    
    [self deallocCaptureVariable];//释放外部捕获的变量
}


///图片保存回调
//上面一般保存图片的回调方法为：
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSLog(@"保存了照片到相册");
}



///视频保存回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSLog(@"保存了视频到相册");
    
}




#pragma mark - 图片进行方形处理
- (UIImage *)fixOrientation:(UIImage *)img {
    
    // No-op if the orientation is already correct
    if (img.imageOrientation == UIImageOrientationUp) return img;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (img.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, img.size.width, img.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, img.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, img.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    switch (img.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, img.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, img.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, img.size.width, img.size.height,
                                             CGImageGetBitsPerComponent(img.CGImage), 0,
                                             CGImageGetColorSpace(img.CGImage),
                                             CGImageGetBitmapInfo(img.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (img.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,img.size.height,img.size.width), img.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,img.size.width,img.size.height), img.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *customimg = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return customimg;
}



- (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = 2 * M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}


#pragma mark - 图片转成base64
- (NSString *)imageIntoBase64StringWithImage:(UIImage *)image minificationScale:(CGFloat)scale{
    
    // 处理耗时操作的代码块...
    NSData *imageData = UIImageJPEGRepresentation(image, scale);
    //ios7以后才支持
    NSString *imageBase64String = [imageData base64EncodedStringWithOptions:0];
    
    return imageBase64String;
}

///压缩图片尺寸
- (UIImage *)smallImageSize:(CGSize)smallSize image:(UIImage *)image{
    
    UIGraphicsBeginImageContext(smallSize);
    [image drawInRect:CGRectMake(0, 0, smallSize.width, smallSize.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

///压缩图片到指定文件大小范围内
+ (UIImage *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    return resultImage;
}

///压缩图片到指定尺寸大小
+ (UIImage *)compressImageSize:(UIImage *)image toByte:(NSUInteger)maxLength {
    UIImage *resultImage = image;
    NSData *data = UIImageJPEGRepresentation(resultImage, 1);
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        // Use image to draw (drawInRect:), image is larger but more compression time
        // Use result image to draw, image is smaller but less compression time
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, 1);
    }
    return resultImage;
}



@end

//
//  GFSelectPhoto.m
//  GFAPP
//
//  Created by gaoyafeng on 2018/7/5.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "GFSelectPhoto.h"

@interface GFSelectPhoto ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

/** 图片选择器 */
@property (strong,nonatomic)UIImagePickerController *imagePikerViewController;

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
    }
    return self;
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
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
    }]];
    
    [viewController presentViewController:alertView animated:YES completion:nil];
    
    
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
                _imagePikerViewController.sourceType = UIImagePickerControllerSourceTypeCamera;
                _imagePikerViewController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                _imagePikerViewController.cameraDevice = _cameraDevice;//前置摄像头
                
            }else{
                //没有打开相机权限
                if (_authorCallback) {
                    _authorCallback(1);
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
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                _imagePikerViewController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }else{
                //没有打开相册权限
                if (_authorCallback) {
                    _authorCallback(2);
                }
            }
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
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self selectImageFormPickerVCForMediaDicInfo:info];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self selectImageFormPickerVCForMediaDicInfo:editingInfo];
}

///选取图片
- (void)selectImageFormPickerVCForMediaDicInfo:(NSDictionary *)info{
    
    UIImage *selectImage;
    if (_isEditing) {
        selectImage = info[UIImagePickerControllerEditedImage];
    }else{
        selectImage = info[UIImagePickerControllerOriginalImage];
    }
    
    selectImage = [self fixOrientation:selectImage];//对选择的图片进行方向处理
    
    //选取照片进行回调
    if (_photoCallback) {
        _photoCallback(selectImage);
    }
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





@end

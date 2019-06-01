//
//  GFSelectPhoto.h
//  GFAPP
//  选取照片
//  Created by gaoyafeng on 2018/7/5.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 权限回调 type:0:取消 1:相机权限未打开  2:相册权限未打开 */
typedef void (^BlockAuthor)(NSInteger type);

typedef void (^BlockPhoto)(UIImage *photo,NSURL *mediaUrl);

@interface GFSelectPhoto : NSObject

/** 照片是否可以进行编辑(默认为不编辑) */
@property (nonatomic,assign) BOOL isEditing;

/** 选择相机时，摄像头前后的选择（默认为前置摄像头） */
@property (nonatomic,assign) UIImagePickerControllerCameraDevice cameraDevice;

/** 获取资源类型 (默认为照片) */
@property (nonatomic,assign) UIImagePickerControllerCameraCaptureMode mediaType;

/** 拍摄时间(默认20秒) */
@property (nonatomic,assign) NSInteger maxVideoTime;


///单利初始化
+(instancetype)shareInstance;

///直接进入 拍照 && 相册 type: 0相机   1相册
+ (void)getOnePictureFromCameraOrPhotoAlbumAType:(NSInteger)type formVC:(APPBaseViewController *)superVC blockResult:(APPBackBlock)blockResult;

///拍照取货
+ (void)takePhotosFormVC:(UIViewController *)superVC blockResult:(APPBackBlock)blockResult;


/**
 *  @brief 弹框提示选择 相册 && 相机
 *
 *  @param viewController 要选择相片的VC
 *  @param authorCallback 如果相机&&相册没有授权则进行回调
 *  @param photoCallback  选择相片回调
 */
- (void)alertSelectTypeWithVC:(UIViewController *)viewController authorBlock:(BlockAuthor)authorCallback photoBlock:(BlockPhoto)photoCallback;


/**
 *  @brief 图片转成base64
 *
 *  @param image 要转变的image
 *  @param scale 图片质量缩小倍数 范围：0.0~1.0
 *
 *  @return base64String
 */
- (NSString *)imageIntoBase64StringWithImage:(UIImage *)image minificationScale:(CGFloat)scale;

///压缩图片尺寸
- (UIImage *)smallImageSize:(CGSize)smallSize image:(UIImage *)image;

///压缩图片到指定文件大小范围内
+ (UIImage *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength;

///压缩图片到指定尺寸大小
+ (UIImage *)compressImageSize:(UIImage *)image toByte:(NSUInteger)maxLength;


#pragma mark - ***************************** 相机拍照 图片处理 *****************************
//拍照图片进行处理
+ (UIImage*)image_CameraImage:(UIImage *)imageCamera scaleToSize:(CGSize)size;

///裁剪图片 CGImageRef的图片位置左下角为(0,0) 倒置180度
+ (UIImage *)image_CropImage:(UIImage*)image toRect:(CGRect)rect;



@end

/** 用法一
_btnTemporary = btnTakePhoto;

[FSSelectPhoto takePhotosFormVC:self blockResult:^(BOOL result, id idObject) {
    
    if (result) {
        
        [self.btnTemporary setTakePhotoWithImage:(UIImage *)idObject];
    }
}];
 */

/** 用法 二
 
 //必须在info.plist文件中添加这两个字段
 2.相机权限：
 Privacy - Camera Usage Description
 是否允许此App使用你的相机？ 骑手端需要获取您的照片库,否则无法进行“拍照取货”功能！而影响您的使用。
 
 3.图片库权限：
 Privacy - Photo Library Usage Description
 是否允许此App访问照片库  骑手端需要获取您的照片库权限,否则无法进行“拍照取货”功能！而影响您的使用。
 
 4、照片库添加照片（往本地写照片）
 Privacy - Photo Library Additions Usage Description
 访问照片库  骑手端需要获取您的照片库权限,否则无法进行“拍照取货”功能！而影响您的使用。
 
 
APPWeakSelf
 [GFSelectPhoto shareInstance].isEditing = YES;
 [GFSelectPhoto shareInstance].mediaType = UIImagePickerControllerCameraCaptureModePhoto;
 
[[GFSelectPhoto shareInstance] alertSelectTypeWithVC:self authorBlock:^(NSInteger type) {
    //type:0:取消 1:相机权限未打开  2:相册权限未打开
    switch (type) {
        case 0:
            NSLog(@"取消");
            break;
        case 1:
            NSLog(@"相机权限未授权");
            [weakSelf showMessage:@"请到设置中打开相机授权权限"];
            break;
        case 2:
            NSLog(@"相册权限未授权");
            [weakSelf showMessage:@"请到设置中打开相册授权权限"];
            break;
            
        default:
            break;
    }
    
} photoBlock:^(UIImage *photo) {
    
    [weakSelf.iconBtn setImage:photo forState:UIControlStateNormal];
    
}];
 
 */

/** 用法
_imgView = [[UIImageView alloc] init];
 //这种填充模式，图片会居中显示，而且图片不会被变形
_imgView.contentMode = UIViewContentModeScaleAspectFill;
_imgView.clipsToBounds = YES;
_imgView.backgroundColor = [UIColor grayColor];
_imgView.frame = CGRectMake(100, 200, 200, 100);
[self.view addSubview:_imgView];
 */








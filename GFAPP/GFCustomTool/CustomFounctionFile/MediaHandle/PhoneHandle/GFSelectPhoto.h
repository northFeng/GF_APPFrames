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

typedef void (^BlockPhoto)(UIImage *photo);

@interface GFSelectPhoto : NSObject

/** 照片是否可以进行编辑(默认为不编辑) */
@property (nonatomic,assign) BOOL isEditing;

/** 选择相机时，摄像头前后的选择（默认为前置摄像头） */
@property (nonatomic,assign) UIImagePickerControllerCameraDevice cameraDevice;


///单利初始化
+(instancetype)shareInstance;


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

@end

/** 用法
 
 //必须在info.plist文件中添加这两个字段
 2.相机权限：
 Privacy - Camera Usage Description
 是否允许此App使用你的相机？
 3.相册权限：
 Privacy - Photo Library Usage Description
 是否允许此App访问你的媒体资料库？
 
 
APPWeakSelf
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








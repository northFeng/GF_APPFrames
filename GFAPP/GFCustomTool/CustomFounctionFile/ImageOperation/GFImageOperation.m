//
//  GFImageOperation.m
//  GFAPP
//
//  Created by XinKun on 2017/11/28.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "GFImageOperation.h"

#import <CoreImage/CoreImage.h>//图像核心框架

#import <ImageIO/ImageIO.h>

@implementation GFImageOperation

//添加毛玻璃效果（ios8之后）
- (void)image_FrostedEffectForImageViewIOS8Leter:(UIImageView *)imageView image:(UIImage *)image blurType:(UIBlurEffectStyle)blurType{
    
    imageView.image = image;
    /*
     UIBlurEffectStyleExtraLight,//白色
     UIBlurEffectStyleLight,//亮风格
     UIBlurEffectStyleDark,//暗风格
     UIBlurEffectStyleExtraDark __TVOS_AVAILABLE(10_0) __IOS_PROHIBITED __WATCHOS_PROHIBITED,
     UIBlurEffectStyleRegular NS_ENUM_AVAILABLE_IOS(10_0), // Adapts to user interface style
     UIBlurEffectStyleProminent NS_ENUM_AVAILABLE_IOS(10_0), // Adapts to user interface style
     
     */
    //实现模糊效果
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:blurType];//修改毛玻璃类型
    //毛玻璃视图
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    visualEffectView.frame = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height);
    [imageView addSubview:visualEffectView];
    //[effectview removeFromSuperview];//移除模糊层
    
    //    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blur];
    //    UIVisualEffectView *ano = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
    //    ano.frame = imageView.frame;
    //
    //    [visualEffectView.contentView addSubview:ano];

    
}

//添加毛玻璃效果（ios8之前）
- (void)image_FrostedEffectForImageViewIOS8Before:(UIImageView *)imageView toolBarAlpha:(CGFloat)alpha{
    
    //在iOS 7之前系统的类提供UIToolbar来实现毛玻璃效果：
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:imageView.bounds];
    /*
     * UIBarStyleDefault          = 0,
     * UIBarStyleBlack            = 1,
     * UIBarStyleBlackOpaque      = 1, // Deprecated. Use UIBarStyleBlack
     * UIBarStyleBlackTranslucent = 2, // Deprecated. Use UIBarStyleBlack and set the translucent property to YES
     */
    toolBar.barStyle = UIBarStyleBlack;
    toolBar.alpha = alpha;//可以设置透明度
    [imageView addSubview:toolBar];
}

///添加毛玻璃和高斯模糊混合使用
- (void)image_FrostedEffectAndGaussianBlurWithImageView:(UIImageView *)imageView image:(UIImage *)image backAlpha:(CGFloat)alpha{
    
    CIImage *inputImage = [CIImage imageWithCGImage:imageView.image.CGImage];
    
    // CIGaussianBlur   高斯模糊
    // CIBoxBlur        均值模糊
    // CIDiscBlur       环形卷积模糊
    // CIMotionBlur     运动模糊
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:@5 forKey:kCIInputRadiusKey];
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *outupImage = filter.outputImage;
    CGImageRef imageRef = [context createCGImage:outupImage fromRect:outupImage.extent];
    imageView.image= [UIImage imageWithCGImage:imageRef];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:imageView.bounds];
    toolBar.barStyle = UIBarStyleBlack;
    toolBar.alpha = alpha;
    [imageView addSubview:toolBar];
    
}

//添加高斯模糊效果
- (void)image_GaussianBlurForImageView:(UIImageView *)imageView type:(GFImageGaussianBlurType)blurType{
    
    CIImage *inputImage = [CIImage imageWithCGImage:imageView.image.CGImage];

    NSString *typeStr;
    switch (blurType) {
        case GFImageGaussianBlurType_CIGaussianBlur:
            // CIGaussianBlur   高斯模糊
            typeStr = @"CIGaussianBlur";
            break;
        case GFImageGaussianBlurType_CIBoxBlur:
            // CIBoxBlur        均值模糊
            typeStr = @"CIBoxBlur";
            break;
        case GFImageGaussianBlurType_CIDiscBlur:
            // CIDiscBlur       环形卷积模糊
            typeStr = @"CIDiscBlur";
            break;
        case GFImageGaussianBlurType_CIMotionBlur:
            // CIMotionBlur     运动模糊
            typeStr = @"CIMotionBlur";
            break;
        default:
            break;
    }
    if (typeStr==nil) {
        return ;
    }
    CIFilter *filter = [CIFilter filterWithName:typeStr];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:@5 forKey:kCIInputRadiusKey];
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *outupImage = filter.outputImage;
    CGImageRef imageRef = [context createCGImage:outupImage fromRect:outupImage.extent];
    imageView.image= [UIImage imageWithCGImage:imageRef];
    
}

//添加滤镜效果
- (void)image_FilterForImageView:(UIImageView *)imageView type:(GFImageEffectType)effectType{
   
    /* 让子视图全部移除
     *[imageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
     */
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:imageView.image];
    
    NSString *typeStr;
    switch (effectType) {
        case GFImageEffectType_Instant:
            // 怀旧  CIPhotoEffectInstant
            typeStr = @"CIPhotoEffectInstant";
            break;
        case GFImageEffectType_Mono:
            // 单色  CIPhotoEffectMono
            typeStr = @"CIPhotoEffectMono";
            break;
        case GFImageEffectType_Noir:
            // 黑白  CIPhotoEffectMono
            typeStr = @"CIPhotoEffectMono";
            break;
        case GFImageEffectType_Fade:
            // 褪色  CIPhotoEffectMono
            typeStr = @"CIPhotoEffectMono";
            break;
        case GFImageEffectType_Tonal:
            // 色调  CIPhotoEffectMono
            typeStr = @"CIPhotoEffectMono";
            break;
        case GFImageEffectType_Process:
            // 冲印  CIPhotoEffectProcess
            typeStr = @"CIPhotoEffectProcess";
            break;
        case GFImageEffectType_Transfer:
            // 岁月  CIPhotoEffectTransfer
            typeStr = @"CIPhotoEffectTransfer";
            break;
        case GFImageEffectType_Chrome:
            // 铬黄  CIPhotoEffectChrome
            typeStr = @"CIPhotoEffectChrome";
            break;
        default:
            break;
    }
    CIFilter *filter = [CIFilter filterWithName:typeStr];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
    imageView.image= [UIImage imageWithCGImage:resultImage.CGImage];
    
}

//添加GIF图片
- (void)image_GIFImageShowOnImageView:(UIImageView *)imageView gifName:(NSString *)gifName{
    
    //1.找到文件获取文件数据
    if ([gifName hasSuffix:@".gif"]) {
        gifName = [gifName stringByReplacingOccurrencesOfString:@".gif" withString:@""];
    }
    NSURL *url = [[NSBundle mainBundle] URLForResource:gifName withExtension:@".gif"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (!data) {
        return ;
    }
    //2.获取文件资源 这里需要导入imageIO类
    CGImageSourceRef sourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count =  CGImageSourceGetCount(sourceRef);
    NSTimeInterval douration = 0;//存储gif动画总时间
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:3];//储存的图片
    for (size_t i = 0; i < count; i++) {
        //获取每一张图片 并保存需要的信息
        CGImageRef imageRef =  CGImageSourceCreateImageAtIndex(sourceRef, i, NULL);
        if (imageRef) {
            [images addObject:[UIImage imageWithCGImage:imageRef]];
            NSDictionary *dict = (__bridge NSDictionary *) CGImageSourceCopyPropertiesAtIndex(sourceRef, i, NULL);
            NSDictionary *gifPorperty = dict[(__bridge NSString *)kCGImagePropertyGIFDictionary];
            NSNumber *unclampedDelayTime = gifPorperty[(__bridge NSString *)kCGImagePropertyGIFUnclampedDelayTime];
            float thisDelyTime = 0;
            if (unclampedDelayTime) {
                thisDelyTime = unclampedDelayTime.floatValue;
            }else{
                NSNumber *delyTime = gifPorperty[(__bridge NSString *)kCGImagePropertyGIFDelayTime];
                thisDelyTime = delyTime.floatValue;
            }
            //如果低于10ms 设置成100ms参考如下解释
            // Many annoying ads specify a 0 duration to make an image flash as quickly as possible.
            // We follow Firefox's behavior and use a duration of 100 ms for any frames that specify
            // a duration of <= 10 ms. See <rdar://problem/7689300> and <http://webkit.org/b/36082>
            // for more information.
            if (thisDelyTime <= 0.001f) {
                thisDelyTime = 0.1f;
            }
            douration += thisDelyTime;
        }
        CGImageRelease(imageRef);
    }
    CFRelease(sourceRef);
    //获得最终图片
    imageView.image = [UIImage animatedImageWithImages:images duration:douration];
    
}

//获取GIF图片的第一帧图片
- (UIImage *)image_GetGIFImageFirstFrameForGIFImage:(NSString *)gifName{
    //1.找到文件获取文件数据
    if ([gifName hasSuffix:@".gif"]) {
        gifName = [gifName stringByReplacingOccurrencesOfString:@".gif" withString:@""];
    }
    NSURL *url = [[NSBundle mainBundle] URLForResource:gifName withExtension:@".gif"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (!data) {
        return nil;
    }
    //2.获取文件资源 这里需要导入imageIO类
    CGImageSourceRef sourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    //获取每一张图片 并保存需要的信息
    CGImageRef imageRef =  CGImageSourceCreateImageAtIndex(sourceRef, 0, NULL);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return image;
}

@end

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
    
    /**
      iOS9.3后新增的滤镜
    CORE_IMAGE_EXPORT NSString * const kCICategoryDistortionEffect;
    CORE_IMAGE_EXPORT NSString * const kCICategoryGeometryAdjustment;
    CORE_IMAGE_EXPORT NSString * const kCICategoryCompositeOperation;
    CORE_IMAGE_EXPORT NSString * const kCICategoryHalftoneEffect;
    CORE_IMAGE_EXPORT NSString * const kCICategoryColorAdjustment;
    CORE_IMAGE_EXPORT NSString * const kCICategoryColorEffect;
    CORE_IMAGE_EXPORT NSString * const kCICategoryTransition;
    CORE_IMAGE_EXPORT NSString * const kCICategoryTileEffect;
    CORE_IMAGE_EXPORT NSString * const kCICategoryGenerator;
    CORE_IMAGE_EXPORT NSString * const kCICategoryReduction NS_AVAILABLE(10_5, 5_0);
    CORE_IMAGE_EXPORT NSString * const kCICategoryGradient;
    CORE_IMAGE_EXPORT NSString * const kCICategoryStylize;
    CORE_IMAGE_EXPORT NSString * const kCICategorySharpen;
    CORE_IMAGE_EXPORT NSString * const kCICategoryBlur;
    CORE_IMAGE_EXPORT NSString * const kCICategoryVideo;
    CORE_IMAGE_EXPORT NSString * const kCICategoryStillImage;
    CORE_IMAGE_EXPORT NSString * const kCICategoryInterlaced;
    CORE_IMAGE_EXPORT NSString * const kCICategoryNonSquarePixels;
    CORE_IMAGE_EXPORT NSString * const kCICategoryHighDynamicRange;
    CORE_IMAGE_EXPORT NSString * const kCICategoryBuiltIn;
    CORE_IMAGE_EXPORT NSString * const kCICategoryFilterGenerator NS_AVAILABLE(10_5, 9_0);
     */
    //使用GPUImage框架 滤镜更多还可以自己调制滤镜的配色
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
    
    /**
    NSData *imgGifData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"es_sf_mgs" withExtension:@".gif"]];
    UIWebView *webView = [[UIWebView alloc] init];
    webView.backgroundColor = [UIColor clearColor];
    webView.scalesPageToFit = YES;
    webView.scrollView.scrollEnabled = NO;
    [webView loadData:imgGifData MIMEType:@"image/gif" textEncodingName:@"" baseURL:[NSURL URLWithString:@""]];
    [self.view addSubview:webView];
     */
}

///获取GIF格式动画解析成图片数组
- (NSMutableArray *)image_GetImageGroupFormImgGif:(NSString *)gifName{
    
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    
    //1.找到文件获取文件数据
    if ([gifName hasSuffix:@".gif"]) {
        gifName = [gifName stringByReplacingOccurrencesOfString:@".gif" withString:@""];
    }
    NSURL *url = [[NSBundle mainBundle] URLForResource:gifName withExtension:@".gif"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (!data) {
        return frames;
    }
    
    CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)data, NULL);
    CGFloat animationTime = 0.f;
    if (src) {
        size_t l = CGImageSourceGetCount(src);
        frames = [NSMutableArray arrayWithCapacity:l];
        for (size_t i = 0; i < l; i++) {
            CGImageRef img = CGImageSourceCreateImageAtIndex(src, i, NULL);
            NSDictionary *properties = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(src, i, NULL));
            NSDictionary *frameProperties = [properties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
            NSNumber *delayTime = [frameProperties objectForKey:(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
            animationTime += [delayTime floatValue];
            if (img) {
                [frames addObject:[UIImage imageWithCGImage:img]];
                CGImageRelease(img);
            }
        }
        CFRelease(src);
    }
    return frames;
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

/**
 图片合成文字
 
 @param img 要处理的image
 @param logoText 要显示富文本
 @return UIImage
 */
- (UIImage *)image_AddTextWithImage:(UIImage *)img text:(NSString *)logoText logoTextAttributesDic:(NSDictionary *)attrDic logoFrame:(CGRect)logoRect{
    
    NSString* mark = logoText;
    int w = img.size.width;
    int h = img.size.height;
    UIGraphicsBeginImageContext(img.size);
    [img drawInRect:CGRectMake(0, 0, w, h)];
    //位置显示
    [mark drawInRect:logoRect withAttributes:attrDic];
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return aimg;
}

/**
 本地图片合成
 
 @param mainImage 主图片
 @param maskImage 标记图片
 @return 新图像
 */
- (UIImage *)image_AddLocalImage:(UIImage *)mainImage addMsakImage:(UIImage *)maskImage maskImageFrame:(CGRect)maskRect{
    
    UIGraphicsBeginImageContextWithOptions(mainImage.size ,NO, 0.0);
    
    [mainImage drawInRect:CGRectMake(0, 0, mainImage.size.width, mainImage.size.height)];
    
    //四个参数为水印图片的位置
    [maskImage drawInRect:maskRect];
    //如果要多个位置显示，继续drawInRect就行
    //[maskImage drawInRect:CGRectMake(0, useImage.size.height/2, useImage.size.width, useImage.size.height/2)];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

/**
 下载网络图片合成
 
 @param imgUrl 网络图片地址
 @param imgUrl2 网络图片地址2
 @param imgView 展示图像的ImgView
 */
- (void)image_AddUrlImage:(NSString *)imgUrl image2:(NSString *)imgUrl2 showinImageView:(UIImageView *)imgView
{
    // 1.队列组、全局并发队列 的初始化
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 2.在block内部不能修改外部的局部变量，这里必须要加前缀 __block
    __block UIImage *image1 = nil;
    
    // 注意这里的异步执行方法多了一个group（队列）
    dispatch_group_async(group, queue, ^{
        NSURL *url1 = [NSURL URLWithString:imgUrl];
        NSData *data1 = [NSData dataWithContentsOfURL:url1];
        image1 = [UIImage imageWithData:data1];
    });
    
    // 3.下载图片2
    __block UIImage *image2 = nil;
    dispatch_group_async(group, queue, ^{
        NSURL *url2 = [NSURL URLWithString:imgUrl2];
        NSData *data2 = [NSData dataWithContentsOfURL:url2];
        image2 = [UIImage imageWithData:data2];
    });
    
    __block UIImage *fullImage;
    // 4.合并图片 (保证执行完组里面的所有任务之后，再执行notify函数里面的block)
    dispatch_group_notify(group, queue, ^{
        
        UIGraphicsBeginImageContextWithOptions(image1.size ,NO, 0.0);
        [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
        [image2 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height/2)];
        fullImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            imgView.image = fullImage;
        });
    });
}


/**
 裁剪圆形图片
 
 @param image 要裁剪的图像
 @param strokeColor 裁剪圆形外边的填充颜色
 @param edgeWidth 裁剪外边的宽度
 */
- (UIImage*)image_ClipImage:(UIImage*)image strokeColor:(UIColor *)strokeColor withEdgeWidth:(CGFloat)edgeWidth{
    
    
    //要裁剪的大小
    CGFloat clipWidth = image.size.width >= image.size.height ? image.size.height : image.size.width;
    CGRect rect = CGRectMake(edgeWidth, edgeWidth, clipWidth - (edgeWidth * 2.0f), clipWidth - (edgeWidth * 2.0f));
    
    //获取图片上下文
    UIGraphicsBeginImageContext(CGSizeMake(clipWidth, clipWidth));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //这里设置成了1但画出的线还是2px,给我们的感觉好像最小只能是2px。
    //原因是因为默认情况下，锯齿显示，所以它显示为宽度= 2.0，关闭消除锯齿可以解决问题了。
    CGContextSetLineWidth(context, edgeWidth);//划线的宽度
    
    //线条填充颜色
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    
    //裁剪圆形区域
    //将“rect”内的椭圆添加到当前的“context”路径中
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    //绘制原有图像
    CGRect rectImg = CGRectMake(0, 0, clipWidth - (edgeWidth * 2.0), clipWidth - (edgeWidth * 2.0));
    [image drawInRect:rectImg];
    
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //返回裁剪后的图像
    return newimg;
}

///将颜色转化为UIImage的函数
- (UIImage *)image_getImageWithColor:(UIColor *)color{
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    [color setFill];
    
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}


///截取当前view的图层生成image
- (UIImage *)image_CaptureImageFormViewLayer:(UIView *)captureView{
    
    UIGraphicsBeginImageContextWithOptions(captureView.frame.size ,NO, 0.0);
    
    //把view的图层绘制到当前绘制图片的图层
    [captureView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    /**
    //以png格式返回指定图片的数据
    NSData *imageData = UIImagePNGRepresentation(extractImage);
    UIImage *imge = [UIImage imageWithData:imageData];
     */
    
    UIGraphicsEndImageContext();
    
    return image;
}


//把相机拍照图片进行转换
-(UIImage*)image_cameraImage:(UIImage *)cameraImage scaleToSize:(CGSize)size{
    /*
     UIGraphicsBeginImageContextWithOptions(CGSize size, BOOL opaque, CGFloat scale)
     CGSize size：指定将来创建出来的bitmap的大小
     BOOL opaque：设置透明YES代表透明，NO代表不透明
     CGFloat scale：代表缩放,0代表不缩放
     创建出来的bitmap就对应一个UIImage对象
     */
    UIGraphicsBeginImageContextWithOptions(size, NO, 2.0); //此处将画布放大两倍，这样在retina屏截取时不会影响像素
    
    [cameraImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}


///裁剪图片 CGImageRef的图片位置左下角为(0,0) 倒置180度
- (UIImage *)image_cropImage:(UIImage*)image toRect:(CGRect)rect {
    CGFloat (^rad)(CGFloat) = ^CGFloat(CGFloat deg) {
        return deg / 180.0f * (CGFloat) M_PI;
    };
    
    // determine the orientation of the image and apply a transformation to the crop rectangle to shift it to the correct position
    CGAffineTransform rectTransform;
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(90)), 0, -image.size.height);
            break;
        case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-90)), -image.size.width, 0);
            break;
        case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-180)), -image.size.width, -image.size.height);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
    };
    
    // adjust the transformation scale based on the image scale
    rectTransform = CGAffineTransformScale(rectTransform, image.scale, image.scale);
    
    // apply the transformation to the rect to create a new, shifted rect
    CGRect transformedCropSquare = CGRectApplyAffineTransform(rect, rectTransform);
    // use the rect to crop the image
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, transformedCropSquare);
    // create a new UIImage and set the scale and orientation appropriately
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    // memory cleanup
    CGImageRelease(imageRef);
    
    return result;
}


///压缩图片到指定文件大小内
+ (UIImage *)img_compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength {
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



@end

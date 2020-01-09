//
//  GFImageOperation.h
//  GFAPP
//  处理图像
//  Created by XinKun on 2017/11/28.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  高斯模糊类型：0:CIGaussianBlur:高斯模糊  1:CIBoxBlur:均值模糊  2:CIDiscBlur:环形卷积模糊  3:CIMotionBlur:运动模糊
 */
typedef NS_ENUM(NSInteger,GFImageGaussianBlurType) {
    /**
     *  高斯模糊
     */
    GFImageGaussianBlurType_CIGaussianBlur = 0,
    /**
     *  均值模糊
     */
    GFImageGaussianBlurType_CIBoxBlur,
    /**
     *  环形卷积模糊
     */
    GFImageGaussianBlurType_CIDiscBlur,
    /**
     *  运动模糊
     */
    GFImageGaussianBlurType_CIMotionBlur,
};

/**
 *  滤镜效果：怀旧、单色、黑白、褪色、色调、冲印、岁月、铬黄
 */
typedef NS_ENUM(NSInteger,GFImageEffectType) {
    /**
     *  怀旧
     */
    GFImageEffectType_Instant = 0,
    /**
     *  单色
     */
    GFImageEffectType_Mono,
    /**
     *  黑白
     */
    GFImageEffectType_Noir,
    /**
     *  褪色
     */
    GFImageEffectType_Fade,
    /**
     *  色调
     */
    GFImageEffectType_Tonal,
    /**
     *  冲印
     */
    GFImageEffectType_Process,
    /**
     *  岁月
     */
    GFImageEffectType_Transfer,
    /**
     *  铬黄
     */
    GFImageEffectType_Chrome,
};

@interface GFImageOperation : NSObject


/**
 *  @brief 添加毛玻璃效果（ios8之后）
 *
 *  @param imageView 添加毛玻璃的图像视图
 *  @param image 修为毛玻璃的image
 *  @param blurType 毛玻璃类型
 */
- (void)image_FrostedEffectForImageViewIOS8Leter:(UIImageView *)imageView image:(UIImage *)image blurType:(UIBlurEffectStyle)blurType;

/**
 *  @brief 添加毛玻璃效果（ios8之前）
 *
 *  @param imageView 添加毛玻璃的图像视图
 *  @param alpha 毛玻璃透明度
 */
- (void)image_FrostedEffectForImageViewIOS8Before:(UIImageView *)imageView toolBarAlpha:(CGFloat)alpha;

/**
 *  @brief 添加毛玻璃和高斯模糊混合使用
 *
 *  @param imageView 添加毛玻璃的图像视图
 *  @param alpha 毛玻璃透明度
 */
- (void)image_FrostedEffectAndGaussianBlurWithImageView:(UIImageView *)imageView image:(UIImage *)image backAlpha:(CGFloat)alpha;

/**
 *  @brief 添加高斯模糊效果
 *
 *  @param imageView 添加高斯模糊效果的图像视图
 *  @param blurType 高斯模糊类型
 */
- (void)image_GaussianBlurForImageView:(UIImageView *)imageView type:(GFImageGaussianBlurType)blurType;

/**
 *  @brief 添加滤镜效果
 *
 *  @param imageView 添加滤镜效果的图像视图
 */
- (void)image_FilterForImageView:(UIImageView *)imageView type:(GFImageEffectType)effectType;

/**
 *  @brief 添加GIF图片
 *
 *  @param imageView 添加GIF图片的图像视图
 *  @param gifName gif图片名字
 */
- (void)image_GIFImageShowOnImageView:(UIImageView *)imageView gifName:(NSString *)gifName;


/**
 *  @brief 获取GIF格式动画解析成图片数组
 *
 *  @param gifName gif图片名字
 */
- (NSMutableArray *)image_GetImageGroupFormImgGif:(NSString *)gifName;

/**
 *  @brief 获取GIF图片的第一帧图片
 *
 *  @param gifName gif图片名字
 */
- (UIImage *)image_GetGIFImageFirstFrameForGIFImage:(NSString *)gifName;

/**
 图片合成文字
 
 @param img 要处理的image
 @param logoText 要显示富文本
 @return UIImage
 */
- (UIImage *)image_AddTextWithImage:(UIImage *)img text:(NSString *)logoText logoTextAttributesDic:(NSDictionary *)attrDic logoFrame:(CGRect)logoRect;

/**
 本地图片合成
 
 @param mainImage 主图片
 @param maskImage 标记图片
 @return 新图像
 */
- (UIImage *)image_AddLocalImage:(UIImage *)mainImage addMsakImage:(UIImage *)maskImage maskImageFrame:(CGRect)maskRect;

/**
 下载网络图片合成
 
 @param imgUrl 网络图片地址
 @param imgUrl2 网络图片地址2
 @param imgView 展示图像的ImgView
 */
- (void)image_AddUrlImage:(NSString *)imgUrl image2:(NSString *)imgUrl2 showinImageView:(UIImageView *)imgView;

/**
 裁剪圆形图片
 
 @param image 要裁剪的图像
 @param strokeColor 裁剪圆形外边的填充颜色
 @param edgeWidth 裁剪外边的宽度
 */
- (UIImage*)image_ClipImage:(UIImage*)image strokeColor:(UIColor *)strokeColor withEdgeWidth:(CGFloat)edgeWidth;

/**
 将颜色转化为UIImage的函数
 
 @param color 需要的颜色
 @return UIImage
 */
- (UIImage *)image_getImageWithColor:(UIColor *)color;

/**
 截取当前view的图层生成image
 //保存到相册
 UIImageWriteToSavedPhotosAlbum(image, self, @selector(image: didFinishSavingWithError:contextInfo:), nil);
 
 @param captureView 需要截屏的view
 @return UIImage
 */
- (UIImage *)image_CaptureImageFormViewLayer:(UIView *)captureView;


//把相机拍照图片进行转换
-(UIImage*)image_cameraImage:(UIImage *)cameraImage scaleToSize:(CGSize)size;


///裁剪图片 CGImageRef的图片位置左下角为(0,0) 倒置180度
- (UIImage *)image_cropImage:(UIImage*)image toRect:(CGRect)rect;


///压缩图片到指定文件大小内
+ (UIImage *)img_compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength;


@end

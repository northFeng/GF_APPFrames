//
//  GFGIFImageView.m
//  GFAPP
//
//  Created by gaoyafeng on 2018/5/17.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "GFGIFImageView.h"

#import <CoreImage/CoreImage.h>//图像核心框架

@implementation GFGIFImageView


///设置gif图片动画
- (void)setGifImageWithGifName:(NSString *)gifName{
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
    
    self.image = [UIImage animatedImageWithImages:images duration:douration];
    
    //设置三个属性
    [self setAnimationTime:douration];
    [self setGifName:gifName];
    [self setGifImgArray:images];
    
}

- (void)setGifName:(NSString *)gifName{
    _gifName = gifName;
}
- (void)setGifImgArray:(NSArray *)gifImgArray{
    _gifImgArray = gifImgArray;
}
- (void)setAnimationTime:(CGFloat)animationTime{
    _animationTime = animationTime;
}





@end

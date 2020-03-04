//
//  GFSlider.h
//  APPBase
//  自定义slider
//  Created by 峰 on 2019/11/9.
//  Copyright © 2019 峰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GFSliderDelegate <NSObject>

///滑动块移动触发回调
- (void)sliderValue:(CGFloat)value;

///滑动块结束触发回调
- (void)sliderTrackEnd:(CGFloat)value;


@end

@interface GFSlider : UISlider

///回调代理
@property (nonatomic,weak) id <GFSliderDelegate> delegate;

///滑动块左边颜色
@property (nonatomic,strong) UIColor *leftTrakColor;

///滑块右边颜色
@property (nonatomic,strong) UIColor *rightTrakColor;

///缓存进度颜色
@property (nonatomic,strong) UIColor *cacheProgressColor;


///滑动条的高度 (范围 0.~父视图高度)
@property (nonatomic,assign) CGFloat sliderHeight;

///设置缓存进度(范围0~1)
@property (nonatomic,assign) CGFloat cacheValue;


/// 设置滑块按钮图片
/// @param normalImage 默认状态image
/// @param selectImage 滑动状态下image
- (void)setTrackNormalImage:(UIImage *)normalImage selectdImage:(UIImage *)selectImage;




@end

NS_ASSUME_NONNULL_END

/**
- (CBSlider *)slider {
    if (!_slider) {
        _slider = [[CBSlider alloc] init];
        _slider.leftTrakColor = APPColorFunction.textBlueColor;
        _slider.rightTrakColor = COLOR(@"#E6EAED");
        _slider.cacheProgressColor = COLOR(@"#E6EAED");
        _slider.sliderHeight = 6;
        [_slider setTrackNormalImage:ImageNamed(@"audio_silderImg") selectdImage:ImageNamed(@"")];
        _slider.delegate = self;
    }
    return _slider;
}

#pragma mark - ************************* 滑动条代理 *************************
///滑动块移动触发回调
- (void)sliderValue:(CGFloat)value {
    _isSlidering = YES;//正在滑动
    
    if (_duration > 0) {
        //改变时间
        NSUInteger cureentTime = (NSUInteger)(_duration * value);
        self.leftTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",(int)(cureentTime/60),(int)(cureentTime%60)];
    }
}

///滑动块结束触发回调
- (void)sliderTrackEnd:(CGFloat)value {
    _isSlidering = NO;//结束滑动
    
    if (![[APPAudioPlayer shareInstance] isPlaying]) {
        //改变时间
        NSUInteger cureentTime = (NSUInteger)(_duration * value);
        self.leftTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",(int)(cureentTime/60),(int)(cureentTime%60)];
        
        _isPauseSeek = YES;
    }
    
    [[APPAudioPlayer shareInstance] seekToPositon:value];
}
 */

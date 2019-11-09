//
//  GFSlider.m
//  APPBase
//
//  Created by 峰 on 2019/11/9.
//  Copyright © 2019 峰. All rights reserved.
//

#import "GFSlider.h"

@implementation GFSlider
{

    UIProgressView *_progressView;//缓存进度条
    
    UITapGestureRecognizer *_tapGesture;//点击手势
}

- (instancetype)init {
    if (self = [super init]) {
       
        self.backgroundColor = [UIColor clearColor];
        
        self.maximumTrackTintColor = [UIColor clearColor];//滑动块右边颜色清空
        
        [self createView];
        
        //添加一个点击手势
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapSliderGesture)];
        [self addGestureRecognizer:_tapGesture];
    }
    return self;
}

///创建视图和约束
- (void)createView {
    
    _progressView = [[UIProgressView alloc] init];
    _progressView.userInteractionEnabled = NO;
    _progressView.progressViewStyle = UIProgressViewStyleDefault;
    _progressView.progressTintColor = [UIColor clearColor];
    _progressView.trackTintColor = [UIColor clearColor];
    _progressView.progress = 0.0;
    [self addSubview:_progressView];
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerY.equalTo(self);
        make.height.equalTo(self);
    }];
    
    //添加滑动事件
    [self addTarget:self action:@selector(changeValue) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - ************************* 滑动条颜色设置 *************************

- (void)setLeftTrakColor:(UIColor *)leftTrakColor {
    _leftTrakColor = leftTrakColor;
    self.minimumTrackTintColor = leftTrakColor;
}

- (void)setRightTrakColor:(UIColor *)rightTrakColor {
    _rightTrakColor = rightTrakColor;
    _progressView.trackTintColor = rightTrakColor;
}

- (void)setCacheProgressColor:(UIColor *)cacheProgressColor {
    _cacheProgressColor = cacheProgressColor;
    _progressView.progressTintColor = cacheProgressColor;
}

#pragma mark - ************************* 滑动条样式设置 *************************

///设置滑动 线条的高度
- (void)setSliderHeight:(CGFloat)sliderHeight {
    _sliderHeight = sliderHeight;
    [_progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerY.equalTo(self);
        make.height.mas_equalTo(sliderHeight);
    }];
    _progressView.layer.cornerRadius = sliderHeight / 2.;
    _progressView.layer.masksToBounds = YES;
}
- (CGRect)trackRectForBounds:(CGRect)bounds {
    if (_sliderHeight > 0) {
        return CGRectMake(0, (bounds.size.height - _sliderHeight)/2. - 0.5, bounds.size.width, _sliderHeight);
    }else{
        return bounds;
    }
}

// 子类重写
/// 设置minimumValueImage的rect
//- (CGRect)minimumValueImageRectForBounds:(CGRect)bounds;

/// 设置maximumValueImage的rect
//- (CGRect)maximumValueImageRectForBounds:(CGRect)bounds;

/// 设置track（滑条）尺寸
//- (CGRect)trackRectForBounds:(CGRect)bounds;

/// 设置thumb（滑块）尺寸
//- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value;

///设置滑块按钮图片
- (void)setTrackNormalImage:(UIImage *)normalImage selectdImage:(UIImage *)selectImage {
    
    if (normalImage) {
        [self setThumbImage:normalImage forState:UIControlStateNormal];
    }
    if (selectImage) {
        [self setThumbImage:selectImage forState:UIControlStateHighlighted];
    }
}


#pragma mark - ************************* 设置线条数据进度 *************************
///设置缓存进度
- (void)setCacheValue:(CGFloat)cacheValue {
    _cacheValue = cacheValue;
    _progressView.progress = cacheValue;
}


///滑动条改变触发
- (void)changeValue {
    NSLog(@"--->%.2f",self.value);
    if (self.delegate) {
        //回调
        [self.delegate sliderValue:self.value];
    }
}

///滑动结束
- (void)endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event {
    NSLog(@"滑动结束");
    if (self.delegate) {
        //回调
        [self.delegate sliderTrackEnd:self.value];
    }
}


///点击滑动条
- (void)onTapSliderGesture {
    
    CGPoint point = [_tapGesture locationInView:self];
    
    self.value = (point.x * 0.1) / (self.frame.size.width * 0.1);
    
    if (self.delegate) {
        //回调
        [self.delegate sliderTrackEnd:self.value];
    }
}


@end
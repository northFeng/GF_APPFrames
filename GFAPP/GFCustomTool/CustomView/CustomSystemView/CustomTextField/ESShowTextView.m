//
//  ESShowTextView.m
//  esReadStudent
//
//  Created by 峰 on 2019/8/26.
//  Copyright © 2019 AK.ios. All rights reserved.
//

#import "ESShowTextView.h"

@interface ESShowTextView () <UITextViewDelegate,UIScrollViewDelegate>

///展示默认颜色的textView
@property (nonatomic,strong) UITextView *normalTextView;

///高亮颜色的textView
@property (nonatomic,strong) UITextView *heightTextView;

///高亮文字的遮罩
@property (nonatomic,strong) CAShapeLayer *heightTextMaskLayer;


@end


@implementation ESShowTextView
{
    BOOL _isTouch;//是否触摸
    BOOL _isBeginTouch;//是否开始触摸
}

#pragma mark - 视图布局
//初始化
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        _isTap = NO;
        _heighColor = [UIColor blueColor];
        _isTouch = NO;
        _isBeginTouch = NO;
        [self createViewWithFrame:frame];
    }
    return self;
}

//创建视图
- (void)createViewWithFrame:(CGRect)frame{
    
    //默认文字
    _normalTextView = [[UITextView alloc] init];
    _normalTextView.backgroundColor = [UIColor clearColor];
    _normalTextView.delegate = self;
    _normalTextView.editable = NO;//禁止编辑
    _normalTextView.selectable = NO;//禁止触摸选择
    _normalTextView.showsVerticalScrollIndicator = NO;
    _normalTextView.textAlignment = NSTextAlignmentCenter;
    _normalTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);//文字内容四边距
    [self addSubview:_normalTextView];
    
    //高亮文字
    _heightTextView = [[UITextView alloc] init];
    _heightTextView.backgroundColor = [UIColor clearColor];
    //_heightTextView.delegate = self;
    _heightTextView.editable = NO;//禁止编辑
    _heightTextView.selectable = NO;//禁止触摸选择
    _heightTextView.userInteractionEnabled = NO;//高亮禁止手势
    _heightTextView.showsVerticalScrollIndicator = NO;
    _heightTextView.textAlignment = NSTextAlignmentCenter;
    _heightTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);//文字内容四边距
    [self addSubview:_heightTextView];
    
    //高亮遮罩
    _heightTextMaskLayer = [CAShapeLayer layer];
    _heightTextMaskLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _heightTextMaskLayer.fillColor = [UIColor whiteColor].CGColor;//遮罩颜色
    _heightTextView.layer.mask = _heightTextMaskLayer;
    
    //约束布局
    _normalTextView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _heightTextView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

///初始化
- (instancetype)init {
    
    if (self = [super init]) {
        
        [self createView];
    }
    return self;
}

///createView  约束布局
- (void)createView {
    
    //默认文字
    _normalTextView = [[UITextView alloc] init];
    _normalTextView.backgroundColor = [UIColor clearColor];
    _normalTextView.delegate = self;
    _normalTextView.editable = NO;//禁止编辑
    _normalTextView.selectable = NO;//禁止触摸选择
    _normalTextView.showsVerticalScrollIndicator = NO;
    _normalTextView.textAlignment = NSTextAlignmentCenter;
    _normalTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);//文字内容四边距
    [self addSubview:_normalTextView];
    
    //高亮文字
    _heightTextView = [[UITextView alloc] init];
    _heightTextView.backgroundColor = [UIColor clearColor];
    //_heightTextView.delegate = self;
    _heightTextView.editable = NO;//禁止编辑
    _heightTextView.selectable = NO;//禁止触摸选择
    _heightTextView.userInteractionEnabled = NO;//高亮禁止手势
    _heightTextView.showsVerticalScrollIndicator = NO;
    _heightTextView.textAlignment = NSTextAlignmentCenter;
    _heightTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);//文字内容四边距
    [self addSubview:_heightTextView];
    
    //高亮遮罩
    _heightTextMaskLayer = [CAShapeLayer layer];
    _heightTextMaskLayer.frame = CGRectMake(0, 0, 100, 100);
    _heightTextMaskLayer.fillColor = [UIColor whiteColor].CGColor;//遮罩颜色
    _heightTextView.layer.mask = _heightTextMaskLayer;
    
    //约束布局
    [_normalTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [_heightTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)setMaskLayerFrame:(CGSize)maskSize{
    _heightTextMaskLayer.frame = CGRectMake(0, 0, maskSize.width, maskSize.height);
}

///文字视图
- (UITextView *)normalTextView{
    return _normalTextView;
}

///滑动代理 ——> 保证默认tv与高亮 在滑动时 保证一致
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //开始拖拽
    _isBeginTouch = YES;
    _isTouch = YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //开始滑动 ——> 让高亮文字 随着 默认文字 滑动
    _heightTextView.contentOffset = CGPointMake(_normalTextView.contentOffset.x, _normalTextView.contentOffset.y);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //结束拖拽
    _isBeginTouch = NO;//结束触摸
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self->_isBeginTouch) {
            self->_isTouch = NO;//真正结束触摸
        }
    });
}

#pragma mark - ************************* 样式设置 *************************
//默认文字
- (void)setNormalText:(NSAttributedString *)normalText{
    _normalTextView.attributedText = normalText;
    _normalText = normalText;
}
//高亮文字
- (void)setHeightText:(NSAttributedString *)heightText{
    _heightTextView.attributedText = heightText;
    _heightText = heightText;
}
//是否可以点击文字
- (void)setIsTap:(BOOL)isTap {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.normalTextView addGestureRecognizer:tap];
    
    _isTap = isTap;
}

#pragma mark - ************************* 点击文字事件 *************************
- (void)tapAction:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self.normalTextView];
    // 获取点击的字母的位置
    NSInteger characterIndex = [self.normalTextView.layoutManager characterIndexForPoint:point inTextContainer:self.normalTextView.textContainer fractionOfDistanceBetweenInsertionPoints:NULL];
    // 获取单词的范围。range 由起始位置和长度构成。
    NSRange range = [self getWordRange:characterIndex];
    //[self highlightStart:range];
    if (range.length != 0 && range.length != INTMAX_MAX) {
        //NSString *str = [self.normalTextView.text substringWithRange:range];
    }else if (range.length == 0){
        //NSString *str=nil;
    }
}

//获取单词的范围
- (NSRange)getWordRange:(NSInteger)characterIndex {
    NSInteger left = characterIndex;
    NSInteger right = characterIndex;
    NSInteger length = 0;
    NSString *string = self.normalTextView.text;
    if (string.length == 0) {
        return NSMakeRange(0, 0);
    }
    // 往左遍历直到空格
    while (left >= 0) {
        NSString *s = [string substringWithRange:NSMakeRange(left, 1)];
        if ([self isLetter:s]) {
            left --;
        } else {
            break;
        }
    }
    // 往右遍历直到空格
    while (right < self.normalTextView.text.length) {
        NSString *s = [string substringWithRange:NSMakeRange(right, 1)];
        if ([self isLetter:s]) {
            right ++;
        } else {
            break;
        }
    }
    if (left == right) {
        return NSMakeRange(0, 0);
    }
    // 此时 left 和 right 都指向空格
    left++;
    right--;
    NSLog(@"letf = %ld, right = %ld",left,right);
    length = right - left + 1;
    NSRange range = NSMakeRange(left, length);
    return range;
}

//判断是否字母
- (BOOL)isLetter:(NSString *)str {
    NSString *match = @"[a-zA-Z\']";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@",match];
    return [predicate evaluateWithObject:str];
}

#pragma mark - 处理高亮显示
- (void)highlightTextRange:(NSRange)range {
    
    //滑动显示将要高亮的文字
    if (!_isTouch) {

        //清楚掉旧的图层
        [[_heightTextMaskLayer sublayers] makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        
        //处理高亮部分
        _normalTextView.selectedRange = range;
        UITextRange *textRange = self.normalTextView.selectedTextRange;
        NSArray *arrays =  [self.normalTextView selectionRectsForRange:textRange];
        CGFloat lineHeight = self.normalTextView.font.lineHeight;
        for (UITextSelectionRect *rect in arrays) {
            //        NSLog(@"rectX is :%f",rect.rect.origin.x);
            //        NSLog(@"rectY is :%f",rect.rect.origin.y);
            //        NSLog(@"rectW is :%f",rect.rect.size.width);
            //        NSLog(@"rectH is :%f",rect.rect.size.height);
            if(rect.containsEnd || rect.containsStart) {
                continue;
            }
            int line = rect.rect.size.height / lineHeight;
            for (int i = 0; i < line; i++)
            {//多行分别做动效
                CGFloat y = rect.rect.origin.y + (rect.rect.size.height/line) * i;
                CGRect layerRect = CGRectMake(rect.rect.origin.x, y, rect.rect.size.width, rect.rect.size.height/line);
                [self addSelectedLayerWithRect:layerRect];
            }
        }
        
        //没有触摸，则自动滑动
        if (range.length + 50 <= _normalTextView.attributedText.length) {
            
            /**
            [_normalTextView scrollRangeToVisible:NSMakeRange(range.length + 30, 9)];
            [_heightTextView scrollRangeToVisible:NSMakeRange(range.length + 30, 9)];
             */
            
            //改为滑动比例来进行滑动
            CGFloat textHeightScale = (range.length + 50)*1. / _normalTextView.attributedText.length;//显示文字比例
            CGFloat viewScale = _normalTextView.frame.size.height * 1. / _normalTextView.contentSize.height;//textView高度 所占比例
            
            CGFloat scorllScale = 0.;
            //计算滑动比例
            if (textHeightScale > viewScale) {
                //文字进度超过 textView高度 时 ——> 开始自动滑动
                scorllScale = textHeightScale - viewScale;
                scorllScale = scorllScale > (1 - viewScale) ? 1 - viewScale : scorllScale;

                self.heightTextView.contentOffset = CGPointMake(0, self.normalTextView.contentSize.height * scorllScale);
                self.normalTextView.contentOffset = CGPointMake(0, self.normalTextView.contentSize.height * scorllScale);
                
                /** 动画滑动 比较顺畅  但 动画 把 滑动手势给屏蔽了
                [UIView animateWithDuration:0.1 animations:^{
                    self.normalTextView.contentOffset = CGPointMake(0, self.normalTextView.contentSize.height * scorllScale);
                    self.heightTextView.contentOffset = CGPointMake(self.normalTextView.contentOffset.x, self.normalTextView.contentOffset.y);
                }];
                 */
            }else{
                if (_normalTextView.contentOffset.y > 0) {
                    //文字进度 在textView高度范围内，手动滑动 ——> 恢复原位
                    [UIView animateWithDuration:0.2 animations:^{
                        self.normalTextView.contentOffset = CGPointMake(0, 0);
                        self.heightTextView.contentOffset = CGPointMake(self.normalTextView.contentOffset.x, self.normalTextView.contentOffset.y);
                    }];
                }
            }
        }
        
    }
}
- (void)addSelectedLayerWithRect:(CGRect)rect {
    
    //添加一个上下的高亮的layer
    //如果是左右的动效的则需要把初始位置和最后的位置取出进行排序后再添加
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = _heightTextMaskLayer.bounds;
    layer.fillColor = _heighColor.CGColor;
    [_heightTextMaskLayer addSublayer:layer];
    
    UIBezierPath *toPath = [UIBezierPath bezierPathWithRect:rect];
    UIBezierPath *fromPath = [UIBezierPath bezierPathWithRect:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 0)];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.fromValue = (__bridge id)fromPath.CGPath;
    pathAnimation.toValue = (__bridge id)toPath.CGPath;
    
    //透明动效
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    //opacityAnimation.duration = 1.0;
    //opacityAnimation.repeatCount = 1;
    opacityAnimation.fromValue = @0.2;
    opacityAnimation.toValue = @1.0;
    //[layer addAnimation:opacityAnimation forKey:@"opacity"];
    
    CAAnimationGroup *group =  [CAAnimationGroup animation];
    group.repeatCount = 1;
    group.duration = 0.01;//动画时间
    [group setAnimations:@[pathAnimation,opacityAnimation]];
    group.removedOnCompletion = NO;
    // 始终保持最新的效果
    group.fillMode = kCAFillModeForwards;
    
    [layer addAnimation:group forKey:nil];
}


///清楚高亮带动画效果
- (void)clearHighlight {
    
    self.normalTextView.selectedRange = NSMakeRange(0, 0);
    //淡出动画
    for (CAShapeLayer *layer in [_heightTextMaskLayer.sublayers copy]) {
        [CATransaction begin];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animation.duration = 0.75;
        animation.fromValue = [NSNumber numberWithFloat:1.0f];
        animation.toValue = [NSNumber numberWithFloat:0.0f];
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeBoth;
        animation.additive = NO;
        [CATransaction setCompletionBlock:^{
            [layer removeAllAnimations];
            [layer removeFromSuperlayer];
        }];
        [layer addAnimation:animation forKey:@"opacityOUT"];
        
        [CATransaction commit];
    }
    [self scrollTextRangeToVisible:NSMakeRange(0, 1)];
}

///清除高亮不带动画
- (void)clearNOAnimationHighlight {
    self.normalTextView.selectedRange = NSMakeRange(0, 0);
    for (CAShapeLayer *layer in [_heightTextMaskLayer.sublayers copy]) {
        [layer removeAllAnimations];
        [layer removeFromSuperlayer];
    }
    [self scrollTextRangeToVisible:NSMakeRange(0, 1)];
}

///文字滑动
- (void)scrollTextRangeToVisible:(NSRange)range {
    /**
    [_normalTextView scrollRangeToVisible:range];
    [_heightTextView scrollRangeToVisible:range];
     */
    
    //改为滑动比例来进行滑动
    CGFloat textHeightScale = (range.location + range.length)*1. / _normalTextView.attributedText.length;//显示文字比例
    CGFloat viewScale = _normalTextView.frame.size.height * 1. / _normalTextView.contentSize.height;//textView高度 所占比例
    
    CGFloat scorllScale = 0.;
    //计算滑动比例
    if (textHeightScale > viewScale) {
        //文字进度超过 textView高度 时 ——> 开始自动滑动
        scorllScale = textHeightScale - viewScale;
        scorllScale = scorllScale > (1 - viewScale) ? 1 - viewScale : scorllScale;
     
        //动画滑动 比较顺畅
        [UIView animateWithDuration:0.2 animations:^{
            self.normalTextView.contentOffset = CGPointMake(0, self.normalTextView.contentSize.height * scorllScale);
            self.heightTextView.contentOffset = CGPointMake(self.normalTextView.contentOffset.x, self.normalTextView.contentOffset.y);
        }];
    }else{
        //文字进度 在textView高度范围内，手动滑动 ——> 恢复原位
        [UIView animateWithDuration:0.2 animations:^{
            self.normalTextView.contentOffset = CGPointMake(0, 0);
            self.heightTextView.contentOffset = CGPointMake(self.normalTextView.contentOffset.x, self.normalTextView.contentOffset.y);
        }];
    }
}


@end

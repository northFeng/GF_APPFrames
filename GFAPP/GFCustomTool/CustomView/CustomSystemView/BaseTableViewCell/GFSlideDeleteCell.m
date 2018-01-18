//
//  GFSlideDeleteCell.m
//  GFAPP
//
//  Created by XinKun on 2018/1/9.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "GFSlideDeleteCell.h"

///使用滑动删除的tableView上下滑动通知
NSNotificationName const GFTableViewSlideNotice = @"GFTableViewSlideNotice";

#pragma mark - 全局的临时变量
///cell的位置IndexPath
NSIndexPath *TemporaryIndexPath;
///滑动删除滑动的最大宽度
CGFloat TemporarySwipeMaxWidth;

@interface GFSlideDeleteCell ()

@end

@implementation GFSlideDeleteCell

{
    CGPoint _point;//一个坐标
    
    BOOL _isOrSwipe;//是否滑开
    BOOL _isOrTouch;//是否触摸
    
    //cell的宽高
    CGFloat _cellWidth;
    CGFloat _cellHeight;
    
}

- (void)dealloc{
    //移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self createBaseContentView];
}

- (instancetype)init{
    if ([super init]) {
        [self createBaseContentView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self createBaseContentView];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createBaseContentView];
    }
    return self;
}

#pragma mark - 初始化基本内容视图
///初始化基本内容视图
- (void)createBaseContentView{
    
    //初始化数据
    _isOrSwipe = NO;//未滑动
    _isOrTouch = NO;//未触摸
    _cellWidth = 0.;
    _cellHeight = 0.;
    [self setCanSlide:YES];
    
    if (_cellScroller == nil) {
        _cellScroller = [[UIView alloc] init];
        _cellScroller.backgroundColor = [UIColor whiteColor];
        _cellScroller.clipsToBounds = YES;
        
        //设置约束
        _cellScroller.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:_cellScroller attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:_cellScroller attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:_cellScroller attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:_cellScroller attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        [self addSubview:_cellScroller];
        [self addConstraints:@[topConstraint,leftConstraint,bottomConstraint,rightConstraint]];
        
        //注册通知
        //tableView滑动的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCellScrollerViewToOriginal) name:GFTableViewSlideNotice object:nil];
        //cell内部的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCellScrollerViewToOriginalCell:) name:@"GFTableViewSlideNoticeCell" object:nil];
        
    }
}

///重写该属性
- (void)setCanSlide:(BOOL)canSlide{
    _canSlide = canSlide;
}


#pragma mark - 滑动触发 && 创建按钮
///滑动触发 && 创建滑动按钮
- (void)swipeShowActionButtonWillBeginDragging{
    //NSLog(@"开始滑动");
    //设置一个全局变量
    TemporaryIndexPath = self.cellIndexPath;
    TemporarySwipeMaxWidth = 0.;//滑动归零
    
    //获取滑动删除的按钮数组
    NSArray *arrayButton;
    //判断是否实现代理方法
    if ([self.delegate respondsToSelector:@selector(gfSlideDeleteCell:trailingSwipeActionsConfigurationForRowAtIndexPath:)]) {
        arrayButton = [self.delegate gfSlideDeleteCell:self trailingSwipeActionsConfigurationForRowAtIndexPath:self.cellIndexPath];
    }
    //赋值是否可滑动
    if (arrayButton.count > 0) {
        [self setCanSlide:YES];
    }else{
        [self setCanSlide:NO];
    }
    
    for (int i = 0; i < arrayButton.count; i++) {
        
        GFSwipeActionBtn *btnAction = arrayButton[i];
        
        [self.contentView addSubview:btnAction];
        
        //设置约束
        if (i == 0) {
            btnAction.frame = CGRectMake(_cellWidth - btnAction.actionWidth, 0, btnAction.actionWidth, _cellHeight);
        }else{
            GFSwipeActionBtn *supBtnAction = arrayButton[i - 1];
            btnAction.frame = CGRectMake(_cellWidth - (btnAction.actionWidth + supBtnAction.actionWidth), 0, btnAction.actionWidth, _cellHeight);
        }
        //设置自动布局（视图的左边距是变化的）
        btnAction.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
        //把图层设置最后
        [self.contentView sendSubviewToBack:btnAction];
        
        self.contentView.clipsToBounds = YES;
        self.clipsToBounds = YES;
        
        //累加滑动最大宽度
        TemporarySwipeMaxWidth += btnAction.actionWidth;
        
        if (i>=3) {
            //暂时设置不能超过三个按钮
            break;
        }
    }
}


#pragma mark - 滑动监测
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (!self.canSlide) {
        return ;
    }
    //通知其他已打开的cell，回归原来
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GFTableViewSlideNoticeCell" object:_cellIndexPath];
    
    //一滑动就设置数据
    _isOrTouch = YES;
    _cellWidth = self.frame.size.width;
    _cellHeight = self.frame.size.height;
    
    if (_cellScroller.frame.origin.x < 0) {
        _isOrSwipe = YES;
        //已滑动打开，就恢复原样
        [self setContentOffsetZero];
    }else{
        _point = [[touches anyObject] locationInView:self];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (_isOrSwipe) {
        //已打开
        return ;
    }else{
        //未打开
        CGPoint pointTwo = [[touches anyObject] locationInView:self];
        
        if (_cellScroller.frame.origin.x+(pointTwo.x - _point.x) <= 0) {
            
            if (_cellScroller.frame.origin.x == 0) {
                //先移除旧的按钮
                NSArray *arrayBtn = self.contentView.subviews;
                for (UIView *obj in arrayBtn) {
                    if ([obj isKindOfClass:[GFSwipeActionBtn class]]) {
                        [obj removeFromSuperview];
                    }
                }
                NSLog(@"创建按钮");
                //创建新的滑动按钮
                [self swipeShowActionButtonWillBeginDragging];
            }
            
            if (!self.canSlide) {
                
                return ;
            }
            //判断滑动最大宽度
            _cellScroller.frame = CGRectMake( _cellScroller.frame.origin.x+(pointTwo.x - _point.x), 0, _cellWidth, _cellHeight);
        }
        //赋值新的位置
        _point = pointTwo;
    }
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //NSLog(@"触摸结束");
    [self setContentViewOffset];
    _isOrSwipe = NO;
    _isOrTouch = NO;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //NSLog(@"触摸取消");
    [self setContentViewOffset];
    _isOrSwipe = NO;
    _isOrTouch = NO;
}

///设置frame动态变化
- (void)setContentViewOffset{
    
    if (!self.canSlide) {
        return ;
    }
    
    //判断滑动是否超过 滑动宽度一半
    if (_cellScroller.frame.origin.x > -(TemporarySwipeMaxWidth/2.)) {
        //未打开
        [UIView animateWithDuration:0.2 animations:^{
            _cellScroller.frame = CGRectMake( 0, 0, _cellWidth, _cellHeight);
        }];
    }else if (_cellScroller.frame.origin.x <= -(TemporarySwipeMaxWidth/2.)){
        //滑动已打开
        [UIView animateWithDuration:0.2 animations:^{
            _cellScroller.frame = CGRectMake( -TemporarySwipeMaxWidth, 0, _cellWidth, _cellHeight);
        }];
    }
}


#pragma mark - 回归原样
///设置frame归零
- (void)setContentOffsetZero{
    
    [UIView animateWithDuration:0.1 animations:^{
        _cellScroller.frame = CGRectMake( 0, 0, _cellWidth, _cellHeight);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 接受通知处理
///当tableView上下滑动时，cellScrollView要回归
- (void)setCellScrollerViewToOriginal{
    
    if (!_isOrTouch) {
        //没有触摸
        //已打开
        [UIView animateWithDuration:0.1 animations:^{
            _cellScroller.frame = CGRectMake( 0, 0, self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished) {
            
            //先移除旧的按钮
            NSArray *arrayBtn = self.contentView.subviews;
            for (UIView *obj in arrayBtn) {
                if ([obj isKindOfClass:[GFSwipeActionBtn class]]) {
                    [obj removeFromSuperview];
                }
            }
            
            [self setCanSlide:YES];
        }];
    }
}

///当cell被触摸时，cellScrollView要回归(通知其他的cell）
- (void)setCellScrollerViewToOriginalCell:(NSNotification *)noti{
    
    NSIndexPath *notiIndexPath = (NSIndexPath *)noti.object;
    if (notiIndexPath.section == _cellIndexPath.section && notiIndexPath.row == _cellIndexPath.row) {
        //是自己跳过
        return ;
    }else{
        [UIView animateWithDuration:0.1 animations:^{
            _cellScroller.frame = CGRectMake( 0, 0, self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished) {
            
            //先移除旧的按钮
            NSArray *arrayBtn = self.contentView.subviews;
            for (UIView *obj in arrayBtn) {
                if ([obj isKindOfClass:[GFSwipeActionBtn class]]) {
                    [obj removeFromSuperview];
                }
            }
            
            [self setCanSlide:YES];
        }];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end




//**********************************************
//************* 自定义滑动删除按钮 **************
//**********************************************
#pragma mark - 自定义滑动删除按钮
@interface GFSwipeActionBtn ()

///block
@property (nonatomic,copy) GFSlideDeleteBlock blockSlide;

@end

@implementation GFSwipeActionBtn

+ (GFSwipeActionBtn *)rowActionWithStyle:(GFSwipeActionStyle)actionStyle title:(NSString *)title image:(UIImage *)image actionWidth:(CGFloat)actionWidth backgroundColor:(UIColor *)bgColor handler:(GFSlideDeleteBlock)handler{
    
    GFSwipeActionBtn *swipeActionBtn = [GFSwipeActionBtn buttonWithType:UIButtonTypeCustom];
    
    switch (actionStyle) {
        case GFSwipeActionStyleDefaule:
            [swipeActionBtn setTitle:title forState:UIControlStateNormal];
            break;
        case GFSwipeActionStyleImage:
            [swipeActionBtn setImage:image forState:UIControlStateNormal];
            break;
        case GFSwipeActionStyleCustom:
            
            break;
        default:
            break;
    }
    if (actionWidth <=0) {
        //默认的八十
        [swipeActionBtn setActionWidth:80];
    }else{
        [swipeActionBtn setActionWidth:actionWidth];
    }
    swipeActionBtn.blockSlide = handler;
    
    [swipeActionBtn addTarget:swipeActionBtn action:@selector(performButtonHandle) forControlEvents:UIControlEventTouchUpInside];
    
    return swipeActionBtn;
}

- (void)setActionWidth:(CGFloat)actionWidth{
    _actionWidth = actionWidth;
}

///按钮的点击事件
- (void)performButtonHandle{
    //NSLog(@"点击了滑动按钮");
    [[NSNotificationCenter defaultCenter] postNotificationName:GFTableViewSlideNotice object:nil];
    if (self.blockSlide) {
        self.blockSlide(TemporaryIndexPath);
    }
}

@end





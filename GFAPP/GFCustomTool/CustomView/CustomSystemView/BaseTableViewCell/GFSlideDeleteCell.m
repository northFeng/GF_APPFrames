//
//  GFSlideDeleteCell.m
//  GFAPP
//
//  Created by XinKun on 2018/1/9.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "GFSlideDeleteCell.h"

///全局的临时变量
NSIndexPath *TemporaryIndexPath;

@interface GFSlideDeleteCell ()

@end

@implementation GFSlideDeleteCell

{
    GFCellScroller *_cellScroller;//cell上自定义UIScrollerView
    
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

    _cellScroller = [[GFCellScroller alloc] init];
    _cellScroller.backgroundColor = [UIColor clearColor];
    __weak typeof(self) weakSelf = self;
    _cellScroller.blockTouch = ^{
        [weakSelf swipeShowActionButtonWillBeginDragging];
    };
    [self.contentView addSubview:_cellScroller];
    [_cellScroller mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

///将要滑动
- (void)swipeShowActionButtonWillBeginDragging{
    //NSLog(@"开始滑动");
    //设置一个全局变量
    TemporaryIndexPath = self.cellIndexPath;
    
    NSArray *arrayButton = [self.delegate gfSlideDeleteCell:self trailingSwipeActionsConfigurationForRowAtIndexPath:self.cellIndexPath];
    
    for (GFSwipeActionBtn *btnAction in arrayButton) {
        
        [_cellScroller addSubview:btnAction];
        
        [btnAction mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.height.mas_equalTo(_cellScroller.frame.size.height);
            make.width.mas_equalTo(100);
        }];
        
        [_cellScroller sendSubviewToBack:btnAction];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end


#pragma mark - 自定义ScrollerView
@implementation GFCellScroller
{
    UIView *_contentView;//内容填充视图
    
    CGPoint _point;//一个坐标
    
}

- (instancetype)init{
    if ([super init]) {
        [self createBaseView];
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self createBaseView];
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.clipsToBounds = YES;
    }
    return self;
}

#pragma mark - 创建基本视图架构
- (void)createBaseView{
    
    if (_contentView == nil) {
        //填充的内容视图
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor greenColor];
        [self addSubview:_contentView];
        _contentView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT);
        
        
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor grayColor];
        label.text = @"哈哈哈发送积分抵萨芬的";
        label.font = [UIFont systemFontOfSize:20];
        [_contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.and.right.equalTo(_contentView);
            make.height.mas_equalTo(50);
        }];
        
        
    }else{
        return ;
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_contentView.frame.origin.x < 0) {
        [self setContentOffsetZero];
    }else{
        _point = [[touches anyObject] locationInView:self];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGPoint pointTwo = [[touches anyObject] locationInView:self];
    
    if (_contentView.frame.origin.x+(pointTwo.x - _point.x) <= 0) {
        
        if (_contentView.frame.origin.x == 0) {
            //先移除旧的按钮
            NSArray *arrayBtn = self.subviews;
            for (UIView *obj in arrayBtn) {
                if ([obj isKindOfClass:[GFSwipeActionBtn class]]) {
                    [obj removeFromSuperview];
                }
            }
            
            //创建按钮
            if (self.blockTouch) {
                self.blockTouch();
            }
        }
        
        _contentView.frame = CGRectMake( _contentView.frame.origin.x+(pointTwo.x - _point.x), 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT);
    }
    //赋值新的位置
    _point = pointTwo;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //NSLog(@"触摸结束");
    [self setContentViewOffset];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //NSLog(@"触摸取消");
    [self setContentViewOffset];
}

///设置frame动态变化
- (void)setContentViewOffset{
    
    if (_contentView.frame.origin.x > -100) {
        [UIView animateWithDuration:0.2 animations:^{
            _contentView.frame = CGRectMake( 0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT);
        }];
    }else if (_contentView.frame.origin.x < -100){
        [UIView animateWithDuration:0.2 animations:^{
            _contentView.frame = CGRectMake( -200, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT);
        }];
    }
}

///设置frame归零
- (void)setContentOffsetZero{
    
    [UIView animateWithDuration:0.1 animations:^{
        _contentView.frame = CGRectMake( 0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT);
    }];
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

+ (GFSwipeActionBtn *)rowActionWithStyle:(GFSwipeActionStyle)actionStyle title:(NSString *)title image:(UIImage *)image handler:(GFSlideDeleteBlock)handler{
    
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
    
    swipeActionBtn.blockSlide = handler;
    
    [swipeActionBtn addTarget:swipeActionBtn action:@selector(performButtonHandle) forControlEvents:UIControlEventTouchUpInside];
    return swipeActionBtn;
}

///按钮的点击事件
- (void)performButtonHandle{
    NSLog(@"点击了滑动按钮");

    if (self.blockSlide) {
        self.blockSlide(TemporaryIndexPath);
    }
}





@end





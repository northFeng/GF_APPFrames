//
//  GFCaseSearchBar.m
//  Lawpress
//
//  Created by XinKun on 2017/8/24.
//  Copyright © 2017年 彬万. All rights reserved.
//

#import "GFCaseSearchBar.h"

@implementation GFCaseSearchBar

{
    //放大镜图片
    UIImageView *_imageViewSearch;
    
    //案例按钮
    UIButton *_btnCase;
    
    //法规按钮
    UIButton *_btnLaw;
    
    CGFloat _btnCenterY;
    
    NSString *_caseTotal;
    
    NSString *_lawTotal;
    
    NSInteger _type;

}


- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        [self createView];
    }
    return self;
}


///创建视图
- (void)createView{
    
    //放大镜 图片
    UIImage *searchIcon = [UIImage imageNamed:@"ic_search_search"];
    _imageViewSearch = [[UIImageView alloc] init];
    _imageViewSearch.image = searchIcon;
    _imageViewSearch.userInteractionEnabled = NO;
    [self addSubview:_imageViewSearch];
    
    //搜索输入框
    _labelSearch = [[UILabel alloc] init];
    _labelSearch.backgroundColor = [UIColor clearColor];
    _labelSearch.textColor = UIColorFromRGB(186, 186, 192);
    _labelSearch.font = [UIFont systemFontOfSize:14];
    _labelSearch.text = @"已收录案例0篇";
    [self addSubview:_labelSearch];
    _labelSearch.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
    singleTap.numberOfTouchesRequired = 1; //单击
    [_labelSearch addGestureRecognizer:singleTap];
    
    //建立约束
    [_imageViewSearch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-(16 - searchIcon.size.height/2.));
        make.width.and.height.mas_equalTo(searchIcon.size.height);
    }];
    
    [_labelSearch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageViewSearch.mas_right).offset(12);
        make.centerY.equalTo(_imageViewSearch);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(32.);
    }];
    
    //按钮
    NSArray *arrayTitle = @[@"法规",@"案例"];
    for (int i=0; i<arrayTitle.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 0) {
            //法规
            _btnLaw = btn;
        }else{
            //案例
            _btnCase = btn;
        }
        btn.tag = 100000 + i;
        [btn setTitle:arrayTitle[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //[btn setTitleColor:APP_Text_Color_Select forState:UIControlStateSelected];
        [self addSubview:btn];
        
        [btn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [_btnLaw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).offset(10);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(35);
    }];
    
    [_btnCase mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_btnLaw.mas_right).offset(30);
        make.top.equalTo(self).offset(10);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(35);
    }];
    
    
    //案例按钮的中心点
    _btnCenterY = 35/2.;
    _btnCase.selected = NO;
    _btnLaw.selected = YES;
    //_type = XK_ITEM_CASE;
    
}


///绘制
- (void)drawRect:(CGRect)rect{
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 42, 300 - 30, 32) cornerRadius:1];
    
    [path moveToPoint:CGPointMake(_btnCenterY-6, 42)];
    [path addLineToPoint:CGPointMake(_btnCenterY, 34)];
    [path addLineToPoint:CGPointMake(_btnCenterY+6, 42)];
    //[path closePath];
    
    //设置填充色
    UIColor *colorGround = UIColorFromSameRGB(238);
    [colorGround set];
    [path fill];//fill填充 路径内的渲染颜色
    
    //划线,让线显示到图层
    [path stroke];
    
}

#pragma mark - 业务逻辑 处理

///案例和法规 按钮 点击事件
- (void)onClickBtn:(UIButton *)button{
    
    NSInteger tag = button.tag - 100000;
    
    _btnCenterY = button.center.x;
    
    if (tag == 0) {
        //法规
        _btnCase.selected = NO;
        _btnLaw.selected = YES;
        //_type = XK_ITEM_FAGUI;
    }else{
        //案例
        _btnCase.selected = YES;
        _btnLaw.selected = NO;
        //_type = XK_ITEM_CASE;
    }
    
    [self setNeedsDisplay];
    
    [self setCaseTotal:_caseTotal lawTotal:_lawTotal];
    
    //刷新外部cell
    if (self.blockRefreshCell) {
        self.blockRefreshCell(_type);
    }
    
}

///label点击事件
- (void)singleTapAction{
    
    if (self.blockGotoSearch) {
        self.blockGotoSearch();
    }
    
}

///赋值案例和法规条数
- (void)setCaseTotal:(NSString *)caseTotal lawTotal:(NSString *)lawTotal{

    _caseTotal = caseTotal;
    
    _lawTotal = lawTotal;
    
    if (_btnCase.selected) {
        //案例
        _labelSearch.text = [NSString stringWithFormat:@"已收录案例%@篇",_caseTotal];
    }else if (_btnLaw.selected){
        //法规
        _labelSearch.text = [NSString stringWithFormat:@"已收录法规%@篇",_lawTotal];
    }

}








@end

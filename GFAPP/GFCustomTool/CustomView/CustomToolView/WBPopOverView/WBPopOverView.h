//
//  WBPopOverView.h
//  Lawpress
//  cell带箭头的弹出特效选择框
//  Created by 彬万 on 16/7/26.
//  Copyright © 2016年 彬万. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

typedef NS_ENUM(NSUInteger,WBArrowDirection){

    //箭头位置
    
    WBArrowDirectionLeft1=1,//左上
    WBArrowDirectionLeft2,//左中
    WBArrowDirectionLeft3,//左下
    WBArrowDirectionRight1,//右上
    WBArrowDirectionRight2,//右中
    WBArrowDirectionRight3,//右下
    WBArrowDirectionUp1,//上左
    WBArrowDirectionUp2,//上中
    WBArrowDirectionUp3,//上右
    WBArrowDirectionDown1,//下左
    WBArrowDirectionDown2,//下中
    WBArrowDirectionDown3,//下右

};

@interface WBPopOverView : UIView
@property (nonatomic, strong) UIView *backView;

-(instancetype)initWithOrigin:(CGPoint)origin Width:(CGFloat)width Height:(float)height Direction:(WBArrowDirection)direction;//初始化

-(void)popView;//弹出视图
-(void)dismiss;//隐藏视图

@end



/**  用法
 
//获取moreButton所在cell的rect值   （计算点击位置）
CGRect rectInTableView = [self.ZLDetailTableview rectForRowAtIndexPath:indexPath];
CGRect rect = [self.ZLDetailTableview convertRect:rectInTableView toView:[self.ZLDetailTableview superview]];

 //计算小箭头 顶尖的位置point
CGPoint point=CGPointMake(btn.frame.origin.x - 15, rect.origin.y+btn.frame.origin.y + btn.frame.size.height / 2.);//计算箭头点的位置
 
 //创建弹框示例
_popOverView=[[WBPopOverView alloc]initWithOrigin:point Width:130 Height:50 Direction:WBArrowDirectionRight2];

NSArray *fmPopIconNameArr = @[@"ic_collect_edit",@"ic_collect_del"];
for (int i = 0; i < 2; i++) {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (i==1) {
        btn.frame = CGRectMake( 30, 15, 20, 20);
    }else{
        btn.frame = CGRectMake( 81.5, 15, 20, 20);
    }
    btn.tag = 9000 + i;
    btn.backgroundColor = [UIColor clearColor];
    [btn setImage:[UIImage imageNamed:[fmPopIconNameArr objectAtIndex:i]] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(fmPopIconBtnClick:) forControlEvents:UIControlEventTouchUpInside];
 
    //往上添加控件
    [_popOverView.backView addSubview:btn];
    
}
 
 //弹出弹框
[_popOverView popView];

 */









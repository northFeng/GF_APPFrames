//
//  GFAttributedStringView.h
//  富文本触摸事件
//
//  Created by XinKun on 2017/4/16.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GFAttributedStringView : UIView


///触摸文字的回调
@property (nonatomic,copy) void(^touchStringBlock)();


/**
 * 设置显示文字 和 触摸文字
 *
 * 参数1：showString 展示文字
 *
 * 参数2：touchString 触摸文字
 *
 * 参数3：font 显示文字大小
 */
- (void)setShowString:(NSString *)showString andTouchString:(NSString *)touchString andTextFont:(NSInteger)font;


@end

/** 用法
GFAttributedStringView *stringView = [[GFAttributedStringView alloc] initWithFrame:CGRectMake(10, 100, 300, 100)];
stringView.backgroundColor = [UIColor greenColor];
[stringView setShowString:@"你好世界，世界那么大，我想出去走走,防护撒谎粉红色大反倒是俯拾地芥of打死哦啊发的搜免费的撒" andTouchString:@"防护撒谎粉红色" andTextFont:15];
__weak typeof(self) weakSelf = self;
stringView.touchStringBlock = ^{ [weakSelf touchTextAction]; };
[self.view addSubview:stringView];
 
 */

//
//  FSPromptView.h
//  FlashSend
//  提示图
//  Created by gaoyafeng on 2018/9/7.
//  Copyright © 2018年 ishansong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSPromptView : UIView


///显示默认的无网提示图
- (void)showDefaultPromptViewForNoNet;

/**
 *  设置提示页面元素内容
 *
 *  @param promptImageName 提示图片名称
 *  @param promptText      提示文字
 */
- (void)showPromptImageName:(NSString *)promptImageName promptText:(NSString *)promptText;


///自定义显示内容
- (void)addCoustomBackView:(UIView *)newBackView;



@end

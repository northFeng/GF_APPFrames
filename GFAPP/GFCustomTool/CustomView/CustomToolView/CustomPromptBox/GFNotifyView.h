//
//  GFNotifyView.h
//  GFAPP
//  提示图
//  Created by XinKun on 2017/11/17.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GFNotifyView : UIView


///显示默认的无网提示图
- (void)showDefaultPromptViewForNoNet;


///显示默认的空内容提示图
- (void)showDefaultPromptViewForNoContent;


/**
 *  设置提示页面元素内容
 *
 *  @param promptImageName 提示图片名称
 *  @param promptText      提示文字
 *  @param suggestText     建议文字
 */
- (void)setPromptImageName:(NSString *)promptImageName promptText:(NSString *)promptText suggestText:(NSString *)suggestText;

//自定义一个UIAlertController

@end

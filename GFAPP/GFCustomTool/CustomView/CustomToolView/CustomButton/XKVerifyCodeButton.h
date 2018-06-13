//
//  XKVerifyCodeButton.h
//  Lawpress
//  短信验证按钮
//  Created by 彬万 on 16/10/24.
//  Copyright © 2016年 彬万. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKVerifyCodeButton : UIButton

/**
 *  倒计时次数
 *
 *  @param timeCount 倒计时时间次数
 */
- (void)timeFailBeginFrom:(NSInteger)timeCount;

@end

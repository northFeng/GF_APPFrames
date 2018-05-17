//
//  GFGIFImageView.h
//  GFAPP
//  GIF显示控件
//  Created by gaoyafeng on 2018/5/17.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GFGIFImageView : UIImageView

/** 动画持续时间 */
@property (nonatomic,assign,readonly) CGFloat animationTime;

/** gif图片解析图片数组 */
@property (nonatomic,strong,readonly) NSArray *gifImgArray;

/** gif图片名字 */
@property (nonatomic,copy,readonly) NSString *gifName;


///设置gif图片动画
- (void)setGifImageWithGifName:(NSString *)gifName;


@end

//
//  GFTakePhotoTool.h
//  GFAPP
//  获取系统图片
//  Created by 峰 on 2019/8/16.
//  Copyright © 2019 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GFTakePhotoTool : NSObject

- (void)showCamera:(UIViewController *)vc;

- (void)showLibrary:(UIViewController *)vc;

/**
 图片输出信号
 */
@property (nonatomic,copy) APPBackBlock block;

@end


#pragma mark - 裁剪图片
@interface GFClipController : UIViewController

/**
 图片
 */
@property (nonatomic, strong) UIImage *image;

/**
 图片输出信号
 */
@property (nonatomic,copy) APPBackBlock block;

@end

NS_ASSUME_NONNULL_END

//
//  GFCollectViewVC.h
//  GFAPP
//  UICollectionView用法
//  Created by 峰 on 2019/8/4.
//  Copyright © 2019 North_feng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GFCollectViewVC : UIViewController

@end


@interface GFCollectionViewFlowLayout : UICollectionViewFlowLayout


@property(nonatomic,assign)int itemCount;

@end


//collection的headCell
//@interface CBHomeHeadCellView : UICollectionReusableView

/**
 //初始化
 - (instancetype)initWithFrame:(CGRect)frame{
     
     if (self = [super initWithFrame:frame]) {
         [self createView];
     }
     return self;
 }


 //创建视图
 - (void)createView {
     
 }
 */

//@end

//@interface CBHomeBannerCell : UICollectionViewCell

/**
 #pragma mark - 视图布局
 //初始化
 - (instancetype)initWithFrame:(CGRect)frame{
     
     if (self = [super initWithFrame:frame]) {
         
         self.contentView.backgroundColor = [UIColor clearColor];
         [self createView];
     }
     return self;
 }


 //创建视图
 - (void)createView {
     
 }
 */

//@end


NS_ASSUME_NONNULL_END

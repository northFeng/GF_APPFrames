//
//  APPBaseCell.h
//  FlashRider
//
//  Created by gaoyafeng on 2018/11/22.
//  Copyright © 2018 ishansong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPBaseCell : UITableViewCell

///左边图片
@property (nonatomic,strong,nullable) UIImageView *imgLeft;

///左边label
@property (nonatomic,strong,nullable) UILabel *labelLeft;

///右边图片
@property (nonatomic,strong,nullable) UIImageView *imgRight;

///右边label
@property (nonatomic,strong,nullable) UILabel *labelRight;

///分割线
@property (nonatomic,strong,nullable) UIView *lineBottom;







@end

NS_ASSUME_NONNULL_END

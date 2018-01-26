//
//  XKFoundTableViewCell.h
//  Lawpress
//  普通cell
//  Created by XinKun on 2017/3/23.
//  Copyright © 2017年 彬万. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GFBaseTableViewCell : UITableViewCell


///cell数据model
@property (nonatomic,copy) id cellModel;

///赋值
- (void)setCellData:(id)cellData;


///改变cell的样式
- (void)changCellSubViews;

@end

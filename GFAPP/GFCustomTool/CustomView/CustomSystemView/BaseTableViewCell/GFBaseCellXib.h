//
//  GFBaseCellXib.h
//  GFAPP
//
//  Created by gaoyafeng on 2018/9/15.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "APPBaseModel.h"

@interface GFBaseCellXib : UITableViewCell


///model
@property (nonatomic, copy) APPBaseModel *announcementModel;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end




/**
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnnouncementCell *cell = [AnnouncementCell cellWithTableView:tableView];
    if (indexPath.row < _dataArr.count) {
 
        //注意！这里必须用点语法进行赋值model
        cell.announcementModel = _dataArr[indexPath.row];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnnouncementModel *model = _dataArr[indexPath.row];
 
    //自动计算cell高度
 
    //keyPath 直接填cell中model属性名字即可
    return [_tableview cellHeightForIndexPath:indexPath model:model keyPath:@"announcementModel" cellClass:[AnnouncementCell class] contentViewWidth:KScreenWidth];
}
 */

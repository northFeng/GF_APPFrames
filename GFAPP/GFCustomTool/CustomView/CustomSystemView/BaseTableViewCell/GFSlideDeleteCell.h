//
//  GFSlideDeleteCell.h
//  GFAPP
//  自定义滑动删除cell
//  Created by XinKun on 2018/1/9.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GFSlideDeleteCell;
//**********************************************
//************* 自定义cell代理 ******************
//**********************************************
#pragma mark - 自定义cell代理
@protocol GFSlideDeleteCellDelegate <NSObject>

///设置滑动显示按钮
- (NSArray *)gfSlideDeleteCell:(GFSlideDeleteCell *)slideDeleteCell trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath;



@end

//**********************************************
//************* 自定义滑动删除cell ***************
//**********************************************
#pragma mark - 自定义滑动删除cell
@interface GFSlideDeleteCell : UITableViewCell

///cell在tableView中的位置
@property (nonatomic,strong) NSIndexPath *cellIndexPath;

///代理
@property (nonatomic,weak) id <GFSlideDeleteCellDelegate>delegate;



@end


//**********************************************
//************* 自定义ScrollerView **************
//**********************************************
#pragma mark - 自定义ScrollerView
@interface  GFCellScroller: UIScrollView

///block
@property (nonatomic,copy) void(^blockTouch)();


@end


//**********************************************
//************* 自定义滑动删除按钮 **************
//**********************************************

/**
 *  用户性别
 */
typedef NS_ENUM(NSInteger,GFSwipeActionStyle) {
    /**
     *  默认(有背景颜色，只显示文字)
     */
    GFSwipeActionStyleDefaule = 0,
    /**
     *  只显示图片(有背景颜色)
     */
    GFSwipeActionStyleImage,
    /**
     *  自定义(自己往按钮上添加视图)
     */
    GFSwipeActionStyleCustom,
};

///临时用的block函数
typedef void(^GFSlideDeleteBlock)(NSIndexPath *indexPath);

@interface  GFSwipeActionBtn: UIButton

+ (GFSwipeActionBtn *)rowActionWithStyle:(GFSwipeActionStyle)actionStyle title:(NSString *)title image:(UIImage *)image handler:(GFSlideDeleteBlock)handler;


@end
















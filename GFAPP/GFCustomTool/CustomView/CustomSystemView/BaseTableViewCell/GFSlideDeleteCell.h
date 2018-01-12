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

///使用滑动删除的tableView上下滑动通知
UIKIT_EXTERN NSNotificationName const GFTableViewSlideNotice;

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

/**
 *  @brief 自定义cell上的内容视图(所有的显示视图UIView都必须添加到这个属性上)
 *
 *  @describe  所有的显示视图UIView都必须添加到这个属性上,默认背景颜色为白色，可修改该属性进行设置其背景颜色
 *  @describe  cell.backgroundColor 这个属性的设置为内容视图的底部颜色的设置，即 为 滑动按钮所在图层的背景颜色设置
 */
@property (nonatomic,strong) UIView *cellScroller;

///cell在tableView中的位置
@property (nonatomic,strong) NSIndexPath *cellIndexPath;

///是否可滑动
@property (nonatomic,assign,readonly) BOOL canSlide;

///代理
@property (nonatomic,weak) id <GFSlideDeleteCellDelegate>delegate;



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

///滑动的宽度
@property (nonatomic,assign,readonly) CGFloat actionWidth;


/**
 *  @brief 创建滑动删除按钮
 *
 *  @param actionStyle 按钮类型
 *  @param title 按钮上的文字（默认文字颜色：白色，可按照UIButton系统API修改文字颜色即可）
 *  @param image 按钮图片
 *  @param actionWidth 按钮的宽度（必须设置！！！）
 *  @param bgColor 按钮背景颜色（也可以通过UIButton系统API来修改背景颜色）
 *  @return GFSwipeActionBtn类型的按钮
 */
+ (GFSwipeActionBtn *)rowActionWithStyle:(GFSwipeActionStyle)actionStyle title:(NSString *)title image:(UIImage *)image actionWidth:(CGFloat)actionWidth backgroundColor:(UIColor *)bgColor handler:(GFSlideDeleteBlock)handler;



@end


#pragma mark - 实现步骤
/**
//实现步骤

//一：创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    //必须添加自定义cell的代理
    ((GFSlideDeleteCell *)cell).delegate = self;
    //必须给cell赋值cell的位置 indexPath
    ((GFSlideDeleteCell *)cell).cellIndexPath = indexPath;
    
    cell.backgroundColor = [UIColor redColor];
    
    return cell;
}

//二：要想添加滑动按钮，必须实现此代理方法
#pragma mark - 自定义代理设置滑动删除按钮
- (NSArray *)gfSlideDeleteCell:(GFSlideDeleteCell *)slideDeleteCell trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GFSwipeActionBtn *btn = [GFSwipeActionBtn rowActionWithStyle:GFSwipeActionStyleDefaule title:@"删除" image:nil actionWidth:80 backgroundColor:nil handler:^(NSIndexPath *indexPath) {
        NSLog(@"这是第一个按钮------>这是第：%ld个",indexPath.section);
    }];
    [btn setTitleColor:[UIColor redColor] forState:0];
    btn.backgroundColor = [UIColor lightGrayColor];
    
    GFSwipeActionBtn *btnTwo = [GFSwipeActionBtn rowActionWithStyle:GFSwipeActionStyleDefaule title:@"添加" image:nil actionWidth:100 backgroundColor:nil handler:^(NSIndexPath *indexPath) {
        NSLog(@"这是第二个按钮------>这是第：%ld个",indexPath.section);
    }];
    [btnTwo setTitleColor:[UIColor blueColor] forState:0];
    btnTwo.backgroundColor = [UIColor magentaColor];
    
    return @[btn,btnTwo];
}

//三：必须监听这个代理
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GFTableViewSlideNotice object:nil];
    
}
 
 */



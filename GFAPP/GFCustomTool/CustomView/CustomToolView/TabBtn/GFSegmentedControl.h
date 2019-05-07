//
//  GFSegmentedControl.h
//  GFAPP
//  自定义UISegmentControl组件
//  Created by gaoyafeng on 2019/5/7.
//  Copyright © 2019 North_feng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

///选中按钮回调代理
@protocol FSSegmentControlDelegate <NSObject>

- (void)segmentControlDidChangeValue:(NSInteger)index;

@end

@interface GFSegmentedControl : UIView

///代理
@property (nonatomic,weak,nullable) id <FSSegmentControlDelegate> delegate;

///控制 分割线 && 按钮背景 & 边框 颜色
@property (nonatomic,strong,nullable) UIColor *tintColor;

///选中位置(默认选第一个)
@property (nonatomic,assign) NSInteger selectedSegmentIndex;

///初始化
- (instancetype)initWithItems:(nullable NSArray *)items;

///选中某个按钮(在页面出现时使用)
- (void)selectedSegmentAtIndex:(NSUInteger)segment animation:(BOOL)animation;

///更新设置第某个标题
- (void)setTitle:(nullable NSString *)title forSegmentAtIndex:(NSUInteger)segment;

///获取第某个按钮标题
- (nullable NSString *)titleForSegmentAtIndex:(NSUInteger)segment;

///更新设置第某个按钮图片
- (void)setImage:(nullable UIImage *)image forSegmentAtIndex:(NSUInteger)segment;

///获取第某个按钮图片
- (nullable UIImage *)imageForSegmentAtIndex:(NSUInteger)segment;

///设置按钮不同状态的文字显示样式
- (void)setTitleTextAttributes:(nullable NSDictionary<NSAttributedStringKey,id> *)attributes forState:(UIControlState)state;


@end

NS_ASSUME_NONNULL_END


/**
- (FSSegmentedControl *)btnSegmentControl{
    if (!_btnSegmentControl) {
        _btnSegmentControl = [[FSSegmentedControl alloc] initWithItems:@[@"城市列表",@"下载管理"]];
        _btnSegmentControl.delegate = self;
        [_btnSegmentControl setTitleTextAttributes:@{NSFontAttributeName:kFontOfSystem(14),NSForegroundColorAttributeName:APPColor_Gray} forState:UIControlStateNormal];
        [_btnSegmentControl setTitleTextAttributes:@{NSFontAttributeName:kFontOfSystem(14),NSForegroundColorAttributeName:APPColor_White} forState:UIControlStateSelected];
        _btnSegmentControl.tintColor = RGBX(0x20A8FF);
        _btnSegmentControl.backgroundColor = RGBX(0xF6F5F8);
        _btnSegmentControl.layer.cornerRadius = 2;
        _btnSegmentControl.layer.masksToBounds = YES;
    }
    
    return _btnSegmentControl;
}
 */

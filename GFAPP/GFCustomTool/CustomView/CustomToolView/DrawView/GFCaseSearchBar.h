//
//  GFCaseSearchBar.h
//  Lawpress
//  自绘制边框
//  Created by XinKun on 2017/8/24.
//  Copyright © 2017年 彬万. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GFCaseSearchBar : UIView

///搜索条的label显示案例条数
@property (nonatomic,strong) UILabel *labelSearch;

///进入案例搜索页面
@property (nonatomic,copy) void(^blockGotoSearch)();

///刷新外部cell
@property (nonatomic,copy) void(^blockRefreshCell)(NSInteger type);


///赋值案例和法规条数
- (void)setCaseTotal:(NSString *)caseTotal lawTotal:(NSString *)lawTotal;


@end

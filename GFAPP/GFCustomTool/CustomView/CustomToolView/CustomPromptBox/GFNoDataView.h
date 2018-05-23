//
//  HSNoDataView.h
//  GFAPP
//  无数据占位图
//  Created by gaoyafeng on 2018/5/23.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GFNoDataViewType) {
    GFNoDataViewTypeNormal = 0,//正常
    GFNoDataViewTypeTXBJ,//特权本金
    GFNoDataViewTypeEarning,//收益
};

@interface GFNoDataView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *textLabel;
@property (nonatomic, assign) GFNoDataViewType noDataViewType;


@property (nonatomic, copy) void(^NoDataViewBlock)(void);


///更新子视图的约束
- (void)uptateSubViewFrame;

@end

/**
- (void)showNoDataView:(HSNoDataViewType)noDataType {
    if (self.customDataView.superview) {
        [self hiddenNoDataView];
    }
    self.customDataView = [[NSBundle mainBundle] loadNibNamed:@"HSNoDataView" owner:self options:nil][0];
    _customDataView.frame = CGRectMake(0, KTopHeight, KScreenWidth, KScreenHeight - KTopHeight);
    _customDataView.noDataViewType = noDataType;
    [self.view addSubview:_customDataView];
    
    switch (noDataType) {
        case HSNoDataViewTypeNormal:
            
            break;
        case HSNoDataViewTypeTXBJ:
            _customDataView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 175 - 44);
            break;
        case HSNoDataViewTypeEarning:
            _customDataView.frame = CGRectMake(0, 175, KScreenWidth, KScreenHeight - 175);
            break;
            
        default:
            break;
    }
}
 */

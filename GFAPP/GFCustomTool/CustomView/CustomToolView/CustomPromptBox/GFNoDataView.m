//
//  HSNoDataView.m
//  IMHuaSheng
//
//  Created by Ye Wei on 2017/8/30.
//  Copyright © 2017年 cheddd_li. All rights reserved.
//

#import "GFNoDataView.h"

@implementation GFNoDataView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //self.textLabel.font = [UIFont systemFontOfSize:14 * KSCALE];
    self.textLabel.textColor = UIColorFromSameRGB(155);

}

- (void)setNoDataViewType:(GFNoDataViewType)noDataViewType {
    
    //self.imageView.frame = CGRectMake(0, 0, 150 * KSCALE, 121 * KSCALE);
    
    //self.imageView.center = CGPointMake(kScreenWidth/2., kScreenHeight/2.);
    
    switch (noDataViewType) {
        case GFNoDataViewTypeNormal:{
            self.imageView.image = [UIImage imageNamed:@"group"];
            self.textLabel.text = @"暂无记录";
            break;
        }
        case GFNoDataViewTypeTXBJ:{
            self.imageView.image = [UIImage imageNamed:@"group"];
            self.textLabel.text = @"暂无记录";
            //self.imageView.centerY = (87 + 60)*KSCALE;
            break;
        }
        case GFNoDataViewTypeEarning:{
            self.imageView.image = [UIImage imageNamed:@"group"];
            self.textLabel.text = @"暂无记录";
            //self.imageView.centerY = (87 + 60)*KSCALE;
            break;
        }
        default:
            break;
    }
    
    
    self.textLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame)+16, kScreenWidth, 20);
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    //self.textLabel.sd_layout.leftEqualToView(self).heightIs(20).topSpaceToView(self.imageView, 16).widthIs(KScreenWidth);
}




@end

//
//  GFBaseCellXib.m
//  GFAPP
//
//  Created by gaoyafeng on 2018/9/15.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "GFBaseCellXib.h"

@implementation GFBaseCellXib

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellIdentifier = @"GFBaseCellXib";
    GFBaseCellXib *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"GFBaseCellXib" owner:self options:nil][0];
    }
    
    return cell;
}

//赋值必须走这个model的set方法！！！！！
- (void)setAnnouncementModel:(APPBaseModel *)announcementModel
{
    _announcementModel = announcementModel;
    
    /**
    _dateLabel.text = announcementModel.createTime;
    _titleLabel.text = announcementModel.title;
    _contentLabel.text = announcementModel.cmsContent;
    _bottomDateLabel.text = announcementModel.noticeDate;
    _companyLabel.text = announcementModel.companyName;
     */
    
    // 设置_containerView高度根据子其内容自适应
    
    [self setupAutoHeightWithBottomView:nil bottomMargin:15];//必须填写最下边的view
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

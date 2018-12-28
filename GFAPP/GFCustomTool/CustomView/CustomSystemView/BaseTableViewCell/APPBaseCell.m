//
//  APPBaseCell.m
//  FlashRider
//
//  Created by gaoyafeng on 2018/11/22.
//  Copyright © 2018 ishansong. All rights reserved.
//

#import "APPBaseCell.h"

@implementation APPBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createView];
        
        [self addMasory];
    }
    return self;
}

///添加view
- (void)createView{
    
    _imgLeft = [[UIImageView alloc] init];
    [self.contentView addSubview:_imgLeft];
    
    _labelLeft = [[UILabel alloc] init];
    _labelLeft.textColor = RGBS(51);
    _labelLeft.textAlignment = NSTextAlignmentLeft;
    _labelLeft.font = kFontOfSystem(16);
    [self.contentView addSubview:_labelLeft];
    
    _labelRight = [[UILabel alloc] init];
    _labelRight.textColor = RGBS(51);
    _labelRight.textAlignment = NSTextAlignmentRight;
    _labelRight.font = kFontOfSystem(16);
    [self.contentView addSubview:_labelRight];
    
    _imgRight = [[UIImageView alloc] init];
    [self.contentView addSubview:_imgRight];
    
    _lineBottom = [[UIView alloc] init];
    _lineBottom.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_lineBottom];
    
    _imgLeft.hidden = YES;
    _imgRight.hidden = YES;
    _labelLeft.hidden = YES;
    _labelRight.hidden = YES;
}

///添加约束
- (void)addMasory{
    
    
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

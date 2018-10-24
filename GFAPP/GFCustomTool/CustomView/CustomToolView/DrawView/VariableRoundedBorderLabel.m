//
//  VariableRoundedBorderLabel.m
//  kkkk
//
//  Created by gaoyafeng on 2018/10/24.
//  Copyright © 2018年 ishansong. All rights reserved.
//

#import "VariableRoundedBorderLabel.h"

@implementation VariableRoundedBorderLabel


- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}
-(instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithBtns:(NSArray *)btns vc:(UIViewController *)vc
{
    self = [super init];
    if (self) {
        //[self Btns:btns vc:vc];
    }
    return self;
}

-(void)commonInit{
    self.BD = BorderDirectionLeft | BorderDirectionTop | BorderDirectionRight;
    self.corners = UIRectCornerTopLeft | UIRectCornerTopRight;
    self.radius = 5;
    self.borderColor = [UIColor blackColor];
    self.borderWidth = 2;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    // Drawing code
    [VariableRoundedBorderView setVariableRoundedBorder:rect view:self
                                                     BD:self.BD
                                                corners:self.corners
                                                 radius:self.radius
                                            borderWidth:self.borderWidth
                                            borderColor:self.borderColor];
}



@end

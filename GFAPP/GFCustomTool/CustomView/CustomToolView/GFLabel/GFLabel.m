//
//  GFLabel.m
//  GFAPP
//
//  Created by gaoyafeng on 2018/6/15.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "GFLabel.h"

@implementation GFLabel


+ (instancetype)initLable{
    GFLabel *label = [[GFLabel alloc] init];
    return label;
}

+ (instancetype)initLableWithtext:(NSString *)text font:(CGFloat)font textColor:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment {
    GFLabel *label = [self initLable];
    label.text = text;
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = color;
    label.textAlignment = textAlignment;
    return label;
}


- (void)setGfText:(NSString *)gfText{
    
    [self set_text:gfText];
}




@end



@implementation GFLabel (Text)


- (void)set_text:(NSString *)text{
    
    self.text = text.length > 0 ? text : @"";
}

- (void)set_text:(NSString *)text nodataStr:(NSString *)nodataStr{
    
    self.text = text.length > 0 ? text : nodataStr;
}

- (void)set_placeholderText:(NSString *)formatStr withText:(NSString *)dataStr{
    
    dataStr = dataStr.length > 0 ? dataStr : @"";
    self.text = [NSString stringWithFormat:formatStr,dataStr];
}

- (void)set_placeholderText:(NSString *)formatStr withText:(NSString *)dataStr nodataStr:(NSString *)nodataStr{
    dataStr = dataStr.length > 0 ? dataStr : nodataStr;
    self.text = [NSString stringWithFormat:formatStr,dataStr];
}


@end


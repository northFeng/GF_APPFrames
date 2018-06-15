//
//  UILabel+Text.m
//  GFAPP
//
//  Created by gaoyafeng on 2018/6/15.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "UILabel+Text.h"


@implementation UILabel (Text)


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

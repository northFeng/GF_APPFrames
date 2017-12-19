//
//  GFFunctionMethod.m
//  GFAPP
//
//  Created by XinKun on 2017/11/28.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "GFFunctionMethod.h"

@implementation GFFunctionMethod

#pragma mark - base64编码

///编码字符串--->base64字符串
- (NSString *)base64_encodeBase64StringWithString:(NSString *)encodeStr{
    
    NSData *encodeData = [encodeStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Str = [encodeData base64EncodedStringWithOptions:0];
    
    return base64Str;
}

///编码字符串--->base64data
- (NSString *)base64_encodeBase64StringWithData:(NSData *)encodeData{
    
    NSString *encodeStr = [encodeData base64EncodedStringWithOptions:0];
    
    return encodeStr;
}

///解码----->原字符串
- (NSString *)base64_decodeBase64StringWithBase64String:(NSString *)base64Str{
    
    NSString *decodeStr = [[NSString alloc] initWithData:[[NSData alloc] initWithBase64EncodedString:base64Str options:0] encoding:NSUTF8StringEncoding];
    
    return decodeStr;
}

///解码----->原Data
- (NSData *)base64_decodeBase64DataWithBase64Data:(NSData *)base64Data{
    
    NSData *decodeData = [[NSData alloc] initWithBase64EncodedData:base64Data options:0];
    
    return decodeData;
}

#pragma mark - d时间操作
///获取当前时间@"YYYY-MM-dd HH:mm
- (NSString *)date_getCurrentDateWithType:(NSString *)timeType{
    //获取当前时间
    NSDate *senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:timeType];
    NSString *timeString=[dateformatter stringFromDate:senddate];
    
    return timeString;
}

///把日期数字换换成 年月日
- (NSString *)date_getTimeString:(NSString *)timeString{
    //,[timeString substringWithRange:NSMakeRange(6, 2)]
    NSString *time = [NSString stringWithFormat:@"%@-%@-%@",[timeString substringToIndex:4],[timeString substringWithRange:NSMakeRange(4, 2)],[timeString substringWithRange:NSMakeRange(6, 2)]];
    
    return time;
}

///把日期数字换换成 年月日 不带 ——
- (NSString *)date_getTimeStringTwo:(NSString *)timeString{
    //,[timeString substringWithRange:NSMakeRange(6, 2)]
    NSString *time = [NSString stringWithFormat:@"%@年%@月",[timeString substringToIndex:4],[timeString substringWithRange:NSMakeRange(4, 2)]];
    
    return time;
}


#pragma mark - s字符串操作
///获取文字的高度
- (CGFloat)string_getTextHeight:(NSString *)text textFont:(CGFloat)font lineSpacing:(CGFloat)lineSpace textWidth:(CGFloat)textWidth{
    
    CGFloat height = 0.;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;// 字体的行间距
    paragraphStyle.alignment = NSTextAlignmentJustified;//两端对齐
    CGSize cellSize = [text boundingRectWithSize:CGSizeMake(textWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:font],NSFontAttributeName,paragraphStyle,NSParagraphStyleAttributeName, nil] context:nil].size;
    
    height = cellSize.height;//cellSize.height > 55.5 ? 55.5 : cellSize.height;
    
    return height;
}

///获取文字的宽度
- (CGFloat)string_getTextWidth:(NSString *)text textFont:(CGFloat)font lineSpacing:(CGFloat)lineSpace textHeight:(CGFloat)textHeight{
    
    CGFloat width = 0.;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 0;//lineSpace;// 字体的行间距
    CGSize cellSize = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, textHeight) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:font],NSFontAttributeName,paragraphStyle,NSParagraphStyleAttributeName, nil] context:nil].size;
    //[self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size
    width = cellSize.width;//cellSize.height > 55.5 ? 55.5 : cellSize.height;
    
    return width+1;//适配iOS10，必须多一点
}

/**
 获取指定的属性字符串(标准型！)
 param:font --字体大小
 param:lineHeight -- 行高
 textWeight: 0，标准字体 1:粗体
 */
- (NSMutableAttributedString *)string_getAttributedStringWithString:(NSString *)textString textFont:(CGFloat)font textLineHeight:(CGFloat)lineHeight textWight:(NSInteger)textWeight{
    
    //label必须设置 [label sizeToFit];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    if (lineHeight > 0) {
        paragraphStyle.lineSpacing = lineHeight - font;
    }
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    
    NSDictionary *dictionaryAttrbuted;
    if (textWeight) {
        //粗体
        dictionaryAttrbuted = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:font],NSParagraphStyleAttributeName:paragraphStyle};
    }else{
        dictionaryAttrbuted = @{NSFontAttributeName:[UIFont systemFontOfSize:font],NSParagraphStyleAttributeName:paragraphStyle};
    }
    
    NSMutableAttributedString *attributedString;
    if (textString.length) {
        attributedString = [[NSMutableAttributedString alloc] initWithString:textString attributes:dictionaryAttrbuted];
    }else{
        attributedString = [[NSMutableAttributedString alloc] initWithString:@"暂无内容" attributes:dictionaryAttrbuted];
    }
    
    
    return attributedString;
}

///获取文字段内指定文字所有的范围集合
- (NSArray *)string_getSameStringRangeArray:(NSString *)superString andAppointString:(NSString *)searchString{
    
    NSMutableArray *arrayRange = [NSMutableArray array];
    NSRange searchRange = NSMakeRange(0, superString.length);
    NSRange range = NSMakeRange(0, 0);
    
    //无限循环处理 找 位置
    while(range.location != NSNotFound && searchRange.location < superString.length)
    {
        //NSStringCompareOptions
        range = [superString rangeOfString:searchString options:NSCaseInsensitiveSearch range:searchRange];
        if (range.location != NSNotFound)
        {
            searchRange.location = range.location + range.length;
            searchRange.length = superString.length - searchRange.location;
            NSRange rangeTwo = range;
            [arrayRange addObject:[NSValue valueWithRange:rangeTwo]];
        }
    }
    
    return [arrayRange copy];
}

///获取价格
- (NSMutableAttributedString *)string_getPriceAttributedString:(NSString *)price oneSize:(CGFloat)oneSize twoSize:(CGFloat)twoSize textColor:(UIColor *)textColor{
    //价格13 20
    if (price) {
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %@",price]];
        NSDictionary *dicOne = @{NSFontAttributeName:[UIFont systemFontOfSize:oneSize],NSForegroundColorAttributeName:textColor};
        NSDictionary *dicTwo = @{NSFontAttributeName:[UIFont systemFontOfSize:twoSize],NSForegroundColorAttributeName:textColor};
        [attributeString addAttributes:dicOne range:NSMakeRange(0, 1)];
        [attributeString addAttributes:dicTwo range:NSMakeRange(1, attributeString.length-1)];
        
        return attributeString;
    }else{
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥"]];
        NSDictionary *dicOne = @{NSFontAttributeName:[UIFont systemFontOfSize:oneSize],NSForegroundColorAttributeName:textColor};
        [attributeString addAttributes:dicOne range:NSMakeRange(0, 1)];
        return attributeString;
    }
}

///获取唯一标识符字符串
- (NSString *)string_getUUIDString{
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef strRef = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
    NSString *uuidString = [(__bridge NSString *)strRef stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(strRef);
    CFRelease(uuidRef);
    return uuidString;
}

///把字符串 以中间空格拆分 得到 数组
- (NSArray *)string_getArrayWithNoSpaceString:(NSString *)string{
    NSArray *arrayOne = [string componentsSeparatedByString:@" "];
    
    NSMutableArray *arrayTwo = [NSMutableArray array];
    
    for (NSString *wordString in arrayOne) {
        
        if (wordString.length>0) {
            
            [arrayTwo addObject:wordString];
        }
    }
    
    return [arrayTwo copy];
}

///获取去除字符串的首位空格
- (NSString *)string_getStringWithRemoveFrontAndRearSpacesByString:(NSString *)oldString{
    NSString *newString = [oldString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return newString;
}


#pragma mark - 创建定时器
- (void)timer_createTimerToViewController:(UIViewController *)VCSelf selector:(SEL)aSelector{
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:VCSelf selector:aSelector userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    //开启
    [timer setFireDate:[NSDate distantPast]];
    //暂停
    //[_timer setFireDate:[NSDate distantFuture]];
    //销毁定时器
//    [timer invalidate];
//    timer = nil;
    
}


#pragma mark - u判断URL是否有效
///判断url是否可链接成功
- (BOOL)url_ValidateUrIsLinkSuccessForUrl:(NSString *)urlStr{
    //发送请求
    NSString *url = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest *request11 = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:2];
    
    //响应头:连接的状态，建立链接的时间
    //NSHTTPURLResponse *response;
    //NSError *error;
    //data是请求回来的具体数据内容
    //[NSURLConnection sendSynchronousRequest:request11 returningResponse:&response error:&error];
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request11];
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)dataTask.response;
    //200成功访问地址
    if ((response.statusCode/100) == 2) {
        return YES;
    }else{
        return NO;
    }
}

/**
 * 网址正则验证 1或者2使用哪个都可以
 *
 *  @param string 要验证的字符串
 *
 *  @return 返回值类型为BOOL
 */
- (BOOL)url_ValidationUrlForUrlString:(NSString *)string{
    NSError *error;
    // 正则1
    NSString *regulaStr =@"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    // 正则2
    //regulaStr =@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    for (NSTextCheckingResult *match in arrayOfAllMatches){
        [string substringWithRange:match.range];
        //NSString *substringForMatch = [string substringWithRange:match.range];
        //NSLog(@"匹配");
        return YES;
    }
    
    return NO;
}

#pragma mark - v视图操作
///设置视图的圆角和边框线
- (void)view_addBorderOnView:(UIView *)view borderWidth:(CGFloat)width borderColor:(UIColor *)color cornerRadius:(CGFloat)radius{
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = width;
    view.layer.borderColor = color.CGColor;
}

///创建label  参数weight为 0：不加粗  1:加粗
- (UILabel *)view_createLabelWith:(NSString *)text font:(CGFloat)font textColor:(CGColorRef)cgColor textAlignment:(NSTextAlignment)alignment textWight:(NSInteger)weight{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    if (weight==0) {
        label.font = [UIFont systemFontOfSize:font];
    }else{
        label.font = [UIFont boldSystemFontOfSize:font];
    }
    label.textColor = [UIColor colorWithCGColor:cgColor];
    label.textAlignment = alignment;
    
    return label;
}

///父视图主动移除所有的子视图
- (void)view_removeAllChildsViewFormSubView:(UIView *)subView{
    
    [subView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}





@end

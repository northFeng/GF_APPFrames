//
//  GFFunctionMethod.m
//  GFAPP
//
//  Created by XinKun on 2017/11/28.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "GFFunctionMethod.h"

@implementation GFFunctionMethod


///字符串转换对应的对象（数组/字典）
- (id)jsonStringConversionToObject:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    /**
     NSJSONReadingMutableContainers = (1UL << 0),//返回可变容器，NSMutableDictionary或NSMutableArray。
     NSJSONReadingMutableLeaves = (1UL << 1),//返回的JSON对象中字符串的值为NSMutableString，目前在iOS 7上测试不好用，应该是个bug
     NSJSONReadingAllowFragments = (1UL << 2)//允许JSON字符串最外层既不是NSArray也不是NSDictionary，但必须是有效的JSON Fragment。例如使用这个选项可以解析 @“123” 这样的字符串。
     */
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers
                          error:&error];
    if(error) {
        NSLog(@"json解析失败：%@",error);
        return nil;
    }
    return jsonObject;
}

///对象转换成字符串
- (NSString *)jsonObjectConversionToString:(id)jsonObject{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:&parseError];
    
    if (parseError) {
        return  nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark - array数组操作方法
///数组的升序
- (void)array_ascendingSortWithMutableArray:(NSMutableArray *)oldArray{
    
    
//    [oldArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {

//        APPBoughtInfoModel *bookInfo1 = (APPBoughtInfoModel *)obj1;
//        APPBoughtInfoModel *bookInfo2 = (APPBoughtInfoModel *)obj2;
//        double a = [bookInfo1.operateTime integerValue];
//        double b = [bookInfo2.operateTime integerValue];
//        if (a < b) {
//            return NSOrderedDescending;
//        } else if (a > b) {
//            return NSOrderedAscending;
//        } else {
//            return NSOrderedSame;
//        }
//    }];
    
}

///数组降序
- (void)array_descendingSortWithMutableArray:(NSMutableArray *)oldArray{
    
    
    
}

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


#pragma mark - 字体操作
///设置字体
- (UIFont *)font_setFontWithPingFangSC:(NSString *)fontName size:(NSInteger)size{
    
    NSString *fontString = [NSString stringWithFormat:@"PingFangSC-%@",fontName];
    UIFont *font = [UIFont fontWithName:fontString size:size];
    return font;
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

///数据字符串处理
- (NSString *)string_handleNull:(NSString *)string{
    
    if ([string isKindOfClass:[NSNull class]] || string.length == 0) {
        
        string = @"";//自定义无数据提示语
    }
    return  string;
}


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

///获取合并字符串
- (NSMutableAttributedString *)string_getMergeAttributedStringWithHeadString:(NSString *)headString headStringFont:(NSInteger)headFont headStringColor:(UIColor *)headColor endString:(NSString *)endString endStringFont:(NSInteger)endFont endStringColor:(UIColor *)endColor{
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",headString,endString]];
    NSDictionary *headDic = @{NSFontAttributeName:[UIFont systemFontOfSize:headFont],NSForegroundColorAttributeName:headColor};
    NSDictionary *endDic = @{NSFontAttributeName:[UIFont systemFontOfSize:endFont],NSForegroundColorAttributeName:endColor};
    [attributeString addAttributes:headDic range:NSMakeRange(0, headString.length)];
    [attributeString addAttributes:endDic range:NSMakeRange(headString.length, endString.length)];
    
    return attributeString;
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

///去除字符串的标点符号
- (NSString *)string_getStringFilterPunctuationByString:(NSString *)string{
    
    //去除标点符号
    NSString *newString = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet punctuationCharacterSet]] componentsJoinedByString:@""];
    
    return newString;
}

///判断字符串是否含有表情符号
- (BOOL)string_getStringIsOrNotContainEmojiByString:(NSString *)string{
    
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    
    return returnValue;
    
}

///去除字符串中的表情符号
- (NSString *)string_getStringFilterEmojiByString:(NSString *)string{
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:string
                                                               options:0
                                                                 range:NSMakeRange(0, [string length])
                                                          withTemplate:@""];
    return modifiedString;
}



///处理高亮文字
- (NSMutableAttributedString *)string_getHighLigntText:(NSString *)hightText hightFont:(NSInteger)hifhtFont hightColor:(UIColor *)hightColor hightTextIsBlod:(BOOL)isHightBlod totalStirng:(NSString *)totalStirng defaultFont:(NSInteger)defaultFont defaultColor:(UIColor *)defaultColor defaultTextIsBlod:(BOOL)defaultIsBlod{
    
    NSArray *arrayTotal;
    if (hightText.length > 0) {
        arrayTotal = [self string_getSameStringRangeArray:totalStirng andAppointString:hightText];
    }
    
    NSDictionary *dicHight;
    if (isHightBlod) {
        dicHight = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:hifhtFont],NSForegroundColorAttributeName:hightColor};
    }else{
        dicHight = @{NSFontAttributeName:[UIFont systemFontOfSize:hifhtFont],NSForegroundColorAttributeName:hightColor};
    }
    
    NSDictionary *defaultDic;
    if (defaultIsBlod) {
        defaultDic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:defaultFont],NSForegroundColorAttributeName:defaultColor};
    }else{
        defaultDic = @{NSFontAttributeName:[UIFont systemFontOfSize:defaultFont],NSForegroundColorAttributeName:defaultColor};
    }
    
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:totalStirng attributes:defaultDic];
    
    for (NSValue *rangValue in arrayTotal) {
        //字段
        NSRange range = [rangValue rangeValue];
        [attrString addAttributes:dicHight range:range];
    }
    
    return attrString;
}


///获取图片附件富文本
- (NSMutableAttributedString *)string_getAttachmentStringWithString:(NSMutableAttributedString *)mutableString image:(UIImage *)image imageRect:(CGRect)imgRect index:(NSInteger)index{
    
    NSTextAttachment *attach = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
    
    //附件的frame，图层绘制是倒置的 ————> 左下角为原点
    attach.bounds = imgRect;
    
    attach.image = image;
    NSAttributedString *strAttach = [NSAttributedString attributedStringWithAttachment:attach];
    
    if (index == -1) {
        [mutableString appendAttributedString:strAttach];
    }else{
        [mutableString insertAttributedString:strAttach atIndex:index];
    }
    return mutableString;
}

#pragma mark - 加载图片 && GIF
///加载图片
- (void)img_setImageWithUrl:(NSString *)url placeholderImage:(NSString *)placeholderImgName imgView:(UIImageView *)imgView{
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:placeholderImgName] options:SDWebImageRetryFailed];
}

///加载动画
- (void)img_setImageWithGifName:(NSString *)gifName imgView:(UIImageView *)imgView{
    NSString *path;
    if ([gifName hasSuffix:@"gif"]) {
        gifName = [gifName stringByReplacingOccurrencesOfString:@".gif" withString:@""];
    }
    path = [[NSBundle mainBundle] pathForResource:gifName ofType:@"gif"];
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    UIImage *image = [UIImage sd_animatedGIFWithData:data];
    imgView.image = image;
}



#pragma mark - 创建定时器
- (void)timer_createTimerToViewController:(UIViewController *)VCSelf selector:(SEL)aSelector{
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:VCSelf selector:aSelector userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    //开启
    //[timer setFireDate:[NSDate distantPast]];
    //暂停
    [timer setFireDate:[NSDate distantFuture]];
    //销毁定时器
//    [timer invalidate];
//    timer = nil;
    
}


#pragma mark - u判断URL是否有效
///判断url是否可链接成功
- (BOOL)url_ValidateUrIsLinkSuccessForUrl:(NSString *)urlStr{
    
    //发送请求
    NSString *url = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:2];
    //HEAD请求（不请求数据，只请求数据的状态信息）
    [request setHTTPMethod:@"HEAD"];
    
    //响应头:连接的状态，建立链接的时间
    //NSHTTPURLResponse *response;
    //NSError *error;
    //data是请求回来的具体数据内容
    //[NSURLConnection sendSynchronousRequest:request11 returningResponse:&response error:&error];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request];
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


///添加横向的混合颜色
- (void)view_addHybridBackgroundColorWithColorOne:(UIColor *)colorOne andColorTwo:(UIColor *)colorTwo showOnView:(UIView *)onView{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)colorOne.CGColor, (__bridge id)colorTwo.CGColor];
    gradientLayer.locations = @[@0.4, @0.7, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 1);
    gradientLayer.endPoint = CGPointMake(1.0, 1);
    gradientLayer.frame = CGRectMake(0, 0, onView.frame.size.width, onView.frame.size.height);
    
    [onView.layer addSublayer:gradientLayer];
}




#pragma mark - 16进制字符串与16进制之间的转换
//普通字符串转换为十六进制的。
- (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}


// 十六进制转换为普通字符串的。
- (NSString *)stringFromHexString:(NSString *)hexString {
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"------字符串=======%@",unicodeString);
    return unicodeString;
}



















@end

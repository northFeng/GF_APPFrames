//
//  GFFunctionMethod.m
//  GFAPP
//
//  Created by XinKun on 2017/11/28.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "GFFunctionMethod.h"

#import "APPHttpTool.h"

@implementation GFFunctionMethod


///判断APP是否安装
+ (BOOL)appIsOpenWithAppType:(NSInteger)appType{
    
    BOOL isApp = NO;
    
    switch (appType) {
        case 1:
            NSLog(@"微信注册");
            //在info.plist 添加(Array属性)  LSApplicationQueriesSchemes
            //然后里面 添加两个(string属性) weixin 和 wechat
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
                
                isApp = YES;
            }
            
            break;
        case 2:
            NSLog(@"QQ注册");
            
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
                
                isApp = YES;
            }
            break;
        case 3:
            NSLog(@"微博注册");
            
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibosso://"]]) {
                
                isApp = YES;
            }
            break;
            
        default:
            break;
    }
    
    return isApp;
}

///字符串转换对应的对象（数组/字典）
+ (id)jsonStringConversionToObject:(NSString *)jsonString{
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
+ (NSString *)jsonObjectConversionToString:(id)jsonObject{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:&parseError];
    
    if (parseError) {
        return  nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark - array数组操作方法
///数组的升序
+ (void)array_ascendingSortWithMutableArray:(NSMutableArray *)oldArray{
    
    
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
+ (void)array_descendingSortWithMutableArray:(NSMutableArray *)oldArray{
    
    
    
}

#pragma mark - base64编码
///编码字符串--->base64字符串
+ (NSString *)base64_encodeBase64StringWithString:(NSString *)encodeStr{
    
    NSData *encodeData = [encodeStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Str = [encodeData base64EncodedStringWithOptions:0];
    
    return base64Str;
}

///编码字符串--->base64data
+ (NSString *)base64_encodeBase64StringWithData:(NSData *)encodeData{
    
    NSString *encodeStr = [encodeData base64EncodedStringWithOptions:0];
    
    return encodeStr;
}

///解码----->原字符串
+ (NSString *)base64_decodeBase64StringWithBase64String:(NSString *)base64Str{
    
    NSString *decodeStr = [[NSString alloc] initWithData:[[NSData alloc] initWithBase64EncodedString:base64Str options:0] encoding:NSUTF8StringEncoding];
    
    return decodeStr;
}

///解码----->原Data
+ (NSData *)base64_decodeBase64DataWithBase64Data:(NSData *)base64Data{
    
    NSData *decodeData = [[NSData alloc] initWithBase64EncodedData:base64Data options:0];
    
    return decodeData;
}


#pragma mark - 字体操作
///设置字体
+ (UIFont *)font_setFontWithPingFangSC:(NSString *)fontName size:(NSInteger)size{
    
    NSString *fontString = [NSString stringWithFormat:@"PingFangSC-%@",fontName];
    UIFont *font = [UIFont fontWithName:fontString size:size];
    return font;
}

#pragma mark - d时间操作
///获取当前时间@"YYYY-MM-dd HH:mm
+ (NSString *)date_getCurrentDateWithType:(NSString *)timeType{
    //获取当前时间
    NSDate *senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:timeType];
    NSString *timeString=[dateformatter stringFromDate:senddate];
    
    return timeString;
}

///时间戳转换时间
+ (NSString *)date_getDateWithTimeStamp:(NSInteger)timeStamp timeType:(NSString *)timeType{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:timeType];
    
    NSString *timeString=[dateformatter stringFromDate:date];
    
    return timeString;
}

///获取当前时间戳 && 精度1000毫秒 1000000微妙
+ (NSInteger)date_getNowTimeStampWithPrecision:(NSInteger)precision{
    
    NSDate *date = [NSDate date];
    
    NSTimeInterval nowTime = date.timeIntervalSince1970 * precision;
    
    NSInteger nowStamp = nowTime / 1;
    
    return nowStamp;
}

///把日期数字换换成 年月日
+ (NSString *)date_getTimeString:(NSString *)timeString{
    //,[timeString substringWithRange:NSMakeRange(6, 2)]
    NSString *time = [NSString stringWithFormat:@"%@-%@-%@",[timeString substringToIndex:4],[timeString substringWithRange:NSMakeRange(4, 2)],[timeString substringWithRange:NSMakeRange(6, 2)]];
    
    return time;
}

///把日期数字换换成 年月日 不带 ——
+ (NSString *)date_getTimeStringTwo:(NSString *)timeString{
    //,[timeString substringWithRange:NSMakeRange(6, 2)]
    NSString *time = [NSString stringWithFormat:@"%@年%@月",[timeString substringToIndex:4],[timeString substringWithRange:NSMakeRange(4, 2)]];
    
    return time;
}

///指定年月——>到现在的年月
+ (NSMutableArray *)date_getDateArrayToNowWithYear:(NSInteger)startYear startMonth:(NSInteger)startMonth{
    
    NSMutableArray *arrayDate = [NSMutableArray array];
    
    NSMutableArray *arrayYear = [NSMutableArray array];//年份
    NSMutableArray *arrayMonth = [NSMutableArray array];//月份
    
    //获取当前时间
    NSDate *senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM"];
    NSString *nowDateStr = [dateformatter stringFromDate:senddate];
    
    NSArray *arrayNowDate = [nowDateStr componentsSeparatedByString:@"-"];
    NSInteger nowYear = [arrayNowDate[0] integerValue];//现在的年份
    NSInteger nowMonth = [arrayNowDate[1] integerValue];//现在的月份
    
    //    NSInteger startYear = 2015;//开始的年份
    //    NSInteger startMonth = 10;//开始的月份
    NSInteger beginYear = startYear;
    while (1) {
        
        //添加年份
        [arrayYear addObject:[NSString stringWithFormat:@"%ld",(long)startYear]];
        
        //添加月份
        NSArray *array;
        if (startYear == beginYear) {
            //开始年份 && 判断 开始年份 是否等于 现在年份
            NSMutableArray *firstMonthArray = [NSMutableArray array];
            
            if (startYear == nowYear) {
                //年份相同
                for (NSInteger i = startMonth; i < nowMonth + 1; i++) {
                    [firstMonthArray gf_addObject:[NSString stringWithFormat:@"%ld",(long)i]];
                }
            }else{
                //年份不同
                for (NSInteger i = startMonth; i < 12 + 1; i++) {
                    [firstMonthArray gf_addObject:[NSString stringWithFormat:@"%ld",(long)i]];
                }
            }
            
            array = [firstMonthArray copy];
        }else if (startYear == nowYear){
            //等于现在年份
            NSMutableArray *lastMonthArray = [NSMutableArray array];
            for (int i = 1; i < nowMonth + 1; i++) {
                [lastMonthArray gf_addObject:[NSString stringWithFormat:@"%d",i]];
            }
            array = [lastMonthArray copy];
        }else{
            //小于现在年份
            array = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
        }
        
        [arrayMonth addObject:array];
        
        startYear ++;
        
        if (startYear > nowYear) {
            //中断循环
            break ;
        }
    }
    
    [arrayDate addObject:arrayYear];
    [arrayDate addObject:arrayMonth];
    
    return arrayDate;
}


///获取富文本文字
+ (NSAttributedString *)string_getAttributeStringWithString:(NSString *)text textFont:(UIFont *)font textColor:(UIColor *)color{
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    
    return attrString;
}


///数据字符串处理
+ (NSString *)string_handleNull:(NSString *)string{
    
    if ([string isKindOfClass:[NSNull class]] || string.length == 0) {
        
        string = @"";//自定义无数据提示语
    }
    return  string;
}


///获取文字的高度
+ (CGFloat)string_getTextHeight:(NSString *)text textFont:(UIFont *)font lineSpacing:(CGFloat)lineSpace textWidth:(CGFloat)textWidth{
    
    CGFloat height = 0.;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;// 字体的行间距
    paragraphStyle.alignment = NSTextAlignmentJustified;//两端对齐
    CGSize cellSize = [text boundingRectWithSize:CGSizeMake(textWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,paragraphStyle,NSParagraphStyleAttributeName, nil] context:nil].size;
    
    height = cellSize.height;//cellSize.height > 55.5 ? 55.5 : cellSize.height;
    
    return height;
}

///获取文字的宽度
+ (CGFloat)string_getTextWidth:(NSString *)text textFont:(UIFont *)font lineSpacing:(CGFloat)lineSpace textHeight:(CGFloat)textHeight{
    
    CGFloat width = 0.;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 0;//lineSpace;// 字体的行间距
    CGSize cellSize = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, textHeight) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,paragraphStyle,NSParagraphStyleAttributeName, nil] context:nil].size;
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
+ (NSMutableAttributedString *)string_getAttributedStringWithString:(NSString *)textString textFont:(CGFloat)font textLineHeight:(CGFloat)lineHeight textWight:(NSInteger)textWeight{
    
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
+ (NSArray *)string_getSameStringRangeArray:(NSString *)superString andAppointString:(NSString *)searchString{
    
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

///合并富文本字符串
+ (NSAttributedString *)string_getMergeAttributedStringWithHeadString:(NSString *)headString headStringFont:(UIFont *)headFont headStringColor:(UIColor *)headColor endString:(NSString *)endString endStringFont:(UIFont *)endFont endStringColor:(UIColor *)endColor{
    
    NSMutableAttributedString *headAttrStr = [[NSMutableAttributedString alloc] initWithString:headString attributes:@{NSFontAttributeName:headFont,NSForegroundColorAttributeName:headColor}];
    
    NSAttributedString *endAtrrStr = [[NSAttributedString alloc] initWithString:endString attributes:@{NSFontAttributeName:endFont,NSForegroundColorAttributeName:endColor}];
    
    [headAttrStr appendAttributedString:endAtrrStr];
    
    return headAttrStr;
}

///合并富文本字符 —— 特殊文字在中间
+ (NSAttributedString *)string_getMergeAttributedStringWithHeadString:(NSString *)headString headStringFont:(UIFont *)headFont headStringColor:(UIColor *)headColor middleString:(NSString *)middleStr middleStrFont:(UIFont *)middleFont middleStrColor:(UIColor *)middleColor endString:(NSString *)endString endStringFont:(UIFont *)endFont endStringColor:(UIColor *)endColor{
    
    NSMutableAttributedString *headAttrStr = [[NSMutableAttributedString alloc] initWithString:headString attributes:@{NSFontAttributeName:headFont,NSForegroundColorAttributeName:headColor}];
    
    NSAttributedString *middleAttrStr = [[NSAttributedString alloc] initWithString:middleStr attributes:@{NSFontAttributeName:middleFont,NSForegroundColorAttributeName:middleColor}];
    
    NSAttributedString *endAtrrStr = [[NSAttributedString alloc] initWithString:endString attributes:@{NSFontAttributeName:endFont,NSForegroundColorAttributeName:endColor}];
    
    [headAttrStr appendAttributedString:middleAttrStr];
    [headAttrStr appendAttributedString:endAtrrStr];
    
    return headAttrStr;
}



///获取唯一标识符字符串
+ (NSString *)string_getUUIDString{
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef strRef = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
    NSString *uuidString = [(__bridge NSString *)strRef stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(strRef);
    CFRelease(uuidRef);
    return uuidString;
}

///把字符串 以中间空格拆分 得到 数组
+ (NSArray *)string_getArrayWithNoSpaceString:(NSString *)string{
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
+ (NSString *)string_getStringWithRemoveFrontAndRearSpacesByString:(NSString *)oldString{
    NSString *newString = [oldString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return newString;
}

///去除字符串的标点符号
+ (NSString *)string_getStringFilterPunctuationByString:(NSString *)string{
    
    //去除标点符号
    NSString *newString = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet punctuationCharacterSet]] componentsJoinedByString:@""];
    
    return newString;
}

///判断字符串是否含有表情符号
+ (BOOL)string_getStringIsOrNotContainEmojiByString:(NSString *)string{
    
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
+ (NSString *)string_getStringFilterEmojiByString:(NSString *)string{
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:string
                                                               options:0
                                                                 range:NSMakeRange(0, [string length])
                                                          withTemplate:@""];
    return modifiedString;
}



///处理高亮文字
+ (NSMutableAttributedString *)string_getHighLigntText:(NSString *)hightText hightFont:(NSInteger)hifhtFont hightColor:(UIColor *)hightColor hightTextIsBlod:(BOOL)isHightBlod totalStirng:(NSString *)totalStirng defaultFont:(NSInteger)defaultFont defaultColor:(UIColor *)defaultColor defaultTextIsBlod:(BOOL)defaultIsBlod{
    
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
+ (NSMutableAttributedString *)string_getAttachmentStringWithString:(NSMutableAttributedString *)mutableString image:(UIImage *)image imageRect:(CGRect)imgRect index:(NSInteger)index{
    
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
+ (void)img_setImageWithUrl:(NSString *)url placeholderImage:(NSString *)placeholderImgName imgView:(UIImageView *)imgView{
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:placeholderImgName] options:SDWebImageRetryFailed];
}

///加载动画
+ (void)img_setImageWithGifName:(NSString *)gifName imgView:(UIImageView *)imgView{
    NSString *path;
    if ([gifName hasSuffix:@"gif"]) {
        gifName = [gifName stringByReplacingOccurrencesOfString:@".gif" withString:@""];
    }
    path = [[NSBundle mainBundle] pathForResource:gifName ofType:@"gif"];
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    UIImage *image = [UIImage sd_animatedGIFWithData:data];
    imgView.image = image;
}


///加载 Bundle 中图片的三种方法
+ (UIImage *)img_loadFormBundleWithImagePath:(NSString *)path imgType:(NSString *)imgType{
    
    /**
    //第一种方法
    NSString *path = [[NSBundle mainBundle] pathForResource:@"myBundle" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    NSString *file = [bundle pathForResource:@"pic" ofType:@"png"];
    UIImage *img = [UIImage imageWithContentsOfFile:file];
    
    //第二种方法
    NSString *file2 = [[NSBundle mainBundle] pathForResource:@"myBundle.bundle/pic" ofType:@"png"];
    UIImage *img2 = [UIImage imageWithContentsOfFile:file2];
    
    //第三种方法
    UIImage *img3 = [UIImage imageNamed:@"myBundle.bundle/pic"];
     */
    
    //@"mapapi.bundle/images/baidumap_logo"  @"png"
    NSString *pathFile = [[NSBundle mainBundle] pathForResource:path ofType:imgType];
    
    UIImage *image = [UIImage imageWithContentsOfFile:pathFile];
    
    return image;
}



#pragma mark - 创建定时器
+ (void)timer_createTimerToViewController:(UIViewController *)VCSelf selector:(SEL)aSelector{
    
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
+ (BOOL)url_ValidateUrIsLinkSuccessForUrl:(NSString *)urlStr{
    
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
+ (BOOL)url_ValidationUrlForUrlString:(NSString *)string{
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
+ (void)view_addBorderOnView:(UIView *)view borderWidth:(CGFloat)width borderColor:(UIColor *)color cornerRadius:(CGFloat)radius{
    view.layer.cornerRadius = radius;
    //view.layer.masksToBounds = YES;//会导致离屏渲染（增加卡顿，掉帧）
    view.layer.borderWidth = width;
    view.layer.borderColor = color.CGColor;
}

///添加指定位置的圆角
+ (void)view_addRoundedCornersOnView:(UIView *)view cornersPosition:(UIRectCorner)corners cornersWidth:(CGFloat)widthCorner{
    
    //设置所需的圆角位置以及大小
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(widthCorner, widthCorner)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

///添加指定位置的圆角2
+ (void)view_addRoundedCornersOnView:(UIView *)view viewFrame:(CGRect)frame cornersPosition:(UIRectCorner)corners cornersWidth:(CGFloat)widthCorner{
    
    //设置所需的圆角位置以及大小
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:corners cornerRadii:CGSizeMake(widthCorner, widthCorner)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = frame;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

///添加阴影
+ (void)view_addShadowOnView:(UIView *)view shadowOffset:(CGSize)offsetSize shadowColor:(UIColor *)shadowColor shadowAlpha:(CGFloat)shadowAlpha{
    
    /**
     添加阴影的视图上面必须有图层！！否则无效果
     这个视图上要不有其他子控件，或者自己设置背景颜色，总之必须有图层！
     而且 阴影是加在了 图层的上面与控件大小无关， 阴影 是在图层的基础上加的
     */
    
    view.layer.shadowOffset = offsetSize;
    view.layer.shadowColor = shadowColor.CGColor;
    view.layer.shadowOpacity = shadowAlpha;
    
    /**
     
     1.设置圆角矩形
     _dropView.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.8];
     
     _dropView.layer.cornerRadius = 8;
     
     _dropView.layer.masksToBounds = YES;//（或者_dropView.clipsToBounds=YES;)
     这里masksToBounds或者clipsToBounds的设置是对父视图设置，设置后对子视图超出部分裁减掉（否则子视图还是会遮住圆角）。
     
     2.设置阴影:
     _dropView.layer.shadowColor=[[UIColor grayColor] colorWithAlphaComponent:0.8].CGColor;
     
     _dropView.layer.shadowOffset=CGSizeMake(10,10);
     
     _dropView.layer.shadowOpacity=0.5;
     
     _dropView.layer.shadowRadius=8;
     
     // _dropView.layer.masksToBounds = YES;
     
     在通过这样的方式设置阴影时，必须把父视图的masksToBounds属性关掉，因为阴影设置的方式就是加offset给超出视图部分设置颜色来实现的，一旦不让子视图超出，阴影也就看不出了。
     
     3.圆角+阴影
     
     如果上面的方法一起用，把masksToBounds开了，阴影无法显示，关了的话其上的View又会遮住圆角。解决的方式只能是再加一层layer。
     
     _dropView.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.8];
     _dropView.layer.cornerRadius = 8;
     _dropView.layer.masksToBounds = YES;
     CALayer *subLayer=[CALayer layer];
     
     CGRect fixframe=_dropView.layer.frame;
     
     fixframe.size.width=[UIScreen mainScreen].bounds.size.width-40;
     
     subLayer.frame=fixframe;
     
     subLayer.cornerRadius=8;
     
     subLayer.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
     
     subLayer.masksToBounds=NO;
     
     subLayer.shadowColor=[UIColor grayColor].CGColor;
     
     subLayer.shadowOffset=CGSizeMake(10,10);
     
     subLayer.shadowOpacity=0.5;
     
     subLayer.shadowRadius=8;
     
     [self.layer insertSublayer:subLayer below:_dropView.layer];
     */
}

///创建label  参数weight为 0：不加粗  1:加粗
+ (UILabel *)view_createLabelWith:(NSString *)text font:(CGFloat)font textColor:(UIColor *)cgColor textAlignment:(NSTextAlignment)alignment textWight:(NSInteger)weight{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    if (weight==0) {
        label.font = [UIFont systemFontOfSize:font];
    }else{
        label.font = [UIFont boldSystemFontOfSize:font];
    }
    label.textColor = cgColor;
    label.textAlignment = alignment;
    
    return label;
}

///创建button 参数：type 0:文字 1:图片
+ (UIButton *)view_createButtonWithType:(NSInteger)type title:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)textColor backgroundColor:(UIColor *)bgColor image:(NSString *)imgStr target:(id)target action:(SEL)action{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (type == 0) {
        button.titleLabel.font = font;
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:textColor forState:UIControlStateNormal];
        button.backgroundColor = bgColor;
    }else{
        
        [button setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
    }
    
    if (target) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return button;
}

///给按钮添加富文本文字
+ (void)btn_addTitle:(NSString *)title textFont:(UIFont *)font textColor:(UIColor *)color forState:(UIControlState)state button:(UIButton *)button{
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    
    [button setAttributedTitle:attrString forState:state];
}


///父视图主动移除所有的子视图
+ (void)view_removeAllChildsViewFormSubView:(UIView *)subView{
    
    [subView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}


///添加横向的混合颜色
+ (void)view_addHybridBackgroundColorWithColorOne:(UIColor *)colorOne andColorTwo:(UIColor *)colorTwo showOnView:(UIView *)onView{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)colorOne.CGColor, (__bridge id)colorTwo.CGColor];
    gradientLayer.locations = @[@0.4, @0.7, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 1);
    gradientLayer.endPoint = CGPointMake(1.0, 1);
    gradientLayer.frame = CGRectMake(0, 0, onView.frame.size.width, onView.frame.size.height);
    
    [onView.layer addSublayer:gradientLayer];
}


///添加输入框
+ (UITextField *)view_createTextFieldWithPlaceholder:(NSString *)placeholderStr holderStrFont:(UIFont *)holderFont holderColor:(UIColor *)holderColor textFont:(UIFont *)textFont textColor:(UIColor *)textColor keyboardType:(UIKeyboardType)keyboardType returnKeyType:(UIReturnKeyType)returnKeyType{
    
    UITextField *tfield = [[UITextField alloc] init];
    tfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderStr attributes:@{NSFontAttributeName:holderFont,NSForegroundColorAttributeName:holderColor}];
    tfield.font = textFont;
    tfield.textColor = textColor;
    tfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    tfield.keyboardType = keyboardType;
    tfield.returnKeyType = returnKeyType;
    //监测输入变化
    //[tfield addTarget:self action:@selector(textFiledEditChanged:) forControlEvents:UIControlEventEditingChanged];
    
    return tfield;
}


///创建无限按钮模式
+ (NSMutableArray *)view_createManyBtnViewWithSpaceLeft:(CGFloat)spaceLeft spaceBetween:(CGFloat)spaceBetween spaceRight:(CGFloat)spaceRight spacetopBottom:(CGFloat)spaceTB spaceTop:(CGFloat)spaceTop btnWidth:(CGFloat)btnWidth btnHeight:(CGFloat)btnHeight btnCount:(NSInteger)btnCount{
    
    NSMutableArray *arrayBtn = [NSMutableArray array];
    
    for (int i = 0; i < btnCount; i++) {
        
        UIButton *btnBefore;//上一个按钮
        if (i > 0) {
            btnBefore = [arrayBtn lastObject];
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.tag = 1000 + i;
        //btn.backgroundColor = APPColor_White;
        
        if (btnBefore) {
            if ((CGRectGetMaxX(btnBefore.frame) + (spaceBetween + btnWidth) + spaceRight) > kScreenWidth) {
                //到下一行
                btn.frame = CGRectMake(spaceLeft, CGRectGetMaxY(btnBefore.frame) + spaceTB, btnWidth, btnHeight);
            }else{
                //同行
                btn.frame = CGRectMake(CGRectGetMaxX(btnBefore.frame) + spaceBetween, CGRectGetMinY(btnBefore.frame), btnWidth, btnHeight);
            }
            
        }else{
            //第一个按钮
            btn.frame = CGRectMake(spaceLeft + (btnWidth + spaceBetween)*i, spaceTop, btnWidth, btnHeight);
        }
        
        //[self addSubview:btn];
        
        [arrayBtn addObject:btn];
        
    }
    
    return arrayBtn;
}


#pragma mark - 16进制字符串与16进制之间的转换
//普通字符串转换为十六进制的。
+ (NSString *)hexStringFromString:(NSString *)string{
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
+ (NSString *)stringFromHexString:(NSString *)hexString {
    
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


#pragma mark - 打电话
+ (void)tell_phoneWithNum:(NSString *)phoneNum{
    
    NSString *callPhone = [NSString stringWithFormat:@"tel://%@",phoneNum];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
    } else {
        // Fallback on earlier versions
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
}


#pragma mark - post请求
///post请求一个字典
+ (void)postRequestNetDicDataUrl:(NSString *)url params:(NSDictionary *)params WithBlock:(void(^)(BOOL result, id idObject))block{
    
    [APPHttpTool postWithUrl:HTTPURL(url) params:params success:^(id response, NSInteger code) {
        
        //NSString *message = [response objectForKey:@"msg"];
        //id dataDic = [response objectForKey:@"data"];
        
        id dataDic = [response objectForKey:@"data"];
        
        if (code == 200) {
            //请求成功
            if (block) {
                block(YES,dataDic);
            }
        }else{
            // 错误处理
            //[weakSelf showMessage:message];
            if (block) {
                block(NO,response);
            }
        }
        
    } fail:^(NSError *error) {
        
        if (block) {
            block(NO,error);
        }
    }];
}

///get请求一个字典
+ (void)getRequestNetDicDataUrl:(NSString *)url params:(NSDictionary *)params WithBlock:(void(^)(BOOL result, id idObject))block{
    
    [APPHttpTool getWithUrl:HTTPURL(url) params:params success:^(id response, NSInteger code) {
        
        //NSString *message = [response objectForKey:@"msg"];
        //id dataDic = [response objectForKey:@"data"];
        
        id dataDic = [response objectForKey:@"data"];
        
        if (code == 200) {
            //请求成功
            if (block) {
                block(YES,dataDic);
            }
        }else{
            // 错误处理
            //[weakSelf showMessage:message];
            if (block) {
                block(NO,response);
            }
        }
        
    } fail:^(NSError *error) {
        
        if (block) {
            block(NO,error);
        }
    }];
}











@end

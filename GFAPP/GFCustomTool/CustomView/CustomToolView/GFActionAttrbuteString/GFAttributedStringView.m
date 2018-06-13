//
//  GFAttributedStringView.m
//  富文本触摸事件
//
//  Created by XinKun on 2017/4/16.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "GFAttributedStringView.h"
#import <CoreText/CoreText.h>

@implementation GFAttributedStringView
{

    CTFrameRef _frameRef;//CoreText画布
    
    NSString *_showString;
    
    NSString *_touchString;
    
    NSInteger _font;
    
    NSRange _touchRang;
    
    //触摸手势
    UITapGestureRecognizer *_tapGesture;
    
    NSRange _selectRange;

}

//添加手势
- (instancetype)initWithFrame:(CGRect)frame{

    if ([super initWithFrame:frame]) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnView:)];
        [self addGestureRecognizer:_tapGesture];
    }
    return self;
}

///触摸事件
- (void)tapOnView:(UITapGestureRecognizer *)tap{
    
    CGPoint touchpoint = [tap locationInView:self];
    
    [self parserRectWithPoint:touchpoint range:&_selectRange frameRef:_frameRef];
    
    //判断
    if (_selectRange.location>=_touchRang.location && _selectRange.location<=_touchRang.location+_touchRang.length) {
        
        NSString *string = [_showString substringWithRange:_selectRange];
        NSLog(@"触摸了：%@",string);
        
        //调用block 来 处理 触摸事件
        self.touchStringBlock();
    }
    
}


#pragma mark - 业务处理

/**
 * 设置显示文字 和 触摸文字
 *
 * 参数1：showString 展示文字
 *
 * 参数2：touchString 触摸文字
 */
- (void)setShowString:(NSString *)showString andTouchString:(NSString *)touchString andTextFont:(NSInteger)font{

    _showString = showString;
    _touchString = touchString;
    _font = font;
    
    //触摸范围
    _touchRang = [showString rangeOfString:touchString];
    
    //创建CTFrame 画布
    _frameRef = [self createCTFrame];
    

}

//创建画布
- (CTFrameRef)createCTFrame{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_showString];
    
    //设置属性（设置富文本）
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:_font]};
    [attributedString setAttributes:dic range:NSMakeRange(0, _showString.length)];
    
    CTFramesetterRef setterRef = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedString);
    //获取要绘制的区域信息
    CGPathRef pathRef = CGPathCreateWithRect(self.bounds, NULL);
    CTFrameRef frameRef = CTFramesetterCreateFrame(setterRef, CFRangeMake(0, 0), pathRef, NULL);
    
    CFRelease(setterRef);
    CFRelease(pathRef);
    
    return frameRef;
}


-(void)drawRect:(CGRect)rect{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //没有图片就 用 原来 方法 绘制文字
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    CTFrameDraw(_frameRef, ctx); //原有的文字界面
}


- (void)parserRectWithPoint:(CGPoint)point range:(NSRange *)selectRange frameRef:(CTFrameRef)frameRef{
    CFIndex index = -1;
    CGPathRef pathRef = CTFrameGetPath(frameRef);
    CGRect bounds = CGPathGetBoundingBox(pathRef);
    CGRect rect = CGRectZero;
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frameRef);
    if (!lines) {
        return ;
    }
    NSInteger lineCount = [lines count];
    
    CGPoint *origins = malloc(lineCount * sizeof(CGPoint));
    if (lineCount) {
        CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), origins);
        for (int i = 0; i<lineCount; i++) {
            CGPoint baselineOrigin = origins[i];
            CTLineRef line = (__bridge CTLineRef)[lines objectAtIndex:i];
            CGFloat ascent,descent,linegap;
            CGFloat lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, &linegap);
            CGRect lineFrame = CGRectMake(baselineOrigin.x, CGRectGetHeight(bounds)-baselineOrigin.y-ascent, lineWidth, ascent+descent+linegap);
            if (CGRectContainsPoint(lineFrame,point)){
                CFRange stringRange = CTLineGetStringRange(line);
                index = CTLineGetStringIndexForPosition(line, point);
                CGFloat xStart = CTLineGetOffsetForStringIndex(line, index, NULL);
                CGFloat xEnd;
                if (index > stringRange.location+stringRange.length-2) {
                    xEnd = xStart;
                    xStart = CTLineGetOffsetForStringIndex(line,index-2,NULL);
                    (*selectRange).location = index-2;
                }
                else{
                    xEnd = CTLineGetOffsetForStringIndex(line,index+2,NULL);
                    (*selectRange).location = index;
                }
                
                (*selectRange).length = 2;
                rect = CGRectMake((origins[i].x+xStart),(baselineOrigin.y-descent),fabs(xStart-xEnd), ascent+descent);
                
                break;
            }
        }
    }
    free(origins);
}

@end

//
//  GFDrawPicture.m
//  GFAPP
//
//  Created by gaoyafeng on 2018/7/5.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "GFDrawPicture.h"

@implementation GFDrawPicture
{
    //保存绘制的每一条线
    NSMutableArray *_pathsArray;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _pathsArray = [NSMutableArray array];
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        _pathsArray = [NSMutableArray array];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    
    //贝塞尔曲线
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    //指定线的起点
    [path moveToPoint:point];
    
    //把线加入数组里面
    [_pathsArray addObject:path];
    
    //让UIView重新绘制当前页面
    [self setNeedsDisplay];
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    
    UIBezierPath *path = _pathsArray.lastObject;
    
    //把点加到线上
    [path addLineToPoint:point];
    
    //每走一点重新绘制视图
    [self setNeedsDisplay];
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //把最后一点加到线上
    [self touchesMoved:touches withEvent:event];
    
}

//在这个方法里面可以重新绘制当前页面
- (void)drawRect:(CGRect)rect{
    
    for (UIBezierPath *path in _pathsArray) {
        
        //设置填充色
        //        UIColor *yellowColor = [UIColor yellowColor];
        //        [yellowColor set];
        //        [path fill];
        
        
        //指定线的颜色
        UIColor *color = _lineColor ? _lineColor : [UIColor blackColor];
        [color set];
        
        path.lineWidth = _lineWidth > 0 ? _lineWidth : 2;
        
        //划线,让线显示到图层
        [path stroke];//如果修改最后一句代码将[path stroke]改成[path fill];——————>则是线条之间的填充
        
        /**
        // 设置描边宽度（为了让描边看上去更清楚）
        [path setLineWidth:5.0];
        //设置颜色（颜色设置也可以放在最上面，只要在绘制前都可以）
        [[UIColor blueColor] setStroke];
        [[UIColor redColor] setFill];
        // 描边和填充
        [path stroke];
        [path fill];
         */
    }
}

//返回
- (void)back{
    
    //移除最后一条线
    [_pathsArray removeLastObject];
    
    //drawRect 这个方法不可以手动调用,只能系统调用,调用setNeedsDisplay方法,系统会自动调用drawRect
    [self setNeedsDisplay];
    
}

//清空
- (void)clear{
    
    [_pathsArray removeAllObjects];
    [self setNeedsDisplay];
}


///把当前绘制的图形生成图片
- (UIImage *)getImageFormCurrentView{
    
    //开启绘制图片的图层上下文
    UIGraphicsBeginImageContext(self.frame.size);
    
    //把view的图层绘制到当前绘制图片的图层
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    //从当前上下文中获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭绘制图片的图层的上下文
    UIGraphicsEndImageContext();
    
    return image;
}






@end

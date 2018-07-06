//
//  WBPopOverView.m
//  Lawpress
//
//  Created by 彬万 on 16/7/26.
//  Copyright © 2016年 彬万. All rights reserved.
//

#import "WBPopOverView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
static const CGFloat spacing = 7.;

@interface WBPopOverView ()


@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) WBArrowDirection direction;

@end

@implementation WBPopOverView

-(instancetype)initWithOrigin:(CGPoint)origin Width:(CGFloat)width Height:(float)height Direction:(WBArrowDirection)direction
{
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)])
    {
        //背景颜色为无色
        self.backgroundColor=[UIColor clearColor];
        
        //定义显示视图的参数
        self.origin = origin;
        self.height = height;
        self.width = width;
        self.direction = direction;
        
        self.backView=[[UIView alloc]initWithFrame:CGRectMake(origin.x, origin.y, width, height)];
//        self.backView.backgroundColor=[UIColor colorWithWhite:.spacing alpha:1];
        //66,81,98
        self.backView.backgroundColor = [UIColor colorWithRed:66/255. green:81/255. blue:98/255. alpha:.95];
        [self addSubview:self.backView];
      
    
    }

    return self;
}


-(void)drawRect:(CGRect)rect
{
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    if (_direction==WBArrowDirectionLeft1) {
        
        
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX+spacing, startY-spacing);
        CGContextAddLineToPoint(context, startX+spacing, startY+spacing);
    }
    else if (_direction==WBArrowDirectionLeft2)
    {
    
        
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX+spacing, startY-spacing);
        CGContextAddLineToPoint(context, startX+spacing, startY+spacing);
    
    }
    else if (_direction==WBArrowDirectionLeft3)
    {

        
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX+spacing, startY-spacing);
        CGContextAddLineToPoint(context, startX+spacing, startY+spacing);
        
    }
    else if (_direction==WBArrowDirectionRight1)
    {
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX-spacing, startY-spacing);
        CGContextAddLineToPoint(context, startX-spacing, startY+spacing);
        
    }
    else if (_direction==WBArrowDirectionRight2)
    {
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX-spacing, startY-spacing);
        CGContextAddLineToPoint(context, startX-spacing, startY+spacing);
        
    }
    else if (_direction==WBArrowDirectionRight3)
    {
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX-spacing, startY-spacing);
        CGContextAddLineToPoint(context, startX-spacing, startY+spacing);
        
    }
    else if (_direction==WBArrowDirectionUp1)
    {
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX + spacing, startY + spacing);
        CGContextAddLineToPoint(context, startX - spacing, startY+spacing);
        
    }
    else if (_direction==WBArrowDirectionUp2)
    {
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX + spacing, startY + spacing);
        CGContextAddLineToPoint(context, startX - spacing, startY+spacing);
    }
    else if (_direction==WBArrowDirectionUp3)
    {
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX + spacing, startY + spacing);
        CGContextAddLineToPoint(context, startX - spacing, startY+spacing);
        
    }
    else if (_direction==WBArrowDirectionDown1)
    {
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX - spacing, startY - spacing);
        CGContextAddLineToPoint(context, startX + spacing, startY-spacing);
        
    }
    else if (_direction==WBArrowDirectionDown2)
    {
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX - spacing, startY - spacing);
        CGContextAddLineToPoint(context, startX + spacing, startY-spacing);
        
    }
    else if (_direction==WBArrowDirectionDown3)
    {
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX - spacing, startY - spacing);
        CGContextAddLineToPoint(context, startX + spacing, startY-spacing);
        
    }
   
    CGContextClosePath(context);
    [self.backView.backgroundColor setFill];
    [self.backgroundColor setStroke];
    CGContextDrawPath(context, kCGPathFillStroke);
    
    self.backView.layer.cornerRadius = 8;
    self.backView.layer.masksToBounds = YES;
    


}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (![touch.view isEqual:self.backView]) {
        [self dismiss];
    }
}

-(void)popView
{
    NSArray *result=[self.backView subviews];
    for (UIView *view in result) {
        
        view.hidden=YES;
        
    }
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    //动画效果弹出
    self.alpha = 0;
    
    
    if (_direction==WBArrowDirectionLeft1) {
        self.backView.frame = CGRectMake(self.origin.x+spacing, self.origin.y, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.backView.frame = CGRectMake(self.origin.x+spacing, self.origin.y-20, self.width,self. height);
        }completion:^(BOOL finished) {
            NSArray *result=[self.backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
        }];
        
        
    }
    else if (_direction==WBArrowDirectionLeft2)
    {
        self.backView.frame = CGRectMake(self.origin.x+spacing, self.origin.y, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.backView.frame = CGRectMake(self.origin.x+spacing, self.origin.y-self.height/2, self.width,self. height);

        }completion:^(BOOL finished) {
            NSArray *result=[self.backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
        }];
    }
    else if (_direction==WBArrowDirectionLeft3)
    {
        self.backView.frame = CGRectMake(self.origin.x+spacing, self.origin.y, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.backView.frame = CGRectMake(self.origin.x+spacing, self.origin.y-self.height+20, self.width,self. height);
        }completion:^(BOOL finished) {
            NSArray *result=[self.backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
        }];
        
    }
    else if (_direction==WBArrowDirectionRight1)
    {
        self.backView.frame = CGRectMake(self.origin.x-spacing, self.origin.y, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.backView.frame = CGRectMake(self.origin.x-spacing, self.origin.y-20, -self.width,self. height);
        }completion:^(BOOL finished) {
            
            NSArray *result=[self.backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
            
        }];
        
    }
    else if (_direction==WBArrowDirectionRight2)
    {
        self.backView.frame = CGRectMake(self.origin.x-spacing, self.origin.y, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.backView.frame = CGRectMake(self.origin.x-spacing, self.origin.y-self.height/2, -self.width,self. height);
        }completion:^(BOOL finished) {
            
            NSArray *result=[self.backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
            
        }];
        
    }
    else if (_direction==WBArrowDirectionRight3)
    {
        self.backView.frame = CGRectMake(self.origin.x-spacing, self.origin.y, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.backView.frame = CGRectMake(self.origin.x-spacing, self.origin.y-self.height+20, -self.width,self. height);
        }completion:^(BOOL finished) {
            
            NSArray *result=[self.backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
            
        }];
        
    }
    else if (_direction==WBArrowDirectionUp1)
    {
        self.backView.frame = CGRectMake(self.origin.x, self.origin.y+spacing, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.backView.frame = CGRectMake(self.origin.x-20, self.origin.y+spacing, self.width,self. height);
        }completion:^(BOOL finished) {
            
            NSArray *result=[self.backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
            
        }];
        
    }
    else if (_direction==WBArrowDirectionUp2)
    {
        self.backView.frame = CGRectMake(self.origin.x, self.origin.y+spacing, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.backView.frame = CGRectMake(self.origin.x-self.width/2, self.origin.y+spacing, self.width,self. height);
        }completion:^(BOOL finished) {
            
            NSArray *result=[self.backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
            
        }];
        
    }
    else if (_direction==WBArrowDirectionUp3)
    {
        self.backView.frame = CGRectMake(self.origin.x, self.origin.y+spacing, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.backView.frame = CGRectMake(self.origin.x+20, self.origin.y+spacing, -self.width,self. height);
        }completion:^(BOOL finished) {
            
            NSArray *result=[self.backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
            
        }];
        
    }
    else if (_direction==WBArrowDirectionDown1)
    {
        self.backView.frame = CGRectMake(self.origin.x, self.origin.y-spacing, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.backView.frame = CGRectMake(self.origin.x-20, self.origin.y-spacing, self.width,-self. height);
        }completion:^(BOOL finished) {
            
            NSArray *result=[self.backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
            
        }];
        
    }
    else if (_direction==WBArrowDirectionDown2)
    {
        self.backView.frame = CGRectMake(self.origin.x, self.origin.y-spacing, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.backView.frame = CGRectMake(self.origin.x-self.width/2, self.origin.y-spacing, self.width,-self. height);
        }completion:^(BOOL finished) {
            
            NSArray *result=[self.backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
            
        }];
        
    }
    else if (_direction==WBArrowDirectionDown3)
    {
        self.backView.frame = CGRectMake(self.origin.x, self.origin.y-spacing, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.backView.frame = CGRectMake(self.origin.x-self.width+20, self.origin.y-spacing, self.width,-self. height);
        }completion:^(BOOL finished) {
            
            NSArray *result=[self.backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
            
        }];
        
    }

}

-(void)dismiss{
    
    NSArray *result=[self.backView subviews];
    for (UIView *view in result) {
        
        [view removeFromSuperview];

    }
         //动画效果淡出
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        self.backView.frame = CGRectMake(self.origin.x, self.origin.y, 0, 0);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
                 
        }
    }];
     


}

@end


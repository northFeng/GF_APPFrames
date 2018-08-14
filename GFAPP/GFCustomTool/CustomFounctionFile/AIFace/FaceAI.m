//
//  FaceAI.m
//  GFAPP
//
//  Created by gaoyafeng on 2018/8/14.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "FaceAI.h"

@implementation FaceAI

-(instancetype)initWithTouchID_Block:(void(^)(touchIDENUM))a
{
    if (self=[super init]) {
        
        self.touchIDBlock=a;
        
        [self createTouchID];
    }
    return self;
}
-(void)createTouchID{
    //判断版本
    if ([[UIDevice currentDevice].systemVersion floatValue]<8.0) {
        if (self.touchIDBlock) {
            self.touchIDBlock(touchIDDeviceError);
        }
        return;
    }
    
    
    //创建touchID功能
    LAContext*context=[[LAContext alloc]init];
    NSError*error=nil;
    //判断是否能启动指纹功能
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //启动指纹验证
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请验证指纹" reply:^(BOOL success, NSError *error) {
            //由于本身验证touchID是一个弹框，所以在这里我们是无法在启动一个弹框的
            if (success) {
                //                NSLog(@"指纹验证成功");
                if (self.touchIDBlock) {
                    self.touchIDBlock(touchIDCheckSucceed);
                }
            }else{
                switch (error.code) {
                    case -2:
                        //                        NSLog(@"点击的取消");
                        if (self.touchIDBlock) {
                            self.touchIDBlock(touchIDCheCkCancel);
                        }
                        break;
                    case -3:
                        //                        NSLog(@"手动输入密码");
                        if (self.touchIDBlock) {
                            self.touchIDBlock(touchIDCheckPassWord);
                        }
                        
                    default:
                        break;
                }
            }
            
            
        }];
    }else{
        if (self.touchIDBlock) {
            self.touchIDBlock(touchIDDeviceError);
        }
        
        
    }
    
}


-(instancetype)initWithFaceDetectWithImageView:(UIImageView*)headerImageView Block:(void(^)(BOOL,NSArray*))b{
    if (self=[super init]) {
        
        self.faceDetectBlock = b;
        self.headerImageView = headerImageView;
        NSLog(@"%f~~%f",self.headerImageView.image.size.width,self.headerImageView.image.size.height);
        
        [self createFaceDetect];
    }
    return self;
}
-(void)createFaceDetect{
    if (self.headerImageView==nil) {
        self.faceDetectBlock=nil;
        return;
    }
    //先缩减image到预定尺寸
    //计算尺寸横向还是纵向缩放
    UIGraphicsBeginImageContext(CGSizeMake(self.headerImageView.bounds.size.width , self.headerImageView.bounds.size.height));
    [self.headerImageView.image drawInRect:CGRectMake(0, 0, self.headerImageView.bounds.size.width, self.headerImageView.bounds.size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.headerImageView.image=scaledImage;
    
    
    //识别
    //因为识别需要时间，所以需要进行异步操作
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        
        CIImage* image = [CIImage imageWithCGImage:self.headerImageView.image.CGImage];
        
        //设置探测器的配置要求
        //此处是CIDetectorAccuracyHigh，若用于real-time的人脸检测，则用CIDetectorAccuracyLow，更快
        NSDictionary  *opts = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh
                                                          forKey:CIDetectorAccuracy];
        
        // 创建图形上下文
        //CIContext * context = [CIContext contextWithOptions:nil];
        
        //据说可以识别二维码~
        CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                                  context:nil
                                                  options:opts];
        
        //识别，直接返回结果，但是整个识别过程是同步，所以我们让他整个在异步中进行
        NSArray *features = [detector featuresInImage:image];
        
        //里面的人头个数，识别出一个头 数组中元素就一个
        if ([features count]==0) {
            //            NSLog(@">>>>> 人脸监测【失败】啦 ～！！！");
            //回归主线程刷新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.faceDetectBlock) {
                    self.faceDetectBlock(NO,features);
                }
            });
            
            
        }else{
            //        NSLog(@">>>>> 人脸监测【成功】～！！！>>>>>> ");
            //遍历位置
            NSMutableArray *detectArray=[NSMutableArray arrayWithCapacity:10];
            for (CIFaceFeature *f in features)
            {
                FaceInfoModel *model=[[FaceInfoModel alloc]init];
                //检测表情
                model.isSmile = f.hasSmile;
                model.isLeftEyeClosed = f.leftEyeClosed;
                model.isRightEyeClosed = f.rightEyeClosed;
                
                //旋转180，仅y
                CGRect aRect = f.bounds;
                aRect.origin.y = self.headerImageView.bounds.size.height - aRect.size.height - aRect.origin.y;
                model.faceFrameString = NSStringFromCGRect(aRect);
                
                //识别左眼
                if (f.hasLeftEyePosition){
                    //旋转180，仅y
                    CGPoint newCenter =  f.leftEyePosition;
                    newCenter.y = self.headerImageView.bounds.size.height - newCenter.y;
                    
                    
                    
                    model.leftEyePointString = NSStringFromCGPoint(newCenter);
                }
                //识别右眼
                if (f.hasRightEyePosition)
                {
                    //旋转180，仅y
                    CGPoint newCenter =  f.rightEyePosition;
                    newCenter.y = self.headerImageView.bounds.size.height-newCenter.y;
                    model.rightEyePointString = NSStringFromCGPoint(newCenter);
                }
                //识别嘴
                if (f.hasMouthPosition)
                {
                    //旋转180，仅y
                    CGPoint newCenter =  f.mouthPosition;
                    newCenter.y = self.headerImageView.bounds.size.height-newCenter.y;
                    model.mouthPointString = NSStringFromCGPoint(newCenter);
                    
                }
                //把坐标模型追加到数组中，通过block回调
                [detectArray addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.faceDetectBlock) {
                    self.faceDetectBlock(YES,detectArray);
                }
            });
        }
        
        
        
        
    });
    
    
}


@end

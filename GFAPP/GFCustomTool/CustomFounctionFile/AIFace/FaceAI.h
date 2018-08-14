//
//  FaceAI.h
//  GFAPP
//  识别图片上人脸各部位位置识别 && 可识别多张人脸
//  Created by gaoyafeng on 2018/8/14.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <LocalAuthentication/LocalAuthentication.h>
#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>

#import "FaceInfoModel.h"//存储面部信息

typedef enum : NSUInteger {
    touchIDDeviceError=0,
    touchIDCheckSucceed,
    touchIDCheCkCancel,
    touchIDCheckPassWord
} touchIDENUM;

@interface FaceAI : NSObject


//指纹block
@property(nonatomic,copy)void(^touchIDBlock)(touchIDENUM);
//人脸识别block
@property(nonatomic,copy)void(^faceDetectBlock)(BOOL,NSArray*);
//人脸识别的imageView
@property(nonatomic,assign)UIImageView *headerImageView;

//iOS8  指纹验证
-(instancetype)initWithTouchID_Block:(void(^)(touchIDENUM))a;

//iOS7  图像识别
-(instancetype)initWithFaceDetectWithImageView:(UIImageView*)headerImageView Block:(void(^)(BOOL,NSArray*))b;

@end


/** 用法
 
//给我一张图片,识别图片中的人脸
- (void)recogniceFaceWithImage:(UIImageView *)imageView{
    
    for (UIView *view in imageView.subviews) {
        [view removeFromSuperview];
    }
    
    FaceTools *tools = [[FaceTools alloc] initWithFaceDetectWithImageView:imageView Block:^(BOOL success, NSArray * array) {
        if (success==YES) {
            NSLog(@"识别成功");
            for (FaceDetectModel *model in array) {
                //左眼
                UIView *leftEye = [[UIView alloc] init];
                leftEye.frame = CGRectMake(0, 0, 10, 10);
                leftEye.center = CGPointFromString(model.leftEyePointString);
                leftEye.backgroundColor = [UIColor greenColor];
                leftEye.alpha = 0.5;
                [_imageView addSubview:leftEye];
                
                //右眼
                UIView *rightEye = [[UIView alloc] init];
                rightEye.frame = CGRectMake(0, 0, 10, 10);
                rightEye.center = CGPointFromString(model.rightEyePointString);
                rightEye.backgroundColor = [UIColor greenColor];
                rightEye.alpha = 0.5;
                [_imageView addSubview:rightEye];
                
                
                //嘴巴
                //左眼
                UIView *mouth = [[UIView alloc] init];
                mouth.frame = CGRectMake(0, 0, 10, 10);
                mouth.center = CGPointFromString(model.mouthPointString);
                mouth.backgroundColor = [UIColor redColor];
                mouth.alpha = 0.5;
                [_imageView addSubview:mouth];
                
                
                //脸
                UIView *face = [[UIView alloc] init];
                face.frame = CGRectMake(0, 0, 10, 10);
                face.frame = CGRectFromString(model.faceFrameString);
                face.backgroundColor = [UIColor greenColor];
                face.alpha = 0.3;
                [_imageView addSubview:face];
                
            }
            
        }else{
            NSLog(@"识别失败");
        }
    }];
    
}

 */










//
//  FaceInfoModel.h
//  GFAPP
//
//  Created by gaoyafeng on 2018/8/14.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FaceInfoModel : NSObject

//人脸位置
@property(nonatomic,copy)NSString*faceFrameString;

//左眼位置
@property(nonatomic,copy)NSString*leftEyePointString;

//右眼位置
@property(nonatomic,copy)NSString*rightEyePointString;

//嘴巴位置
@property(nonatomic,copy)NSString*mouthPointString;

//是否微笑
@property(nonatomic)BOOL isSmile;

//左眼是否闭眼
@property(nonatomic)BOOL isLeftEyeClosed;

//右眼是否闭眼
@property(nonatomic)BOOL isRightEyeClosed;

@end

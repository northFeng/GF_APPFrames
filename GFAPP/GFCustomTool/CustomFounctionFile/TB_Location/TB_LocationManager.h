//
//  TB_LocationManager.h
//  WealthBorrowed
//
//  Created by 斑马 on 2017/9/12.
//  Copyright © 2017年 斑马. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TB_LocationManager : NSObject

@property (nonatomic,copy) NSString * locationstar;      //记录地址
@property (nonatomic,copy) NSString * lislocation;       //授权状态

+ (instancetype)TB_ShareLocation;


/**
 YES 开启定位 NO 没有

 */
-(BOOL)TB_ChargeIslocation;


/**
 开始定位服务
 */
-(void)TB_StartRequstLocation;

@end

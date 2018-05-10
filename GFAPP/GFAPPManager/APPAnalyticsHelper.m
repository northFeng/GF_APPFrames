//
//  APPAnalyticsHelper.m
//  GFAPP
//
//  Created by gaoyafeng on 2018/5/10.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "APPAnalyticsHelper.h"

//输入跟踪日志框架
#import "Aspects.h"

@implementation APPAnalyticsHelper

+ (void)analyticsViewController {
    //放到异步线程去执行
    //__weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //Aspect only debug
        //面向切面，用于界面日志的输出
        [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:0 usingBlock:^(id<AspectInfo> info){
            NSLog(@"ViewContriller Enter \n ==================> \n %@", info.instance);
        } error:NULL];
        [UIViewController aspect_hookSelector:@selector(viewWillDisappear:) withOptions:0 usingBlock:^(id<AspectInfo> info){
            NSLog(@"ViewContriller Exit \n ==================> \n %@", info.instance);
        } error:NULL];
        [UIViewController aspect_hookSelector:@selector(didReceiveMemoryWarning) withOptions:0 usingBlock:^(id<AspectInfo> info){
            NSLog(@"ViewContriller didReceiveMemoryWarning \n ==================> \n %@", info.instance);
        } error:NULL];
    });
}

/**
+ (void)beginLogPageView:(__unsafe_unretained Class)pageView {
    [MobClick beginLogPageView:NSStringFromClass(pageView)];
}

+ (void)endLogPageView:(__unsafe_unretained Class)pageView {
    [MobClick endLogPageView:NSStringFromClass(pageView)];
}

+ (void)beginLogPageViewName:(NSString *)pageViewName {
    [MobClick beginLogPageView:pageViewName];
}

+ (void)endLogPageViewName:(NSString *)pageViewName {
    [MobClick endLogPageView:pageViewName];
}

+ (void)logEvent:(NSString*)eventId {
    [MobClick event:eventId];
}

+ (void)logEvent:(NSString*)eventId attributes:(NSDictionary *)attributes {
    [MobClick event:eventId attributes:attributes];
}

#pragma mark 自定义代码区

+ (BOOL)fileterWithControllerName:(NSString *)controllerName {
    BOOL result = NO;
    
    HSAnalyticsConfigManager *configManager = [HSAnalyticsConfigManager sharedInstance];
    if (configManager.prefixFilterArray.count == 0
        && configManager.noFileterNameArray.count == 0
        && configManager.fileterNameArray.count==0) {
        return YES;
    }
    
    //判断是否在符合前缀里面
    if (configManager.prefixFilterArray) {
        for (NSString *prefixItem in configManager.prefixFilterArray) {
            if ([controllerName hasPrefix:prefixItem]) {
                result = YES;
                break;
            }
        }
    }
    //若有符合前缀则执行下面的内容 再进行判断当前页面是否要被省略掉的页面
    if (result) {
        if ([configManager.noFileterNameArray containsObject:controllerName]) {
            result = NO;
        }
    } else {
        if ([configManager.fileterNameArray containsObject:controllerName]) {
            result = YES;
        }
    }
    
    return result;
}
 */


@end

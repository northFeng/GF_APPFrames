//
//  FSAnalyticsHelper.m
//  FlashSend
//
//  Created by gaoyafeng on 2018/8/24.
//  Copyright © 2018年 ishansong. All rights reserved.
//

#import "FSAnalyticsHelper.h"

//输入跟踪日志框架
#import "Aspects.h"

#import <IQKeyboardManager/IQKeyboardManager.h>//键盘框架


// 引入神策分析 SDK
#import "SensorsAnalyticsSDK.h"

// 神策数据接收的 URL
#define SA_SERVER_URL @"https://ebizdemo.datasink.sensorsdata.cn/sa?project=default&token=******"



@implementation FSAnalyticsHelper


+ (void)analyticsViewController {
    //放到异步线程去执行
    //__weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //Aspect only debug
        //面向切面，用于界面日志的输出
        [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:0 usingBlock:^(id<AspectInfo> info){
            NSLog(@"ViewContriller Enter ==================> %@", info.instance);
        } error:NULL];
        [UIViewController aspect_hookSelector:@selector(viewWillDisappear:) withOptions:0 usingBlock:^(id<AspectInfo> info){
            NSLog(@"ViewContriller Exit  ==================> %@", info.instance);
        } error:NULL];
        [UIViewController aspect_hookSelector:@selector(didReceiveMemoryWarning) withOptions:0 usingBlock:^(id<AspectInfo> info){
            NSLog(@"ViewContriller didReceiveMemoryWarning  ==================>  %@", info.instance);
        } error:NULL];
    });
}


///设置键盘弹出
+ (void)setKeyBoardlayout{
    
    //******** 系统键盘做处理 ********
    //默认为YES，关闭为NO
    [IQKeyboardManager sharedManager].enable = YES;
    //键盘弹出时，点击背景，键盘收回
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    //隐藏键盘上面的toolBar,默认是开启的
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
    
}


#pragma mark - ************************ 神策数据 ****************************
///添加神策统计
+ (void)addSCDataStatisticalWithDic:(NSDictionary *)launchOptions{
    
    //http://ebizdemo.datasink.sensorsdata.cn/sa?project=default&token=******
    //https://ebizdemo.datasink.sensorsdata.cn/sa?project=default&token=******
    
    //sadc8bd42d
    // 初始化 SDK
    /**
    * Debug模式有三种选项:
    *   SensorsAnalyticsDebugOff - 关闭DEBUG模式
    *   SensorsAnalyticsDebugOnly - 打开DEBUG模式，但该模式下发送的数据仅用于调试，不进行数据导入
    *   SensorsAnalyticsDebugAndTrack - 打开DEBUG模式，并将数据导入到SensorsAnalytics中
     */
    SensorsAnalyticsDebugMode analyticsMode = SensorsAnalyticsDebugOff;
    
#if DEBUG
    analyticsMode = SensorsAnalyticsDebugOnly;
#endif
    
    [SensorsAnalyticsSDK sharedInstanceWithServerURL:SA_SERVER_URL
                                    andLaunchOptions:launchOptions
                                        andDebugMode:analyticsMode];
    
    [[SensorsAnalyticsSDK sharedInstance] enableTrackScreenOrientation:YES]; // CoreMotion 采集屏幕方向
    [[SensorsAnalyticsSDK sharedInstance] enableTrackGPSLocation:YES];// CoreLocation 采集 GPS 信息
    
    // 打开自动采集, 并指定追踪哪些 AutoTrack 事件
    /**
     SensorsAnalyticsEventTypeAppStart :App 启动或从后台恢复时，会自动记录 $AppStart 事件，事件属性
     SensorsAnalyticsEventTypeAppEnd   :App 进入后台时，会自动记录 $AppEnd 事件事件属性:event_duration - Int 类型，表示本次 App 启动的使用时长，单位为秒
     SensorsAnalyticsEventTypeAppClick :点击控件(继承于 UIControl 的控件)时，会发送 $AppClick 事件(控件类型、控件文本)
     SensorsAnalyticsEventTypeAppViewScreen :App 浏览页面时（切换 ViewController），会自动记录记录
     */
    [[SensorsAnalyticsSDK sharedInstance] enableAutoTrack:SensorsAnalyticsEventTypeAppStart |
                                                          SensorsAnalyticsEventTypeAppEnd |
                                                          SensorsAnalyticsEventTypeAppViewScreen |
                                                          SensorsAnalyticsEventTypeAppClick];
    
    /**
      默认属性
     神策分析 SDK 会自动收集 App 版本、网络状态、IP、设备型号等一系列系统信息作为事件属性，详细的默认属性列表请参考文档 数据格式。
     */
    
    /**
      事件公共属性
     将'平台类型'作为事件公共属性，后续所有 track: 追踪的事件都将设置 "PlatformType" 属性，且属性值为 "iOS"
     成功设置事件公共属性后，再通过 track: 追踪事件时，事件公共属性会被添加进每个事件中
     */
    //[[SensorsAnalyticsSDK sharedInstance] registerSuperProperties:@{@"PlatformType" : @"iOS"}];
    
}



/// 自定义事件
+ (void)logEvent:(NSString*)eventId{
    
    ///只统计事件
    [[SensorsAnalyticsSDK sharedInstance] track:eventId];
}

///统计事件 + 属性
+ (void)logEvent:(NSString*)eventId attributes:(NSDictionary *)attributes{
    
    //记录浏览商品事件，并将商品ID、商品类别和是否被添加进收藏夹作为事件属性上传
    if (attributes == nil) {
        [[SensorsAnalyticsSDK sharedInstance] track:eventId];
    }else{
        [[SensorsAnalyticsSDK sharedInstance] track:eventId withProperties:attributes];
    }
    
    /**
     默认的 flushBulkSize 为 100 条，默认的 flushInterval 为 15 秒。满足条件后，神策分析 gzip 压缩后，批量发送到神策分析。
     如果追求数据采集的时效性，可以调用 flush 方法，强制将数据发送到神策分析
     强制发送数据
     */
    //[[SensorsAnalyticsSDK sharedInstance] flush];
}


///事件开始
+ (void)logEventTimeLengthWithBegin:(NSString *)eventViewId{
    
    // 进入页面，标记 ViewProduct 事件的启动时间
    [[SensorsAnalyticsSDK sharedInstance] trackTimerStart:eventViewId];
}

///事件结束
+ (void)logEventTimeLengthWithEnd:(NSString *)eventViewId{
    
    // 离开页面，记录 ViewProduct 事件，并在属性 event_duration 中记录用户浏览页面的时间
    [[SensorsAnalyticsSDK sharedInstance] trackTimerEnd:eventViewId];
}

///事件结束 && 属性
+ (void)logEventTimeLengthWithEnd:(NSString *)eventViewId attributes:(NSDictionary *)attributes{
    
    // 离开页面，记录 ViewProduct 事件，并在属性 event_duration 中记录用户浏览页面的时间
    if (attributes == nil) {
        [[SensorsAnalyticsSDK sharedInstance] trackTimerEnd:eventViewId];
    }else{
        [[SensorsAnalyticsSDK sharedInstance] trackTimerEnd:eventViewId withProperties:attributes];
    }
    
    //强制发送数据
    //[[SensorsAnalyticsSDK sharedInstance] flush];
}


///获取匿名ID
+ (NSString *)loginGetSCId{
    
    /**
     pod 'SensorsAnalyticsSDK', :subspecs => ['IDFA'] ——> SDK 尝试获取 IDFA 作为匿名 ID
     如果获取 IDFV 失败，则会生成 UUID 作为匿名 ID
     */
    //获取当前用户的匿名id
    NSString *anonymousId = [[SensorsAnalyticsSDK sharedInstance] anonymousId];
    
    /**
    //替换默认匿名id
    // 替换默认匿名 ID: '9771C579-71F0-4650-8EE8-8999FA717761'
    [[SensorsAnalyticsSDK sharedInstance] identify:@"9771C579-71F0-4650-8EE8-8999FA717761"];
     */
    
    return anonymousId;
}

///用户注册——>关联 DistinctId(匿名 ID)
+ (void)loginEventWithUserId:(NSString *)userId{
    
    // 记录用户打开首页，此时的 DistinctId 为神策分析 SDK 随机分配的 ID，例如 IDFV: "9771C579-71F0-4650-8EE8-8999FA717761"
    // 这只是一个示例，用户可根据实际需求添加事件
    //[[SensorsAnalyticsSDK sharedInstance] track:@"ViewHomepage"];
    
    // 关联 DistinctId(匿名 ID)，神策分析将 "9771C579-71F0-4650-8EE8-8999FA717761" 与 "developer@sensorsdata.cn" 关联，并认为两个 DistinctId 为同一个用户
    [[SensorsAnalyticsSDK sharedInstance] login:userId];
    
    // 记录用户打开商品详情页，此时被追踪的事件的 DistinctId 为 "developer@sensorsdata.cn"
    // 这只是一个示例，用户可根据实际需求添加事件
    //[[SensorsAnalyticsSDK sharedInstance] track:@"ProductDetailView"];
}


///设置用户属性
+ (void)loginUserInfoWithDic:(NSDictionary *)attributes{
    
    // 设定用户年龄属性 "Age" 为 18
    // `set:` 方法设定一个或多个用户属性
    //[[[SensorsAnalyticsSDK sharedInstance] people] set:@{@"Age" : [NSNumber numberWithInt:18]}];
    [[[SensorsAnalyticsSDK sharedInstance] people] set:attributes];
    
    /**
     记录初次设定的属性
     
     设定用户渠道为，"developer@sensorsdata.cn" 的 "AdSource" 属性值为 "App Store"
     [[[SensorsAnalyticsSDK sharedInstance] people] setOnce:@"AdSource" to:@"App Store"];
     
     // 再次设定用户渠道，设定无效，"developer@sensorsdata.cn" 的 "AdSource" 属性值仍然是 "App Store"
     [[[SensorsAnalyticsSDK sharedInstance] people] setOnce:@"AdSource" to:@"Email"];
     */
}


///数值类型的属性累加
+ (void)loginNumTypeCumulativeWithDic:(NSDictionary *)attributes{
    
    // 将用户游戏次数属性增加一次
    // `increment:by:` 对一个属性进行累加
    //[[[SensorsAnalyticsSDK sharedInstance] people] increment:@"GamePlayed" by:[NSNumber numberWithInt:1]];
    
    // 增加用户付费次数和积分
    // `increment:` 对一个或多个属性进行累加
    /**
    [[[SensorsAnalyticsSDK sharedInstance] people] increment:@{
                                                               @"UserPaid" : [NSNumber numberWithInt:1],
                                                               @"PointEarned" : [NSNumber numberWithFloat:12.5]
                                                               }];
     */
    
    [[[SensorsAnalyticsSDK sharedInstance] people] increment:attributes];
}

///统计webView
+ (BOOL)loginWebViewWithWebView:(id)webView request:(NSURLRequest *)request attributes:(NSDictionary *)attributes{

    /**
     UIWebView
    //神策埋点
    if ([FSAnalyticsHelper loginWebViewWithWebView:webView request:request attributes:nil]) {
        return NO;
    }
    
     WKWebView
    //神策埋点
    if ([FSAnalyticsHelper loginWebViewWithWebView:webView request:navigationAction.request attributes:nil]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return ;
    }
     */
    
    return [[SensorsAnalyticsSDK sharedInstance] showUpWebView:webView WithRequest:request andProperties:attributes];
}

///设置神策发送数据时间间隔(默认15秒)
+ (void)loginSendDataTimeInterval:(NSInteger)interval{
    
    // 设置发送时间间隔为 10 秒钟
    [SensorsAnalyticsSDK sharedInstance].flushInterval = interval * 1000;
}

///设置缓存条数 神策分析 SDK 默认的 flushBulkSize 为 100 条。可以设置 flushBulkSize 属性，修改事件发送的阈值。
+ (void)loginCachAerticleNumber:(NSInteger)number{
    
    // 修改为每缓存 10 条数据，就发送一次
    [SensorsAnalyticsSDK sharedInstance].flushBulkSize = number;
}

///在 App 进入后台状态前，神策分析 SDK 会将本地缓存的数据发送到神策分析
+ (void)loginAutoSendDataBeforeEnterBackground:(BOOL)isAuto{
    
    // 是否在进入后台前自动发送
    [SensorsAnalyticsSDK sharedInstance].flushBeforeEnterBackground = isAuto;
}


///设置同步数据时的网络策略 神策分析 SDK 默认在 3G／4G／WI-FI 环境下，SDK 都会尝试发送数据
+ (void)loginSetSendNetState{
    
    //网络模式选项
    // SensorsAnalyticsNetworkTypeNONE  所有状态都不发送数据
    // SensorsAnalyticsNetworkType2G    2G网络下发送数据
    // SensorsAnalyticsNetworkType3G    3G网络下发送数据
    // SensorsAnalyticsNetworkType4G    4G网络下发送数据
    // SensorsAnalyticsNetworkTypeWIFI  WIFI下发送数据
    // SensorsAnalyticsNetworkTypeALL   网络连通时发送数据
    
    [[SensorsAnalyticsSDK sharedInstance] setFlushNetworkPolicy:SensorsAnalyticsNetworkType3G |SensorsAnalyticsNetworkType4G | SensorsAnalyticsNetworkTypeWIFI];
}

///设置本地缓存上限值 SDK 本地数据库默认缓存数据的上限值为10000条
+ (void)loginSetCacheMaxnum:(NSInteger)number{
    
    //设置本地数据缓存上限值为5000条
    [[SensorsAnalyticsSDK sharedInstance] setMaxCacheSize:number];
}

///Debug 模式下，关闭提示框  Debug 模式下，数据出错时默认会以提示框的方式提示开发者。
+ (void)loginSetAlertClose:(BOOL)isClose{
    
    //关闭弹出框
    [[SensorsAnalyticsSDK sharedInstance] showDebugInfoView:isClose];
}




@end

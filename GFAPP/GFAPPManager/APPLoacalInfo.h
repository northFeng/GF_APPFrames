//
//  APPLoacalInfo.h
//  GFAPP
//  本APP在本机信息汇总
//  Created by gaoyafeng on 2018/5/9.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDImageCache.h"

@interface APPLoacalInfo : NSObject


/**
 *  单利
 */
+ (APPLoacalInfo *)sharedInstance;

#pragma mark - 获取系统 && 本机 信息
//*************************************************
//************ 获取系统 && 本机 信息 ***************
//*************************************************
/** 屏幕尺寸 */
@property (nonatomic,assign) CGSize screenSize;

/** iPhone名字 */
@property (nonatomic,copy) NSString *phoneName;

/** 手机系统版本号 */
@property (nonatomic,copy) NSString *phoneIOSVerion;

/** app版本号 */
@property (nonatomic,copy) NSString *appVerion;

///判断是否有版本更新
- (BOOL)judgeIsHaveUpdate;

/** AppStore版本号(用异步来获取该属性，并进行处理提示更新) */
@property (nonatomic,copy) NSString *appStoreVersion;

/** APPStore商店地址 */
@property (nonatomic,copy) NSString *appStoreUrl;

/** AppStore商店APPID */
@property (nonatomic,copy) NSString *appId;

/** 手机电量 */
@property (nonatomic,assign) CGFloat batteryLevel;

/** UUID */
@property (nonatomic,copy) NSString *uuid;

/** 设置IP地址 */
@property (nonatomic,copy) NSString *ipAdress;

/** 手机运行内存大小 */
@property (nonatomic,assign) NSInteger memorySize;

/** 手机磁盘内存大小 */
@property (nonatomic,copy) NSString *diskTotalSize;

/** 手机磁盘内存可用大小 */
@property (nonatomic,copy) NSString *diskUseSize;

/** 手机是否越狱 */
@property (nonatomic,assign) BOOL prisonBreak;

/** APP内缓存 */
@property (nonatomic,copy) NSString *cacheApp;


#pragma mark - APP权限信息获取
//*************************************************
//************  APP权限信息获取  ***************
//*************************************************
//所有的权限都可以通过下面的方法打开：[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

/** 是否有联网功能 */
@property (nonatomic,assign) BOOL connectNet;

/** 联网权限 */
@property (nonatomic,assign) BOOL connectNetAuthorization;

/** 联网权限 */
@property (nonatomic,copy) NSString *connectNetName;

/** 相册授权 */
@property (nonatomic,assign) BOOL photoAuthorization;

/** 相机权限 */
@property (nonatomic,assign) BOOL cameraAuthorization;

/** 麦克风权限 */
@property (nonatomic,assign) BOOL microphoneAuthorization;

/** 定位权限 */
@property (nonatomic,assign) BOOL locationAuthorization;

/** 推送权限 */
@property (nonatomic,assign) BOOL pushAuthorization;

/** 通讯录权限 */
@property (nonatomic,assign) BOOL addressBookAuthorization;

/** 日历/备忘录权限 */
@property (nonatomic,assign) BOOL calendarAuthorization;


#pragma mark - APP跳转设置对应界面进行设置 (警告：这些跳转设置的权限不能使用！！连代码都得删除！！！否则审核通不过去！！！！有代码扫描检测！！)
//*************************************************
//************  APP跳转设置对应界面进行设置  *********
//*************************************************
///打开WIFI
- (void)openWiFi;

///打开定位授权
- (void)openLocation;

///打开通知设置
- (void)openNotifation;

///相册&&相机授权设置
- (void)openPhotos;

///相机权限
- (void)openCamera;

///打开蓝牙
- (void)openBluetooth;

///打开电话
- (void)openTell:(NSString *)tellId;

///打开短信
- (void)openSMS:(NSString *)smsId;

///打开App Store
- (void)openAppStore:(NSString *)appId;

///打开App Store进行评分
- (void)openAppStoreScore:(NSString *)appId;

///打开App Store内APP详情页
- (void)openAppStoreDetail:(NSString *)appId;

///打开App Store评分详情页
- (void)openAPPStoreScoreDetail:(NSString *)appId;


///app本地版本号
+ (NSString *)appVerion;

///App Store商店版本号
+ (NSString *)appStoreVersion;
/**
 获取应用商店版本号：
 请求：
 https://itunes.apple.com/lookup?id=xxxxxxxxx
 如果应用只上架到国内App Store，则在.com后加/cn !!!!!!!!!
 https://itunes.apple.com/cn/lookup?id=xxxxxxxxx
 请求会得到json数据有对应的版本号和应用连接。
 
 */


///判断是否有版本更新
+ (NSString *)judgeIsHaveUpdate;

///比较两个版本 oneVerson > twoVerson——>YES  oneVerson <= twoVerson——>NO
+ (BOOL)compareTheTwoVersionsAPPVerson:(NSString *)storeVerson localVerson:(NSString *)localVerson;

///相册授权
+ (BOOL)photoAuthorization;

///相机权限
+ (BOOL)cameraAuthorization;

///监测麦克风是否授权
+ (void)microphoneAuthorizationWithStateBlock:(APPBackBlock)blockState;


#pragma mark - 播放系统铃声

///播放通知铃声
+ (void)playAudioWithAudioName:(NSString *)audioName;

///震动1次 #import <AudioToolbox/AudioToolbox.h>
+ (void)startVibrationPhone;

///触感反馈一次
+ (void)feedbackGenerator;


#pragma mark - 根据SDWebImage 处理内存呢
///获取缓存路径下文件大小
+ (NSInteger)getSDWebImageFileSize;


///清理缓存路径下的文件
+ (void)clearDiskMemory;


@end


/**
info.plist文件中设置

Privacy - Photo Library Additions Usage Description  访问相册读写
  
Privacy - Camera Usage Description   访问相机

Privacy - Photo Library Usage Description  访问相册

Privacy - Contacts Usage Description   是否允许此App访问你的通讯录？

Privacy - Location Always Usage Description  始终允许访问位置信息

Privacy - Location Usage Description  永不允许访问位置信息

Privacy - Location When In Use Usage Description  使用应用期间允许访问位置信息

Privacy - Microphone Usage Description  访问麦克风
 
 二.权限配置：
 1.麦克风权限：
 Privacy - Microphone Usage Description
 是否允许此App使用你的麦克风？
 2.相机权限：
 Privacy - Camera Usage Description
 是否允许此App使用你的相机？
 3.相册权限：
 Privacy - Photo Library Usage Description
 是否允许此App访问你的媒体资料库？
 4.通讯录权限：
 Privacy - Contacts Usage Description
 是否允许此App访问你的通讯录？
 5.蓝牙权限：
 Privacy - Bluetooth Peripheral Usage Description
 是否许允此App使用蓝牙？
 6.语音转文字权限：
 Privacy - Speech Recognition Usage Description
 是否允许此App使用语音识别？
 7.日历权限：
 Privacy - Calendars Usage Description
 是否允许此App使用日历？
 8.定位权限：
 Privacy - Location When In Use Usage Description
 我们需要通过您的地理位置信息获取您周边的相关数据
 定位权限:
 Privacy - Location Always Usage Description
 我们需要通过您的地理位置信息获取您周边的相关数据
 在工程的Info.plist文件中根据需求对应的添加键值对。
 
 */


/**
///检查版本号更新
- (void)checkVersonUpdate{
    
    BOOL isNew = NO;
    
    if (APPManagerObject.appstoreVersion.length) {
        
        if ([APPLoacalInfo compareTheTwoVersionsAPPVerson:APPManagerObject.appstoreVersion localVerson:[APPLoacalInfo appVerion]]) {
            //新版本
            isNew = YES;
        }
        
        [self checkAppVersonResult:isNew];
    }else{
        [self startWaitingAnimatingWithTitle:@"获取中"];
        self.tableView.userInteractionEnabled = NO;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *appStoreVerson = [APPLoacalInfo judgeIsHaveUpdate];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stopWaitingAnimating];
                self.tableView.userInteractionEnabled = YES;
                if (appStoreVerson.length) {
                    [self checkAppVersonResult:YES];
                }else{
                    [self checkAppVersonResult:NO];
                }
            });
        });
    }
}

///版本检查完毕
- (void)checkAppVersonResult:(BOOL)result{
    
    if (result) {
        //新版本
        NSString *message = [NSString stringWithFormat:@"当前版本为V%@，已有最新版本是否更新？",[APPLoacalInfo appVerion]];
        [self showAlertCustomTitle:@"版本更新" message:message cancleBtnTitle:@"取消" okBtnTitle:@"更新" okBlock:^(BOOL result, id idObject) {
            [APPLoacalInfo gotoAppleStore];
        }];
    }else{
        [self showMessage:@"已是最新版本"];
    }
}

 */

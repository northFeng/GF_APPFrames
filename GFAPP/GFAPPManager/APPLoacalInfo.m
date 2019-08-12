//
//  APPLoacalInfo.m
//  GFAPP
//
//  Created by gaoyafeng on 2018/5/9.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "APPLoacalInfo.h"

//获取设置IP地址引入库文件
#import <ifaddrs.h>
#import <arpa/inet.h>

//获取手机磁盘大小
#include <sys/param.h>
#include <sys/mount.h>

//联网权限
@import CoreTelephony;

//iOS9之后相册权限
@import AssetsLibrary;

//iOS8之后相册授权
@import Photos;

//相机和麦克风权限
@import AVFoundation;

//定位权限
@import CoreLocation;

//通讯录权限iOS9.0之前
@import AddressBook;

//iOS9.0及以后通讯录权限
@import Contacts;

//日历、备忘录权限
#import <EventKit/EventKit.h>

#import <AudioToolbox/AudioToolbox.h>

@implementation APPLoacalInfo

///单利
+ (APPLoacalInfo *)sharedInstance
{
    static APPLoacalInfo *localInfo = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localInfo = [[APPLoacalInfo alloc] init];
    });
    return localInfo;
}

///屏幕尺寸
- (CGSize)screenSize{
    _screenSize = [UIScreen mainScreen].bounds.size;
    return _screenSize;
}
///手机名字
- (NSString *)phoneName{
    _phoneName = [UIDevice currentDevice].name;
    return _phoneName;
}

///手机系统版本号
- (NSString *)phoneIOSVerion{
    _phoneIOSVerion = [UIDevice currentDevice].systemVersion;
    return _phoneIOSVerion;
}

///app版本号
- (NSString *)appVerion{
    _appVerion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return _appVerion;
}

///App Store商店版本号
- (NSString *)appStoreVersion{
    
    /**
     如果http://itunes.apple.com/lookup?id=1048837768获取不到数据，由于发布appstore是中国区不是世界范围，
     
     所以lookup的需要／cn如 http://itunes.apple.com/cn/lookup?id=1048837768
     */
    NSString *url = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",self.appId];
    /**
     {
     "resultCount" : 1,
     "results" : [{
     "artistId" : "开发者 ID",
     "artistName" : "开发者名称",
     "trackCensoredName" : "审查名称",
     "trackContentRating" : "评级",
     "trackId" : "应用程序 ID",
     "trackName" = "应用程序名称",
     "trackViewUrl" = "应用程序下载网址",
     "userRatingCount" = "用户评论数量",
     "userRatingCountForCurrentVersion" = "当前版本的用户评论数量",
     "version" = "版本号"
     }]
     }
     */
    NSString *appInfoString = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
    
    NSData *appInfoData = [appInfoString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:appInfoData options:NSJSONReadingMutableLeaves error:&error];
    
    if (!error && appInfoDic) {
        
        NSArray *arrayInfo = appInfoDic[@"results"];
        
        NSDictionary *resultDic = arrayInfo.firstObject;
        
        //版本号
        NSString *version = resultDic[@"version"];
        
        //应用程序名称
        //NSString *trackName = resultDic[@"trackName"];
        
        _appStoreVersion = version;
    }else{
        _appStoreVersion = nil;
    }
    
    return _appStoreVersion;
}

///判断是否有版本更新
- (BOOL)judgeIsHaveUpdate{
    
    NSString *appStoreVerson = [self appStoreVersion];
    
    NSString *appLocalVerson = [self appVerion];
    
    BOOL isHaveUpdate = NO;
    
    if (appStoreVerson.length > 0 && appLocalVerson.length > 0 && ![appStoreVerson isEqualToString:appLocalVerson]) {
        //有新版本
        
        NSArray *arrayStore = [appStoreVerson componentsSeparatedByString:@"."];
        
        NSArray *arrayLocal = [appLocalVerson componentsSeparatedByString:@"."];
        
        for (int i = 0; i < arrayStore.count ; i++) {
            
            NSString *numStrOne = [arrayStore gf_getItemWithIndex:i];
            
            NSString *numStrTwo = [arrayLocal gf_getItemWithIndex:i];
            
            if (numStrOne.length > 0 && numStrTwo.length > 0) {
                
                //进行比较
                NSInteger numStore = [numStrOne integerValue];
                
                NSInteger numLocal = [numStrTwo integerValue];
                
                if (numStore > numLocal) {
                    
                    isHaveUpdate = YES;
                    
                    break;
                }else{
                    //本地版本大于商店版本
                    
                    break;
                }
                
            }else{
                if (numStrOne.length == 0 && numStrTwo.length > 0) {
                    //新版本
                    isHaveUpdate = YES;
                    break;
                }else if (numStrOne.length > 0 && numStrTwo.length == 0){
                    isHaveUpdate = YES;
                    break;
                }
            }
        }
    }
    
    return isHaveUpdate;
}


///App Store商店地址
- (NSString *)appStoreUrl{
    //@"itms-apps://itunes.apple.com/app/id1206195619";
    _appStoreUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",self.appId];
    return _appStoreUrl;
}

///appID
- (NSString *)appId{
    _appId = [APPKeyInfo getAppId];
    return _appId;
}

/// 获取电池电量
- (CGFloat)batteryLevel{
    _batteryLevel = [UIDevice currentDevice].batteryLevel;
    return _batteryLevel;
}

/// 通用唯一识别码UUID
- (NSString *)uuid{
    _uuid = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    
    //[[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
    return _uuid;
}

/**
 * 这个方法返回 UUID
 */
- (NSString *)getDeviceId {
    /**
    // 读取设备号
    NSString *localDeviceId = [SAMKeychain passwordForService:kKeychainService account:kKeychainDeviceId];
    if (!localDeviceId) {
        // 如果没有UUID 则保存设备号
        CFUUIDRef deviceId = CFUUIDCreate(NULL);
        assert(deviceId != NULL);
        CFStringRef deviceIdStr = CFUUIDCreateString(NULL, deviceId);
        [SAMKeychain setPassword:[NSString stringWithFormat:@"%@", deviceIdStr] forService:@"com.apple.biubiubiu" account:@"DeviceId"];
        //————————————————————————————————————————————————————————————————————————> 这里在项目设置中 capabilities 中 keychain sharing 中设置一下
        localDeviceId = [NSString stringWithFormat:@"%@", deviceIdStr];
    }
    return localDeviceId;
     */
    return @"";
}

// 获取当前设备IP
- (NSString *)ipAdress{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // 检索当前接口,在成功时,返回0
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // 循环链表的接口
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // 检查接口是否en0 wifi连接在iPhone上
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // 得到NSString从C字符串
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // 释放内存
    freeifaddrs(interfaces);
    _ipAdress = address;
    return _ipAdress;
}

/// 获取总内存大小
- (NSInteger)memorySize{
    _memorySize = [NSProcessInfo processInfo].physicalMemory;
    return _memorySize;
}

///手机磁盘总大小
- (NSString *)diskTotalSize{
    
    struct statfs buf;
    long long totalspace;
    totalspace = 0;
    if(statfs("/private/var", &buf) >= 0){
        totalspace = (long long)buf.f_bsize * buf.f_blocks;
    }
    
    _diskTotalSize = [NSString stringWithFormat:@"%0.2fG",(double)totalspace/1024/1024/1024];
    return _diskTotalSize;
}

///磁盘可用大小
- (NSString *)diskUseSize{
    //可用大小
    struct statfs buf;
    long long freespace = 0;
    if(statfs("/private/var", &buf) >= 0){
        freespace = (long long)(buf.f_bsize * buf.f_bfree);
    }
    _diskUseSize = [NSString stringWithFormat:@"%0.2fG",(double)freespace/1024/1024/1024];
    return _diskUseSize;
}


///手机是否越狱
char* printEnv(void) {
    char *env = getenv("DYLD_INSERT_LIBRARIES");
    NSLog(@"%s", env);
    return env;
}
- (BOOL)prisonBreak{
    
    BOOL isOrNo = NO;
    
    //方法一：通过越狱后增加的越狱文件判断
    NSArray *jailbreak_tool_paths = @[
                                      @"/Applications/Cydia.app",
                                      @"/Library/MobileSubstrate/MobileSubstrate.dylib",
                                      @"/bin/bash",
                                      @"/usr/sbin/sshd",
                                      @"/etc/apt"
                                      ];
    for (int i=0; i<jailbreak_tool_paths.count; i++) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:jailbreak_tool_paths[i]]) {
            NSLog(@"The device is jail broken!");
            isOrNo = YES;
        }
    }
    
    //方法二：根据是否能打开cydia判断
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://"]]) {
        NSLog(@"The device is jail broken!");
        isOrNo = YES;
    }
    
    //方法三：根据是否能获取所有应用的名称判断   ————>  没有越狱的设备是没有读取所有应用名称的权限的。
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"User/Applications/"]) {
        NSLog(@"The device is jail broken!");
        NSArray *appList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"User/Applications/" error:nil];
        NSLog(@"appList = %@", appList);
        isOrNo = YES;
    }
    
    //方法四：根据读取的环境变量是否有值判断DYLD_INSERT_LIBRARIES环境变量在非越狱的设备上应该是空的，而越狱的设备基本上都会有Library/MobileSubstrate/MobileSubstrate.dylib
    if (printEnv()) {
        NSLog(@"The device is jail broken!");
        isOrNo = YES;
    }
    
    //赋值结果
    _prisonBreak = isOrNo;
    
    return _prisonBreak;
}

- (NSString *)cacheApp{
    //缓存
    SDImageCache *saImage = [SDImageCache sharedImageCache];
    _cacheApp = [NSString stringWithFormat:@"%.2fM",saImage.totalDiskSize/1024./1024.];
    /** 清理缓存
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    [[SDImageCache sharedImageCache] clearMemory];//可有可无
     */
    return _cacheApp;
}


#pragma mark - 授权信息 && 获取授权
///是否有联网功能
- (BOOL)connectNet{
    //联网权限 导入框架 @import CoreTelephony;  这个类是iOS7以后才出现的，之前是私有API
    CTCellularData *cellularData = [[CTCellularData alloc]init];
    CTCellularDataRestrictedState state = cellularData.restrictedState;
    BOOL isAuthor = NO;
    switch (state) {
        case kCTCellularDataRestricted:
            NSLog(@"Restricrted");
            break;
        case kCTCellularDataNotRestricted:
            NSLog(@"Not Restricted");
            isAuthor = YES;
            break;
        case kCTCellularDataRestrictedStateUnknown:
            NSLog(@"Unknown");
            break;
        default:
            break;
    }
    _connectNet = isAuthor;
    return _connectNet;
}

///联网权限
- (BOOL)connectNetAuthorization{
    
    __block BOOL isAuthor = NO;
    CTCellularData *cellularData = [[CTCellularData alloc]init];
    cellularData.cellularDataRestrictionDidUpdateNotifier =  ^(CTCellularDataRestrictedState state){
        //获取联网状态
        switch (state) {
            case kCTCellularDataRestricted:
                NSLog(@"Restricrted");
                break;
            case kCTCellularDataNotRestricted:
                NSLog(@"Not Restricted");
                isAuthor = YES;
                break;
            case kCTCellularDataRestrictedStateUnknown:
                NSLog(@"Unknown");
                break;
            default:
                break;
        };
    };
    _connectNetAuthorization = isAuthor;
    return _connectNetAuthorization;
}

///联网网络信息
- (NSString *)connectNetName{
    /**
    在项目开发当中,往往需要利用网络.而用户的网络环境也需要我们开发者去注意,根据不同的网络状态作相应的优化,以提升用户体验.
    但通常我们只会判断用户是在WIFI还是移动数据,而实际上,移动数据也分为2G/3G/4G等不同制式.而不同的网络制式又对用户体验产生
    较为明显的影响(对于依赖网络的项目而言).因此很有必要对不同的网络制式作相应的优化.
    　　而在iOS当中,无论是苹果官方提供的Reachability类还是较为常用的第三方网络类AFNetworking,它们提供的网络环境判断也仅限
    于WIFI/数据,因此我们需要其他方式去获得客户端更详细的网络环境.
    　　CoreTelephony.framework中提供了CTTelephonyNetworkInfo这个类.这个类是iOS7以后才出现的,在使用这个类之前我们需要
    导入CoreTelephony.framework
     */
    CTTelephonyNetworkInfo *networkStatus = [[CTTelephonyNetworkInfo alloc]init];  //创建一个CTTelephonyNetworkInfo对象
    NSString *currentStatus  = networkStatus.currentRadioAccessTechnology; //获取当前网络描述
    
    NSString *netName = @"";
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]){
        //GPRS网络
        netName = @"GPRS";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]){
        //2.75G的EDGE网络
        netName = @"2G";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
        //3G WCDMA网络
        netName = @"3G";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
        //3.5G网络
        netName = @"3G";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
        //3.5G网络
        netName = @"3G";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
        //CDMA2G网络
        netName = @"2G";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
        //CDMA的EVDORev0(应该算3G吧?)
        netName = @"3G";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
        //CDMA的EVDORevA(应该也算3G吧?)
        netName = @"3G";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
        //CDMA的EVDORev0(应该还是算3G吧?)
        netName = @"3G";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
        //HRPD网络
        netName = @"4G";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
        //LTE4G网络
        netName = @"4G";
    }
    _connectNetName = netName;
    
    return _connectNetName;
}

///iOS6之后相册授权
- (BOOL)photoAuthorization{
    
    BOOL isAuthor = NO;
    
    if ([self.phoneIOSVerion floatValue] >= 8.) {
        //ios8以后
        PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
        switch (photoAuthorStatus) {
            case PHAuthorizationStatusAuthorized:
                NSLog(@"Authorized");
                isAuthor = YES;
                break;
            case PHAuthorizationStatusDenied:
                NSLog(@"Denied");
                break;
            case PHAuthorizationStatusNotDetermined:
                NSLog(@"not Determined");
                break;
            case PHAuthorizationStatusRestricted:
                NSLog(@"Restricted");
                break;
            default:
                break;
        }
    }else{
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        switch (status) {
            case ALAuthorizationStatusAuthorized:
                NSLog(@"Authorized");
                isAuthor = YES;
                break;
            case ALAuthorizationStatusDenied:
                NSLog(@"Denied");
                break;
            case ALAuthorizationStatusNotDetermined:
                NSLog(@"not Determined");
                break;
            case ALAuthorizationStatusRestricted:
                NSLog(@"Restricted");
                break;
            default:
                break;
        }
    }
    
    _photoAuthorization = isAuthor;
    return _photoAuthorization;
}


///相机权限
- (BOOL)cameraAuthorization{
    
    AVAuthorizationStatus AVstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];//相机权限
    BOOL isAuthor = NO;
    switch (AVstatus) {
        case AVAuthorizationStatusAuthorized:
            NSLog(@"Authorized");
            isAuthor = YES;
            break;
        case AVAuthorizationStatusDenied:
            NSLog(@"Denied");
            break;
        case AVAuthorizationStatusNotDetermined:
            NSLog(@"not Determined");
            isAuthor = YES;//还未进行提示是否授权
            break;
        case AVAuthorizationStatusRestricted:
            NSLog(@"Restricted");
            break;
        default:
            break;
    }
    _cameraAuthorization = isAuthor;
    return _cameraAuthorization;
}

///麦克风权限
- (BOOL)microphoneAuthorization{
    
    AVAuthorizationStatus AVstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];//麦克风权限
    BOOL isAuthor = NO;
    switch (AVstatus) {
        case AVAuthorizationStatusAuthorized:
            NSLog(@"Authorized");
            isAuthor = YES;
            break;
        case AVAuthorizationStatusDenied:
            NSLog(@"Denied");
            break;
        case AVAuthorizationStatusNotDetermined:
            NSLog(@"not Determined");
            isAuthor = YES;//还未进行提示是否授权
            break;
        case AVAuthorizationStatusRestricted:
            NSLog(@"Restricted");
            break;
        default:
            break;
    }
    _microphoneAuthorization = isAuthor;
    return _microphoneAuthorization;
}

///定位权限
- (BOOL)locationAuthorization{
    
//    BOOL isLocation = [CLLocationManager locationServicesEnabled];
//    if (!isLocation) {
//        NSLog(@"not turn on the location");
//    }
    
    /**
     由于iOS8.0之后定位方法的改变，需要在info.plist中进行配置；
     NSLocationWhenUseUsageDescription :使用时获取定位信息
     NSLocationAlwaysUsageDescription：一直获取定位信息
     */
    
    BOOL isAuthor = NO;
    CLAuthorizationStatus CLstatus = [CLLocationManager authorizationStatus];
    switch (CLstatus) {
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"Always Authorized");
            isAuthor = YES;
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"AuthorizedWhenInUse");
            isAuthor = YES;
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"Denied");
            break;
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"not Determined");
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"Restricted");
            break;
        default:
            break;
    }
    
    _locationAuthorization = isAuthor;
    return _locationAuthorization;
}
/**
主动获取权限
CLLocationManager *manager = [[CLLocationManager alloc] init];
[manager requestAlwaysAuthorization];//一直获取定位信息
[manager requestWhenInUseAuthorization];//使用的时候获取定位信息

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"Always Authorized");
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"AuthorizedWhenInUse");
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"Denied");
            break;
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"not Determined");
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"Restricted");
            break;
        default:
            break;
    }
}
*/

///推送权限
- (BOOL)pushAuthorization{
    BOOL isAuthor = YES;
    if ([self.phoneIOSVerion floatValue] >= 8.0){
        UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        switch (settings.types) {
            case UIUserNotificationTypeNone:
                NSLog(@"None");
                isAuthor = NO;
                break;
            case UIUserNotificationTypeAlert:
                NSLog(@"Alert Notification");
                break;
            case UIUserNotificationTypeBadge:
                NSLog(@"Badge Notification");
                break;
            case UIUserNotificationTypeSound:
                NSLog(@"sound Notification'");
                break;
            default:
                break;
        }
    }else{
        UIRemoteNotificationType notificationType = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        switch (notificationType) {
            case UIRemoteNotificationTypeNone:
                isAuthor = NO;
                break;
            default:
                break;
        }
    }
    
    /**
     获取推送权限
     
     UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge categories:nil];
     [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
     */
    _pushAuthorization = isAuthor;
    return _pushAuthorization;
}

///通讯录权限
- (BOOL)addressBookAuthorization{
    
    BOOL isAuthor = NO;
    if ([self.phoneIOSVerion floatValue] >= 9.0) {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        switch (status) {
            case CNAuthorizationStatusNotDetermined:
                NSLog(@"NotDetermined");
                break;
            case CNAuthorizationStatusRestricted:
                NSLog(@"Restricted'");
                break;
            case CNAuthorizationStatusDenied:
                NSLog(@"Denied");
                break;
            case CNAuthorizationStatusAuthorized:
                NSLog(@"Authorized");
                isAuthor = YES;
                break;
            default:
                break;
        }
    }else{
        ABAuthorizationStatus ABstatus = ABAddressBookGetAuthorizationStatus();
        switch (ABstatus) {
            case kABAuthorizationStatusAuthorized:
                NSLog(@"Authorized");
                isAuthor = YES;
                break;
            case kABAuthorizationStatusDenied:
                NSLog(@"Denied'");
                break;
            case kABAuthorizationStatusNotDetermined:
                NSLog(@"not Determined");
                break;
            case kABAuthorizationStatusRestricted:
                NSLog(@"Restricted");
                break;
            default:
                break;
        }
    }
    
    _addressBookAuthorization = isAuthor;
    return _addressBookAuthorization;
}

/**
ios9之前获取通讯录权限
ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
    if (granted) {
        NSLog(@"Authorized");
        CFRelease(addressBook);
    }else{
        NSLog(@"Denied or Restricted");
    }
});
iOS9之后获取通讯录权限
CNContactStore *contactStore = [[CNContactStore alloc] init];
[contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
    if (granted) {
        
        NSLog(@"Authorized");
        
    }else{
        
        NSLog(@"Denied or Restricted");
    }
}];
 */


///日历、备忘录权限
- (BOOL)calendarAuthorization{
    /**
    typedef NS_ENUM(NSUInteger, EKEntityType) {
        EKEntityTypeEvent,//日历
        EKEntityTypeReminder //备忘
    };
     */
    BOOL isAuthor = NO;
    EKAuthorizationStatus EKstatus = [EKEventStore  authorizationStatusForEntityType:EKEntityTypeEvent];
    switch (EKstatus) {
        case EKAuthorizationStatusAuthorized:
            NSLog(@"Authorized");
            isAuthor = YES;
            break;
        case EKAuthorizationStatusDenied:
            NSLog(@"Denied'");
            break;
        case EKAuthorizationStatusNotDetermined:
            NSLog(@"not Determined");
            break;
        case EKAuthorizationStatusRestricted:
            NSLog(@"Restricted");
            break;
        default:
            break;
    }
    _calendarAuthorization = isAuthor;
    return _calendarAuthorization;
}

/**
//获取日历或备忘录权限
EKEventStore *store = [[EKEventStore alloc]init];
[store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
    if (granted) {
        NSLog(@"Authorized");
    }else{
        NSLog(@"Denied or Restricted");
    }
}];
 */


#pragma mark - APP跳转设置对应界面进行设置
/**
 如何跳转到系统设置界面
 判断权限是否设置之后就可以在相应的代理方法进行界面跳转了，那么如何进行跳转呢？
 首先要在项目中的info.plist中添加 URL types 并设置一项URL Schemes为prefs，如下图：
 
 About — prefs:root=General&path=About
 Accessibility — prefs:root=General&path=ACCESSIBILITY
 Airplane Mode On — prefs:root=AIRPLANE_MODE
 Auto-Lock — prefs:root=General&path=AUTOLOCK
 Brightness — prefs:root=Brightness
 Bluetooth — prefs:root=General&path=Bluetooth
 Date & Time — prefs:root=General&path=DATE_AND_TIME
 FaceTime — prefs:root=FACETIME
 General — prefs:root=General
 Keyboard — prefs:root=General&path=Keyboard
 iCloud — prefs:root=CASTLE
 iCloud Storage & Backup — prefs:root=CASTLE&path=STORAGE_AND_BACKUP
 International — prefs:root=General&path=INTERNATIONAL
 Location Services — prefs:root=LOCATION_SERVICES
 Music — prefs:root=MUSIC
 Music Equalizer — prefs:root=MUSIC&path=EQ
 Music Volume Limit — prefs:root=MUSIC&path=VolumeLimit
 Network — prefs:root=General&path=Network
 Nike + iPod — prefs:root=NIKE_PLUS_IPOD
 Notes — prefs:root=NOTES
 Notification — prefs:root=NOTIFICATIONS_ID
 Phone — prefs:root=Phone
 Photos — prefs:root=Photos
 Profile — prefs:root=General&path=ManagedConfigurationList
 Reset — prefs:root=General&path=Reset
 Safari — prefs:root=Safari
 Siri — prefs:root=General&path=Assistant
 Sounds — prefs:root=Sounds
 Software Update — prefs:root=General&path=SOFTWARE_UPDATE_LINK
 Store — prefs:root=STORE
 Twitter — prefs:root=TWITTER
 Usage — prefs:root=General&path=USAGE
 VPN — prefs:root=General&path=Network/VPN
 Wallpaper — prefs:root=Wallpaper
 Wi-Fi — prefs:root=WIFI
 */
///打开WIFI
- (void)openWiFi{
    NSURL *url = [NSURL URLWithString:@"prefs:root=WIFI"];
    if ([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
    }
}

///打开定位授权
- (void)openLocation{
    //定位服务设置界面
    NSURL *url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
    if ([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
    }
}

///打开通知设置
- (void)openNotifation{
    //iCloud设置界面
    NSURL *url = [NSURL URLWithString:@"prefs:root=NOTIFICATIONS_ID"];
    if ([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
    }
}

///相册&&相机授权设置
- (void)openPhotos{
    //FaceTime设置界面
    NSURL *url = [NSURL URLWithString:@"prefs:root=Photos"];
    if ([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
    }
}

///相机权限
- (void)openCamera{
    NSURL *url = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
    if ([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
    }
}

///打开蓝牙
- (void)openBluetooth{
    //蓝牙设置界面
    NSURL *url = [NSURL URLWithString:@"prefs:root=Bluetooth"];
    if ([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
    }
}

///打开电话
- (void)openTell:(NSString *)tellId{
    NSString *url = [NSString stringWithFormat:@"tel://%@",tellId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
    /**
    使用这种方式拨打电话时，当用户结束通话后，iphone界面会停留在电话界面。
    用如下方式，可以使得用户结束通话后自动返回到应用：
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:@"tel:10086"];// 貌似tel:// 或者 tel: 都行
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    //记得添加到view上
    [self.view addSubview:callWebview];
    
    　还有一种私有方法：（可能不能通过审核）
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://10086"]];
     */
}

///打开短信
- (void)openSMS:(NSString *)smsId{
    NSString *url = [NSString stringWithFormat:@"sms://%@",smsId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}


//--------->然后在设置URL Types：itms-apps
///打开App Store
- (void)openAppStore:(NSString *)appId{
    NSString *url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",appId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    /**
    使用浏览器进入AppStore商店或者  通过第三方浏览器进入 AppStore方法：
    NSString *url = [NSString stringWithFormat:@"http://itunes.apple.com/app/id%d",appid];
     */
}

///打开App Store进行评分
- (void)openAppStoreScore:(NSString *)appId{
    /**
    如果是7.0以前的系统
    NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=xxxxxx" ];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
     */
    
    NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@&pageNumber=0&sortOrdering=2&mt=8", appId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}

///打开App Store内APP详情页
- (void)openAppStoreDetail:(NSString *)appId{
    //(1).app跳转到appStore详情页面
    NSString *url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8",appId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

///打开App Store评分详情页
- (void)openAPPStoreScoreDetail:(NSString *)appId{
    
    NSString *url = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",appId];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}


///app版本号
+ (NSString *)appVerion{
    NSString *appVerion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return appVerion;
}
///App Store商店版本号
+ (NSString *)appStoreVersion{
    
    NSString *url = [NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",[APPKeyInfo getAppId]];//中国
    
    NSString *appStoreVersion = @"";
    /**
     {
     "resultCount" : 1,
     "results" : [{
     "artistId" : "开发者 ID",
     "artistName" : "开发者名称",
     "trackCensoredName" : "审查名称",
     "trackContentRating" : "评级",
     "trackId" : "应用程序 ID",
     "trackName" = "应用程序名称",
     "trackViewUrl" = "应用程序下载网址",
     "userRatingCount" = "用户评论数量",
     "userRatingCountForCurrentVersion" = "当前版本的用户评论数量",
     "version" = "版本号"
     }]
     }
     */
    NSString *appInfoString = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
    
    NSData *appInfoData = [appInfoString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    if (appInfoData && appInfoData.length > 0) {
        NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:appInfoData options:NSJSONReadingMutableLeaves error:&error];
        
        if (!error && appInfoDic) {
            
            NSArray *arrayInfo = appInfoDic[@"results"];
            
            NSDictionary *resultDic = arrayInfo.firstObject;
            
            //版本号
            NSString *version = resultDic[@"version"];
            
            //应用程序名称
            //NSString *trackName = resultDic[@"trackName"];
            appStoreVersion = version;
        }
    }
    
    return appStoreVersion;
}

/**
///检查版本号更新
- (void)checkVersonUpdate{
    
    BOOL isNew = NO;
    
    if (APPManagerObject.appstoreVersion.length) {
        
        if ([APPLoacalInfo compareTheTwoVersionsAPPVerson:APPManagerObject.appstoreVersion localVerson:[APPLoacalInfo appVerion]]) {
            //新版本
            isNew = YES;
        }
    }else{
        [self startWaitingAnimatingWithTitle:@"获取中"];
        self.tableView.userInteractionEnabled = NO;
        NSString *appStoreVerson = [APPLoacalInfo judgeIsHaveUpdate];
        [self stopWaitingAnimating];
        self.tableView.userInteractionEnabled = YES;
        if (appStoreVerson.length) {
            isNew = YES;
        }
    }
    
    if (isNew) {
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

///判断是否有版本更新
+ (NSString *)judgeIsHaveUpdate{
    
    NSString *appStoreVerson = [self appStoreVersion];
    
    NSString *appLocalVerson = [self appVerion];
    
    BOOL isHaveUpdate = [self compareTheTwoVersionsAPPVerson:appStoreVerson localVerson:appLocalVerson];
    
    if (isHaveUpdate) {
        //新版本
        return appStoreVerson;
    }else{
        return @"";
    }
}

///比较两个版本 oneVerson > twoVerson——>YES  oneVerson <= twoVerson——>NO
+ (BOOL)compareTheTwoVersionsAPPVerson:(NSString *)storeVerson localVerson:(NSString *)localVerson{
    
    BOOL isHaveUpdate = NO;
    
    if (storeVerson.length > 0 && localVerson.length > 0 && ![storeVerson isEqualToString:localVerson]) {
        
        NSArray *arrayOne = [storeVerson componentsSeparatedByString:@"."];
        
        NSArray *arrayTwo = [localVerson componentsSeparatedByString:@"."];
        
        for (int i = 0; i < arrayOne.count ; i++) {
            
            NSString *numStrOne = [arrayOne gf_getItemWithIndex:i];
            
            NSString *numStrTwo = [arrayTwo gf_getItemWithIndex:i];
            
            if (numStrOne.length > 0 && numStrTwo.length > 0) {
                
                //进行比较
                NSInteger numStore = [numStrOne integerValue];
                
                NSInteger numLocal = [numStrTwo integerValue];
                
                if (numStore > numLocal) {
                    
                    isHaveUpdate = YES;
                    
                    break;
                }else if (numStore < numLocal){
                    //本地版本大于商店版本 ——> 这种情况只有未上线版本会出现
                    
                    break;
                }else{
                    //相等 继续循环
                }
                
            }else{
                /** 线上版本号与本地版本号长度不一致时！
                    1、版本号进行变长，1.5.2 ——> 1.5.2.1  前面可不变
                    2、版本号进行变短  1.5.2 ——> 1.6 必须+1,新版本号必须比线上版本号大！！！！——> 线上版本号变短，else这里就不会触发，所以版本号必须+1
                 */
                if (numStrOne.length == 0 && numStrTwo.length > 0) {
                    //本地版本提前更新 && 本地版本号 长度变长 (这种情况不会出现,循环以线上版本分割数组进行循环)
                    
                    break;
                }else if (numStrOne.length > 0 && numStrTwo.length == 0){
                    //线上版本出现新版本
                    isHaveUpdate = YES;
                    
                    break;
                }
            }
        }
    }
    
    return isHaveUpdate;
}


///相册授权
+ (BOOL)photoAuthorization{
    
    BOOL isAuthor = NO;
    
    //ios8以后
    PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
    switch (photoAuthorStatus) {
        case PHAuthorizationStatusAuthorized:
            NSLog(@"Authorized");
            isAuthor = YES;
            break;
        case PHAuthorizationStatusDenied:
            NSLog(@"Denied");
            break;
        case PHAuthorizationStatusNotDetermined:
            NSLog(@"not Determined");
            isAuthor = YES;
            break;
        case PHAuthorizationStatusRestricted:
            NSLog(@"Restricted");
            break;
        default:
            break;
    }
    
    return isAuthor;
}


///相机权限
+ (BOOL)cameraAuthorization{
    
    AVAuthorizationStatus AVstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];//相机权限
    BOOL isAuthor = NO;
    switch (AVstatus) {
        case AVAuthorizationStatusAuthorized:
            NSLog(@"Authorized");
            isAuthor = YES;
            break;
        case AVAuthorizationStatusDenied:
            NSLog(@"Denied");
            break;
        case AVAuthorizationStatusNotDetermined:
            NSLog(@"not Determined");
            isAuthor = YES;
            break;
        case AVAuthorizationStatusRestricted:
            NSLog(@"Restricted");
            break;
        default:
            break;
    }
    return isAuthor;
}



/**
  APP内打开APP详情页
 #import <StoreKit/StoreKit.h>
 <SKStoreProductViewControllerDelegate>遵守代理
- (void)openAppWithIdentifier:(NSString *)appId {
    
    SKStoreProductViewController *storeProductVC = [[SKStoreProductViewController alloc] init];
    storeProductVC.delegate = self;
    storeProductVC.view.frame = CGRectMake(0, 0, 300, 300);
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:appId forKey:SKStoreProductParameterITunesItemIdentifier];
    [storeProductVC loadProductWithParameters:dict completionBlock:^(BOOL result, NSError *error) {
        if (result) {
            [self presentViewController:storeProductVC animated:YES completion:nil];
        }
    }];
    
}

#pragma mark - SKStoreProductViewControllerDelegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    
    [viewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
 */


///播放通知铃声  #import <AudioToolbox/AudioToolbox.h>
+ (void)playAudioWithAudioName:(NSString *)audioName{
    
    //需要导入AudioToolbox.framework框架 在 Link Binary With Libraries 中 添加这个框架
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:audioName ofType:@"mp3"];
    
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    //1.获得系统声音ID
    SystemSoundID soundID = 0;
    /**
     * inFileUrl:音频文件url
     * outSystemSoundID:声音id（此函数会将音效文件加入到系统音频服务中并返回一个长整形ID）
     * Background Modes 中添加音乐播放，否则APP进入后天停止播放
     */
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    //如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
    //AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    //2.播放音频
    AudioServicesPlaySystemSound(soundID);//播放音效
    
}

/**
 *  播放完成回调函数
 *
 *  @param soundID    系统声音ID
 *  @param clientData 回调时传递的数据
 */
void soundCompleteCallback(SystemSoundID soundID,void * clientData)
{
    NSLog(@"播放完成...");
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//震动
    //停止震动
    //AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
}

///震动1次 #import <AudioToolbox/AudioToolbox.h>
+ (void)startVibrationPhone{
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//震动
}

///触感反馈一次
+ (void)feedbackGenerator{
    
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
        
        [feedBackGenertor impactOccurred];
    } else {
        // Fallback on earlier versions
    }
    
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//震动一次
}


#pragma mark - 根据SDWebImage 处理内存呢
///获取缓存路径下文件大小
+ (NSInteger)getSDWebImageFileSize{
    
    //缓存
    SDImageCache *saImage = [SDImageCache sharedImageCache];
    
    return [saImage totalDiskSize];
}

///清理缓存路径下的文件
+ (void)clearDiskMemory{
    
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    [[SDImageCache sharedImageCache] clearMemory];//可有可无
}


@end

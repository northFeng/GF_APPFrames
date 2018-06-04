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
    return _uuid;
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


#pragma mark - 授权信息 && 获取授权
///是否有联网功能
- (BOOL)connectNet{
    
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
- (void)openCamea{
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




@end

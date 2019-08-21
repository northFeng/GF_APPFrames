//
//  APPScreeTool.m
//  GFAPP
//
//  Created by 峰 on 2019/8/21.
//  Copyright © 2019 North_feng. All rights reserved.
//

#import "APPScreeTool.h"

#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#import <resolv.h>
#import <netdb.h>
#import <netinet/ip.h>
#import <net/ethernet.h>
#import <net/if_dl.h>
#import <sys/utsname.h>

#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
//#define IOS_VPN       @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

#define MAC_ADDR        @"02:00:00:00:00:00"
#define MDNS_PORT       5353
#define QUERY_NAME      "_apple-mobdev2._tcp.local"

@implementation APPScreeTool

+ (NSString *)screenType {
    
    UIScreen *screen = [UIScreen mainScreen];
    switch ((NSInteger)screen.bounds.size.width) {
        case 320:
            return @"S";
        case 375:
            return screen.scale == 2.0 ? @"N" : @"X";
        case 414:
            return screen.scale == 2.0 ? @"XR" : (screen.bounds.size.height == 736 ? @"NP" : @"XS");
        default:
            return @"N";
    }
}

+ (BOOL)hasSafeArea {
    NSString *type = self.screenType;
    if ([type isEqualToString:@"S"] || [type isEqualToString:@"N"] || [type isEqualToString:@"NP"]) {
        return NO;
    } else if ([type isEqualToString:@"X"] || [type isEqualToString:@"XR"] || [type isEqualToString:@"XS"]) {
        return YES;
    }
    return NO;
}

+ (CGFloat)fit:(CGFloat)number {
    NSString *type = self.screenType;
    if ([type isEqualToString:@"S"]) {
        return number * (320.0 / 375.0);
    } else if ([type isEqualToString:@"N"] || [type isEqualToString:@"X"]) {
        return number;
    } else if ([type isEqualToString:@"NP"] || [type isEqualToString:@"XR"] || [type isEqualToString:@"XS"]) {
        return number * (414.0 / 375.0);
    }
    return number;
}

+ (CGFloat)fitH:(CGFloat)number {
    NSString *type = self.screenType;
    if ([type isEqualToString:@"S"]) {
        return number * (480.0 / 667.0);
    } else if ([type isEqualToString:@"N"] || [type isEqualToString:@"NP"]) {
        return number;
    } else if ([type isEqualToString:@"X"] || [type isEqualToString:@"XR"] || [type isEqualToString:@"XS"]) {
        return number * (812.0  / 375.0);
    }
    return number;
}

+ (UIFont *)font:(CGFloat)number {
    NSString *type = self.screenType;
    if ([type isEqualToString:@"S"]) {
        return [UIFont systemFontOfSize:number - 1];
    } else if ([type isEqualToString:@"N"]) {
        return [UIFont systemFontOfSize:number];
    } else if ([type isEqualToString:@"NP"] || [type isEqualToString:@"XR"] || [type isEqualToString:@"XS"] || [type isEqualToString:@"X"]) {
        //        return [UIFont systemFontOfSize:number + 2];
        return [UIFont systemFontOfSize:number];
    }
    return [UIFont systemFontOfSize:number];
}

+ (void)removeInViewControllers:(UIViewController *)vc{
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:vc.navigationController.viewControllers];
    for (UIViewController *temp in vc.navigationController.viewControllers) {
        if ([temp isKindOfClass:[vc class]]) {
            [array removeObject:temp];
        }
    }
    vc.navigationController.viewControllers = [array copy];
}

+ (NSString*)iphoneType {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    if([platform isEqualToString:@"iPhone1,1"])
        return@"iPhone 2G";
    if([platform isEqualToString:@"iPhone1,2"])
        return@"iPhone 3G";
    if([platform isEqualToString:@"iPhone2,1"])
        return@"iPhone 3GS";
    if([platform isEqualToString:@"iPhone3,1"])
        return@"iPhone 4";
    if([platform isEqualToString:@"iPhone3,2"])
        return@"iPhone 4";
    if([platform isEqualToString:@"iPhone3,3"])
        return@"iPhone 4";
    if([platform isEqualToString:@"iPhone4,1"])
        return@"iPhone 4S";
    if([platform isEqualToString:@"iPhone5,1"])
        return@"iPhone 5";
    if([platform isEqualToString:@"iPhone5,2"])
        return@"iPhone 5";
    if([platform isEqualToString:@"iPhone5,3"])
        return@"iPhone 5c";
    if([platform isEqualToString:@"iPhone5,4"])
        return@"iPhone 5c";
    if([platform isEqualToString:@"iPhone6,1"])
        return@"iPhone 5s";
    if([platform isEqualToString:@"iPhone6,2"])
        return@"iPhone 5s";
    if([platform isEqualToString:@"iPhone7,1"])
        return@"iPhone 6 Plus";
    if([platform isEqualToString:@"iPhone7,2"])
        return@"iPhone 6";
    if([platform isEqualToString:@"iPhone8,1"])
        return@"iPhone 6s";
    if([platform isEqualToString:@"iPhone8,2"])
        return@"iPhone 6s Plus";
    if([platform isEqualToString:@"iPhone8,4"])
        return@"iPhone SE";
    if([platform isEqualToString:@"iPhone9,1"])
        return@"iPhone 7";
    if([platform isEqualToString:@"iPhone9,2"])
        return@"iPhone 7 Plus";
    if([platform isEqualToString:@"iPhone10,1"])
        return@"iPhone 8";
    if([platform isEqualToString:@"iPhone10,4"])
        return@"iPhone 8";
    if([platform isEqualToString:@"iPhone10,2"])
        return@"iPhone 8 Plus";
    if([platform isEqualToString:@"iPhone10,5"])
        return@"iPhone 8 Plus";
    if([platform isEqualToString:@"iPhone10,3"])
        return@"iPhone X";
    if([platform isEqualToString:@"iPhone10,6"])
        return@"iPhone X";
    if ([platform isEqualToString:@"iPhone11,8"])
        return @"iPhone XR";
    if ([platform isEqualToString:@"iPhone11,2"])
        return @"iPhone XS";
    if ([platform isEqualToString:@"iPhone11,6"])
        return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone11,4"])
        return @"iPhone XS Max";
    if([platform isEqualToString:@"iPod1,1"])
        return@"iPod Touch 1G";
    if([platform isEqualToString:@"iPod2,1"])
        return@"iPod Touch 2G";
    if([platform isEqualToString:@"iPod3,1"])
        return@"iPod Touch 3G";
    if([platform isEqualToString:@"iPod4,1"])
        return@"iPod Touch 4G";
    if([platform isEqualToString:@"iPod5,1"])
        return@"iPod Touch 5G";
    if([platform isEqualToString:@"iPad1,1"])
        return@"iPad 1G";
    if([platform isEqualToString:@"iPad2,1"])
        return@"iPad 2";
    if([platform isEqualToString:@"iPad2,2"])
        return@"iPad 2";
    if([platform isEqualToString:@"iPad2,3"])
        return@"iPad 2";
    if([platform isEqualToString:@"iPad2,4"])
        return@"iPad 2";
    if([platform isEqualToString:@"iPad2,5"])
        return@"iPad Mini 1G";
    if([platform isEqualToString:@"iPad2,6"])
        return@"iPad Mini 1G";
    if([platform isEqualToString:@"iPad2,7"])
        return@"iPad Mini 1G";
    if([platform isEqualToString:@"iPad3,1"])
        return@"iPad 3";
    if([platform isEqualToString:@"iPad3,2"])
        return@"iPad 3";
    if([platform isEqualToString:@"iPad3,3"])
        return@"iPad 3";
    if([platform isEqualToString:@"iPad3,4"])
        return@"iPad 4";
    if([platform isEqualToString:@"iPad3,5"])
        return@"iPad 4";
    if([platform isEqualToString:@"iPad3,6"])
        return@"iPad 4";
    if([platform isEqualToString:@"iPad4,1"])
        return@"iPad Air";
    if([platform isEqualToString:@"iPad4,2"])
        return@"iPad Air";
    if([platform isEqualToString:@"iPad4,3"])
        return@"iPad Air";
    if([platform isEqualToString:@"iPad4,4"])
        return@"iPad Mini 2G";
    if([platform isEqualToString:@"iPad4,5"])
        return@"iPad Mini 2G";
    if([platform isEqualToString:@"iPad4,6"])
        return@"iPad Mini 2G";
    if([platform isEqualToString:@"iPad4,7"])
        return@"iPad Mini 3";
    if([platform isEqualToString:@"iPad4,8"])
        return@"iPad Mini 3";
    if([platform isEqualToString:@"iPad4,9"])
        return@"iPad Mini 3";
    if([platform isEqualToString:@"iPad5,1"])
        return@"iPad Mini 4";
    if([platform isEqualToString:@"iPad5,2"])
        return@"iPad Mini 4";
    if([platform isEqualToString:@"iPad5,3"])
        return@"iPad Air 2";
    if([platform isEqualToString:@"iPad5,4"])
        return@"iPad Air 2";
    if([platform isEqualToString:@"iPad6,3"])
        return@"iPad Pro 9.7";
    if([platform isEqualToString:@"iPad6,4"])
        return@"iPad Pro 9.7";
    if([platform isEqualToString:@"iPad6,7"])
        return@"iPad Pro 12.9";
    if([platform isEqualToString:@"iPad6,8"])
        return@"iPad Pro 12.9";
    if([platform isEqualToString:@"i386"])
        return@"iPhone Simulator";
    if([platform isEqualToString:@"x86_64"])
        return@"iPhone Simulator";
    return platform;
}


+ (void)uploadSystemInfo {
    /**
    NSDictionary *data = DictMake(
                                  @"phoneModel",[self iphoneType],
                                  @"phoneBrand",@"APPLE",
                                  @"productName",[UIDevice currentDevice].model,
                                  @"systemVersion",[[UIDevice currentDevice] systemVersion],         //获取手机系统版本号
                                  @"equipmentIp",[self getIPAddress:YES],           //设备主机地址
                                  @"manufName",@"Apple",             //手机制造商
                                  @"phoneImsi",[self getIMSI],             //手机 IMSI 号
                                  //@"phoneNumber",[ESLoginManager shared].LoginModel.user.mobile,           //手机号码
                                  //@"screenHeight",@(ScreenHeight),          //获取手机屏幕高度（像素）
                                  //@"screenWidth",@(ScreenWidth),           //获取手机屏幕宽度（像素）
                                  @"programPackage",@"向日葵阅读-学生端",        //程序包名称
                                  @"programVersion",[NSBundle.mainBundle.infoDictionary objectForKey:@"CFBundleShortVersionString"],
                                  @"source",@(1),nil);
    
    ESDeviceAdapter *adapter = [[ESDeviceAdapter alloc] init];
    adapter.parameters = DictMake(@"deviceInfo",[data mj_JSONString]);
    [[ESNetProvider request:adapter] subscribeNext:^(id  _Nullable x) {
        NSLog(@"上传设备信息成功");
    } error:^(NSError * _Nullable error) {
        NSLog(@"上传设备信息失败");
    }];
     */
    
}


#pragma mark --------------------------- IP地址 ------------------------------
//获取设备当前网络IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4 {
    NSArray *searchArray = preferIPv4 ?
    @[ /*IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6,*/ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ /*IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4,*/ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        address = addresses[key];
        if(address) *stop = YES;
    }];
    return address ? address : @"0.0.0.0";
}

//获取所有相关IP信息
+ (NSDictionary *)getIPAddresses {
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}


#pragma mark --------------------------- IMSI ------------------------------
+ (NSString *)getIMSI{
    
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    
    CTCarrier *carrier = [info subscriberCellularProvider];
    
    NSString *mcc = [carrier mobileCountryCode];
    NSString *mnc = [carrier mobileNetworkCode];
    
    NSString *imsi = [NSString stringWithFormat:@"%@%@", mcc, mnc];
    
    return imsi;
}

@end

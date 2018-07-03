//
//  GFDeviceInfo.m
//  GFAPP
//
//  Created by gaoyafeng on 2018/6/27.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import "GFDeviceInfo.h"

#import "SSKeychain.h"
#import "Reachability.h"

// 获取路由器mac地址
#import <SystemConfiguration/CaptiveNetwork.h>
#import <SystemConfiguration/SystemConfiguration.h>

//获取手机入网IP
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

// 获取mac地址
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>

// 获取手机类型（iphone6）
#import <sys/utsname.h>

// 获取当前设备可用内存及所占内存的头文件
#import <sys/sysctl.h>
#import <mach/mach.h>
#import <sys/mount.h>

// 获取sim卡信息
#import<CoreTelephony/CTTelephonyNetworkInfo.h>
#import<CoreTelephony/CTCarrier.h>

@implementation GFDeviceInfo

SingletonImplementation(GFDeviceInfo);

#define ServiceName @"cn.com.csyy"
#define Account @"csyy.serial"

+ (NSString *)getSerialNo {
    NSString *s = [self getSaveSerialNo];
    if (s) return s;
    s = [self saveSerialNo];
    return s;
}

+ (NSString *) saveSerialNo {
    // 产生一个序列号
    NSString *uuid = [[NSUUID UUID] UUIDString];
    // Keychain
    [SSKeychain setPassword:uuid forService:ServiceName account:Account];
    return uuid;
}

+ (NSString *) getSaveSerialNo {
    NSString *s = [SSKeychain passwordForService:ServiceName account:Account];
    return s;
}

+ (NSArray *) getAllSerial {
    return [SSKeychain allAccounts];
}
////网络类型
//+ (NSString *)getNetworkType{
//    // 状态栏是由当前app控制的，首先获取当前app
//    UIApplication *app = [UIApplication sharedApplication];
//    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
//    int type = 0;
//    for (id child in children) {
//        if ([child isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
//            type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
//        }
//    }
//    NSString *stateString = @"wifi";
//    switch (type) {
//        case 0:
//            stateString = @"notReachable";
//            break;
//        case 1:
//            stateString = @"2G";
//            break;
//        case 2:
//            stateString = @"3G";
//            break;
//        case 3:
//            stateString = @"4G";
//            break;
//        case 4:
//            stateString = @"LTE";
//            break;
//        case 5:
//            stateString = @"wifi";
//            break;
//        default:
//            break;
//    }
//    return stateString;
//}
//网络类型
+ (NSString *)getNetworkType{
    
    NSString *netconnType = @"";
    
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:// 没有网络
        {
            
            netconnType = @"no network";
        }
            break;
            
        case ReachableViaWiFi:// Wifi
        {
            netconnType = @"Wifi";
        }
            break;
            
        case ReachableViaWWAN:// 手机自带网络
        {
            // 获取手机网络类型
            CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
            
            NSString *currentStatus = info.currentRadioAccessTechnology;
            
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
                
                netconnType = @"GPRS";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
                
                netconnType = @"2.75G EDGE";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
                
                netconnType = @"3.5G HSDPA";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
                
                netconnType = @"3.5G HSUPA";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
                
                netconnType = @"2G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
                
                netconnType = @"HRPD";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
                
                netconnType = @"4G";
            }
        }
            break;
            
        default:
            break;
    }
    
    return netconnType;
}

//系统版本号
+ (NSString *)getIOSVersion
{
    float str = [[[UIDevice currentDevice] systemVersion] floatValue];
    NSString *string = [NSString stringWithFormat:@"%f",str];
    return string;
}
//客户端版本号
+(NSString *)getTheClientVersionNumber
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用软件版本
    NSString * appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *str = [NSString stringWithFormat:@"%@", appCurVersion];
    return str;
}
//分辨率
+ (NSString *)getTheResolutionOfThe
{
    int Height = (int)[UIScreen mainScreen].bounds.size.height;
    
    switch (Height) {
        case 480:
            return [NSString stringWithFormat:@"640x960"];
            break;
        case 568:
            return [NSString stringWithFormat:@"640x1136"];
            break;
        case 667:
            return [NSString stringWithFormat:@"750x1334"];
            break;
        case 736:
            return [NSString stringWithFormat:@"1080x1920"];
            break;
        default:
            return nil;
            break;
    }
}
// 获取入网ip
+ (NSString *)getDeviceIPAdress{
    
    //无线
    NSString *wifilocalIP = @"";
    
    //卡
    NSString *simcardlocalIp = @"";
    
    //代理
    NSString *agentlocalIp = @"";
    
    BOOL success;
    
    struct ifaddrs * addrs;
    
    const struct ifaddrs * cursor;
    
    NSMutableDictionary *ipTempDic = [NSMutableDictionary dictionary];
    
    
    success = getifaddrs(&addrs) == 0;
    
    if (success) {
        
        cursor = addrs;
        
        while (cursor != NULL) {
            
            // the second test keeps from picking up the loopback address
            
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
                
            {
                
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                
                //猜的无线
                
                if ([name isEqualToString:@"en0"] || [name isEqualToString:@"en1"] || [name isEqualToString:@"en2"])
                    
                {
                    
                    wifilocalIP = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
                    
                    [ipTempDic setObject:wifilocalIP forKey:@"wifilocalIP"];
                    
                    //NSLog(@"wifilocalIP：%@",wifilocalIP);
                    
                }
                
                //猜的卡
                
                else if ([name isEqualToString:@"pdp_ip0"] || [name isEqualToString:@"pdp_ip1"] || [name isEqualToString:@"pdp_ip2"])
                    
                {
                    
                    simcardlocalIp = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
                    
                    [ipTempDic setObject:simcardlocalIp forKey:@"simcardlocalIp"];
                    
                    //NSLog(@"simcardlocalIp：%@",simcardlocalIp);
                    
                }
                
                else if ([name isEqualToString:@"ppp0"] || [name isEqualToString:@"ppp01"] || [name isEqualToString:@"ppp02"])
                    
                {
                    
                    agentlocalIp = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
                    
                    [ipTempDic setObject:agentlocalIp forKey:@"agentlocalIp"];
                    
                    // NSLog(@"agentlocalIp：%@",agentlocalIp);
                    
                }
                
            }
            
            cursor = cursor->ifa_next;
            
        }
        
        freeifaddrs(addrs);
        
    }
    
    wifilocalIP = [ipTempDic objectForKey:@"wifilocalIP"];
    
    if (wifilocalIP == nil) {
        
        wifilocalIP = @"notfound";
        
    }
    
    simcardlocalIp = [ipTempDic objectForKey:@"simcardlocalIp"];
    
    if (simcardlocalIp == nil) {
        
        simcardlocalIp = @"notfound";
        
    }
    
    agentlocalIp = [ipTempDic objectForKey:@"agentlocalIp"];
    
    if (agentlocalIp == nil) {
        
        agentlocalIp = @"notfound";
        
    }
    
    //    NSLog(@"获取到的ip地址是*********：%@********",threeIpDic);
    if (![wifilocalIP isEqualToString:@"notfound"]) {
        return wifilocalIP;
    }else if (![simcardlocalIp isEqualToString:@"notfound"])
    {
        return simcardlocalIp;
    }else
    {
        return agentlocalIp;
    }
}

// 获取wifimac地址
+ (NSString *)getWiFiMac{
    
    NSString *ssid = @"";
    NSString *macIp = @"";
    CFArrayRef myArray =CNCopySupportedInterfaces();
    if (myArray != nil) {
        CFDictionaryRef myDict =CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray,0));
        if (myDict != nil) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            ssid = [dict valueForKey:@"SSID"];           //WiFi名称
            macIp = [dict valueForKey:@"BSSID"];     //Mac地址
        }
    }
    return macIp;
}

// 获取mac地址
+ (NSString *)getMacAddress {
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        free(buf);
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    
    // MAC地址带冒号
    // NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2),
    // *(ptr+3), *(ptr+4), *(ptr+5)];
    
    // MAC地址不带冒号
    NSString *outstring = [NSString
                           stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr + 1), *(ptr + 2), *(ptr + 3), *(ptr + 4), *(ptr + 5)];
    
    free(buf);
    
    return [outstring uppercaseString];
}

// 获取手机型号
+ (NSString *)iphoneType{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])  return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])  return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])  return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])  return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])  return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])  return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])   return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])  return @"iPhone Simulator";
    
    return platform;
    
}


// 获取总内存大小
+ (NSString *)getTotalMemorySize
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if (kernReturn != KERN_SUCCESS)
    {
        return @"内存暂不可用";
    }
    
    return [self fileSizeToString:((vm_page_size * vmStats.free_count + vm_page_size * vmStats.inactive_count+ vm_page_size * vmStats.active_count + vm_page_size * vmStats.wire_count))];
}
// 获取当前可用内存
+ (NSString *)getAvailableMemorySize
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if (kernReturn != KERN_SUCCESS)
    {
        return @"内存暂不可用";
    }
    
    return [self fileSizeToString:((vm_page_size * vmStats.free_count + vm_page_size * vmStats.inactive_count))];
}

// 获取总磁盘容量
+(NSString *)getTotalDiskSize
{
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_blocks);
    }
    return [self fileSizeToString:freeSpace];
}

// 获取可用磁盘容量
+(NSString *)getAvailableDiskSize
{
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_bavail);
    }
    return [self fileSizeToString:freeSpace];
}

// 内存转成字符串
+(NSString *)fileSizeToString:(unsigned long long)fileSize
{
    NSInteger KB = 1024;
    NSInteger MB = KB*KB;
    NSInteger GB = MB*KB;
    
    if (fileSize < 10)
    {
        return @"0 B";
        
    }else if (fileSize < KB)
    {
        return @"< 1 KB";
        
    }else if (fileSize < MB)
    {
        return [NSString stringWithFormat:@"%.1f KB",((CGFloat)fileSize)/KB];
        
    }else if (fileSize < GB)
    {
        return [NSString stringWithFormat:@"%.1f MB",((CGFloat)fileSize)/MB];
        
    }else
    {
        return [NSString stringWithFormat:@"%.1f GB",((CGFloat)fileSize)/GB];
    }
}

+ (NSString *)getCPUType{
    host_basic_info_data_t hostInfo;
    mach_msg_type_number_t infoCount;
    
    infoCount = HOST_BASIC_INFO_COUNT;
    host_info(mach_host_self(), HOST_BASIC_INFO, (host_info_t)&hostInfo, &infoCount);
    
    switch (hostInfo.cpu_type) {
        case CPU_TYPE_ARM:
            return @"CPU_TYPE_ARM";
            break;
            
        case CPU_TYPE_ARM64:
            return @"CPU_TYPE_ARM64";
            break;
            
        case CPU_TYPE_X86:
            return @"CPU_TYPE_X86";
            break;
            
        case CPU_TYPE_X86_64:
            return @"CPU_TYPE_X86_64";
            break;
            
        default:
            break;
    }
    return @"";
}




@end

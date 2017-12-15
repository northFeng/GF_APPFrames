//
//  GFURLRequest.h
//  MJExtension
//
//  Created by 高峰 on 2017/4/1.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "GFDescription.h"

#pragma mark - 注册相关的提示
 NSString * const _kGFRegistration                     =       @"正在注册";
 NSString * const _kGFRegistrationInfoCanNotNull       =       @"注册信息不能为空";
 NSString * const _kGFRegistSuccess                    =       @"注册成功";
 NSString * const _kGFPhoneIsRegist                    =       @"手机号已注册";

#pragma mark - 登录相关的提示
 NSString * const _kGFLogining                         =       @"正在登录";
 NSString * const _kGFLoginSuccess                     =       @"登录成功";
 NSString * const _kGFLoginFailure                     =       @"登录失败";

#pragma mark - 提交相关的提示
 NSString * const _kGFSubmission                       =       @"提交中";
 NSString * const _kGFSubmissionSuccess                =       @"提交成功";
 NSString * const _kGFSubmissionFailure                =       @"提交失败";

#pragma mark - 网络相关的提示
 NSString * const _kGFRequestTimeout                   =       @"请求超时";
 NSString * const _kGFNetworkAnomaly                   =       @"网络异常";
 NSString * const _kGFNoneNetwork                      =       @"无网络连接";
 NSString * const _kGFNetworkFailure                   =       @"网络连接失败";
 NSString * const _kGFNetworkFailureLaterOption        =       @"网络连接失败,请稍后重试";
 NSString * const _kGFCheckNetwork                     =       @"请检查网络设置";
 NSString * const _kGFNetworkChange3G                  =       @"已切换到非WiFi网络";
 NSString * const _kGFNetworkChangeWiFi                =       @"已切换到WiFi网络";
 NSString * const _kGFNoneNetworkIsNone                =       @"亲、当前无网络,请连接网络后重试";

#pragma mark - 密码相关的提示
 NSString * const _kGFPasswordFormatError              =       @"密码格式错误";
 NSString * const _kGFPasswordCanNotNull               =       @"密码不能为空";
 NSString * const _kGFPasswordNotEqual                 =       @"两次密码不一致";
 NSString * const _kGFPasswordFormatTip                =       @"请输入6-16位密码,区分大小写,不能使用空格";

#pragma mark - 修改相关的提示
 NSString * const _kGFModifySuccess                    =       @"修改成功";
 NSString * const _kGFModifyFailure                    =       @"修改失败";

#pragma mark - 绑定相关的提示
 NSString * const _kGFBinding                          =       @"正在绑定";
 NSString * const _kGFBindingSuccess                   =       @"账号绑定成功";

#pragma mark - 关注提示
 NSString * const _kGFHaveAttention                    =       @"已关注";
 NSString * const _kGFCancelAttention                  =       @"已取消关注";

#pragma mark - 文件相关的提示
 NSString * const _kGFFilesEmpty                       =       @"文件不存在";
 NSString * const _kGFFilesCreateFailure               =       @"文件创建失败";
 NSString * const _kGFFolderCreateFailure              =       @"文件夹创建失败";

#pragma mark - 删除相关的提示
 NSString * const _kGFDeleteSuccess                    =       @"删除成功";

#pragma mark - 昵称相关的提示
 NSString * const _kGFNickNameCanNotNull               =       @"昵称不能为空";
 NSString * const _kGFNickNameFormatTip                =       @"昵称为2-18位中英文、数字以及下划线";

#pragma mark - 下载相关的提示
 NSString * const _kGFNoneSureDownloadVideo            =       @"没有可以下载的视频";
 NSString * const _kGFNotEnoughStorageSpace            =       @"存储空间不足,视频无法下载";

#pragma mark - 头像相关的提示
 NSString * const _kGFIconModifyFailure                =       @"头像修改失败";

#pragma mark - 喜欢相关的提示
 NSString * const _kGFLikeSuccees                      =       @"已喜欢";
 NSString * const _kGFLikeCancel                    =       @"已取消";

#pragma mark - 分享相关的提示
 NSString * const _kGFSharedSuccees                    =       @"分享成功";
 NSString * const _kGFSharedFailure                    =       @"分享失败";

#pragma mark - 视频相关的提示
 NSString * const _kGFPlayerLocalVideo                 =       @"播放本地视频";

#pragma mark - 字符相关的提示
 NSString * const _kGFStringLengthOverflow             =       @"字符长度超出";

#pragma mark - 其他的提示
 NSString * const _kGFContentCanNotNull                =       @"内容不能为空";
 NSString * const _kGFScreenshotFailure                =       @"截图失败";
 NSString * const _kGFCacheCleaning                    =       @"正在清除缓存";
 NSString * const _kGFCacheSuccees                     =       @"清除成功";
 NSString * const _kGFOptipnsFailure                   =       @"操作失败";

@implementation GFDescription

@end

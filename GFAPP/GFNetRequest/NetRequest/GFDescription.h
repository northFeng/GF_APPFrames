//
//  GFURLRequest.h
//  MJExtension
//  信息 描述
//  Created by 高峰 on 2017/4/1.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GFDescription : NSObject

@end

#pragma mark - 注册相关的提示
/**
 *  正在注册
 */
extern NSString * const _kGFRegistration;
/**
 *  注册信息不能为空
 */
extern NSString * const _kGFRegistrationInfoCanNotNull;

/**
 *  注册成功
 */
extern NSString *const __kGFRegistSuccess;

/**
 *  手机号已注册
 */
extern NSString * const _kGFPhoneIsRegist;

#pragma mark - 登录相关的提示
/**
 *  正在登录
 */
extern NSString * const _kGFLogining;
/**
 *  登录成功
 */
extern NSString * const _kGFLoginSuccess;
/**
 *  登录失败
 */
extern NSString * const _kGFLoginFailure;

#pragma mark - 提交相关的提示
/**
 *  提交中
 */
extern NSString * const _kGFSubmission;
/**
 *  提交成功
 */
extern NSString * const _kGFSubmissionSuccess;
/**
 *  提交失败
 */
extern NSString * const _kGFSubmissionFailure;

#pragma mark - 网络相关的提示
/**
 *  请求超时
 */
extern NSString * const _kGFRequestTimeout;
/**
 *  网络异常
 */
extern NSString * const _kGFNetworkAnomaly;
/**
 *  无网络连接
 */
extern NSString * const _kGFNoneNetwork;
/**
 *  网络连接失败
 */
extern NSString * const _kGFNetworkFailure;
/**
 *  请检查网络设置
 */
extern NSString * const _kGFCheckNetwork;
/**
 *  网络连接失败,请稍后重试
 */
extern NSString * const _kGFNetworkFailureLaterOption;
/**
 *  已切换到3G网络
 */
extern NSString * const _kGFNetworkChange3G;
/**
 *  已切换到WiFi网络
 */
extern NSString * const _kGFNetworkChangeWiFi;
/**
 *  亲、当前无网络,请连接网络后重试
 */
extern NSString * const _kGFNoneNetworkIsNone;

#pragma mark - 密码相关的提示
/**
 *  密码格式错误
 */
extern NSString * const _kGFPasswordFormatError;
/**
 *  密码不能为空
 */
extern NSString * const _kGFPasswordCanNotNull;
/**
 *  两次密码不一致
 */
extern NSString * const _kGFPasswordNotEqual;
/**
 *  请输入6-16位密码,区分大小写,不能使用空格
 */
extern NSString * const _kGFPasswordFormatTip;

#pragma mark - 修改相关的提示
/**
 *  修改成功
 */
extern NSString * const _kGFModifySuccess;
/**
 *  修改失败
 */
extern NSString * const _kGFModifyFailure;

#pragma mark - 绑定相关的提示

/**
 *  正在绑定
 */
extern NSString * const _kGFBinding;
/**
 *  账号绑定成功
 */
extern NSString * const _kGFBindingSuccess;



#pragma mark - 关注提示
/**
 *  已关注
 */
extern NSString * const _kGFHaveAttention;
/**
 *  已取消关注
 */
extern NSString * const _kGFCancelAttention;


#pragma mark - 文件相关的提示
/**
 *  文件不存在
 */
extern NSString * const _kGFFilesEmpty;
/**
 *  文件创建失败
 */
extern NSString * const _kGFFilesCreateFailure;
/**
 *  文件夹创建失败
 */
extern NSString * const _kGFFolderCreateFailure;

#pragma mark - 删除相关的提示
/**
 *  删除成功
 */
extern NSString * const _kGFDeleteSuccess;

#pragma mark - 昵称相关的提示
/**
 *  昵称不能为空
 */
extern NSString * const _kGFNickNameCanNotNull;
/**
 *  昵称为2-18位中英文、数字以及下划线
 */
extern NSString * const _kGFNickNameFormatTip;

#pragma mark - 下载相关的提示
/**
 *  没有可以下载的视频
 */
extern NSString * const _kGFNoneSureDownloadVideo;
/**
 *  存储空间不足,视频无法下载
 */
extern NSString * const _kGFNotEnoughStorageSpace;

#pragma mark - 头像相关的提示
/**
 *  头像修改失败
 */
extern NSString * const _kGFIconModifyFailure;

#pragma mark - 喜欢相关的提示
/**
 *  喜欢成功
 */
extern NSString * const _kGFLikeSuccees;
/**
 *  取消喜欢
 */
extern NSString * const _kGFLikeCancel;

#pragma mark - 分享相关的提示
/**
 *  分享成功
 */
extern NSString * const _kGFSharedSuccees;
/**
 *  分享失败
 */
extern NSString * const _kGFSharedFailure;

#pragma mark - 视频相关的提示
/**
 *  播放本地视频
 */
extern NSString * const _kGFPlayerLocalVideo;
#pragma mark - 字符相关的提示
/**
 *  字符长度超出
 */
extern NSString * const _kGFStringLengthOverflow;


#pragma mark - 其他的提示
/**
 *  内容不能为空
 */
extern NSString * const _kGFContentCanNotNull;
/**
 *  截图失败
 */
extern NSString * const _kGFScreenshotFailure;
/**
 *  正在清除缓存
 */
extern NSString * const _kGFCacheCleaning;
/**
 *  清除成功
 */
extern NSString * const _kGFCacheSuccees;
/**
 *  操作失败
 */
extern NSString * const _kGFOptipnsFailure;

























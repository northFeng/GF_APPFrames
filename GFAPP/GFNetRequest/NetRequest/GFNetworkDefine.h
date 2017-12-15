//
//  GFNetworkDefine.h
//  网络封装
//
//  Created by XinKun on 2017/7/25.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#ifndef GFNetworkDefine_h
#define GFNetworkDefine_h

/**  网络请求SDK  */
#import "AFNetworking.h"

/** 信息 描述  */
#import "GFDescription.h"

/** 结果 */
#import "GFCommonResult.h"

/** 基础model */
#import "GFBaseModel.h"


/**
 *  网络状态定义
 */
typedef enum
{
    GF_NETWORK_STATUS_UNKNOWN = -1,
    GF_NETWORK_STATUS_NONE = 0,
    GF_NETWORK_STATUS_WiFi = 1,
    GF_NETWORK_STATUS_WWAN = 2
} GFNetworkStatus;


/**
 *  媒体类型定义
 */
typedef enum
{
    GF_MIME_TYPE_UNKNOWN = 0,
    GF_MIME_TYPE_JPEG    = 1,
    GF_MIME_TYPE_GIF     = 2,
    GF_MIME_TYPE_PNG     = 3
} GFMimeType;

/**
 *  网络层执行结果
 *
 *  @param result         结果信息
 *  @param responseObject 成功-返回网络数据 失败-返回nil
 *
 *
 */
typedef void(^GFNetRequestBackBlock)(GFCommonResult *result, id responseObject);



/** 网络请求 */
#import "GFNetRequest.h"



#endif /* GFNetworkDefine_h */

//
//  APPKeyChainManager.h
//  GFAPP
//  密码管理系统 Keychain 存储，只要系统不卸载，就一直存在（直接存储到系统中）
//  Created by 峰 on 2019/9/12.
//  Copyright © 2019 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPKeyChainManager : NSObject

/*!
 保存数据
 
 @data  要存储的数据
 @identifier 存储数据的标示
 */
+(BOOL)keyChainSaveData:(id)data withIdentifier:(NSString*)identifier;

/*!
 读取数据
 
 @identifier 存储数据的标示
 */
+(id)keyChainReadData:(NSString*)identifier;


/*!
 更新数据
 
 @data  要更新的数据
 @identifier 数据存储时的标示
 */
+(BOOL)keyChainUpdata:(id)data withIdentifier:(NSString*)identifier;

/*!
 删除数据
 
 @identifier 数据存储时的标示
 */
+(void)keyChainDelete:(NSString*)identifier;


@end

NS_ASSUME_NONNULL_END

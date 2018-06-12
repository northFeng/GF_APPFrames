//
//  PhotosOperation.h
//  GFAPP
//  系统相册操作
//  Created by gaoyafeng on 2018/6/12.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^blockGetImage)(NSArray *imageArray);

@interface PhotosOperation : NSObject


/**
 * 查询所有的图片
 */
- (void)searchAllImages:(blockGetImage)blockImages;


/**
 * 保存图片到相册  saveImage:保存的iamge photoName:保存到的相册名字
 */
- (void)saveImage:(UIImage *)saveImage photoName:(NSString *)photoName;

@end

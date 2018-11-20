//
//  GFModel.h
//  GFAPP
//
//  Created by gaoyafeng on 2018/11/19.
//  Copyright © 2018 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GFModel : NSObject

///title
@property (nonatomic,copy) NSString *title;

///副标题
@property (nonatomic,copy) NSString *subTitle;

///附加字符串
@property (nonatomic,copy) NSString *subString;

///subtitle
@property (nonatomic,copy) NSAttributedString *attributeStr;

///整数
@property (nonatomic,assign) NSInteger numCode;

///图片name
@property (nonatomic,strong) NSString *imgName;


@end

NS_ASSUME_NONNULL_END

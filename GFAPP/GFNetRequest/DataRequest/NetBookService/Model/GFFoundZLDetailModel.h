//
//  GFFoundZLDetailModel.h
//  Lawpress
//  专栏详情model
//  Created by XinKun on 2017/5/10.
//  Copyright © 2017年 彬万. All rights reserved.
//

#import "GFBaseModel.h"

@interface GFFoundZLDetailModel : GFBaseModel

///类型
@property (nonatomic,assign) NSInteger type;

///作者数组
@property (nonatomic,copy) NSArray *arrayAuthorList;

///专栏简介
@property (nonatomic,copy) NSString *brief;

///作者图片
@property (nonatomic,copy) NSString *imgUrl;

///文章列表数量
@property (nonatomic,copy) NSString *materialCnt;

///文章列表数据
@property (nonatomic,copy) NSArray *arrayMaterialList;

///价格
@property (nonatomic,copy) NSString *price;

///订阅量
@property (nonatomic,copy) NSString *subscribeCnt;

///标签数组
@property (nonatomic,copy) NSArray *tagList;

///标题
@property (nonatomic,copy) NSString *titleCn;

///价格
@property (nonatomic,copy) NSString *unit;


///是否已经加入喜欢
@property (nonatomic,assign) BOOL isLove;

///是否可以试读
@property (nonatomic,assign) BOOL isRead;

//副标题
@property (nonatomic,copy) NSString *subheadCn;
@property (nonatomic,copy) NSString *subheadEn;


@end

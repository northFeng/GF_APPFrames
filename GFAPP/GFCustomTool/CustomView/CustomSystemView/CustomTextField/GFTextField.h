//
//  GFTextField.h
//  GFAPP
//
//  Created by XinKun on 2018/1/3.
//  Copyright © 2018年 North_feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GFTextField : UITextField

///限制文字输入长度（汉语两个字节为一个汉字，英文一个单词为一个一字节）
@property (nonatomic,assign) NSInteger limitStringLength;

@end

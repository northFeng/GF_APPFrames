//
//  SLAddressBookHelp.h
//  AdressBook
//  通讯录操作！弹出通讯录！获取所有联系人信息
//  Created by 武传亮 on 2018/5/4.
//  Copyright © 2018年 武传亮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^SLAddressBookHelpModels)(NSArray *addressBookModels);
typedef void (^SLAddressNameBlock)(NSString *name, NSString *phone);

@interface SLAddressBookHelp : NSObject

+ (instancetype)sharedInstance;


///获取一个通讯信息
- (void)sl_getAddressNameWithController:(UIViewController *)vc addressName:(SLAddressNameBlock)addressName show:(BOOL)show;

///获取所有的通讯录信息
- (void)sl_getUserContacts:(UIViewController *)vc addressBookModels:(SLAddressBookHelpModels)addressBookModels;


@end


@interface SLAddressBookModel : NSObject

/**  */
@property (strong, nonatomic) NSString *name;
/**  */
@property (strong, nonatomic) NSArray *phones;

@end


/** 用法
[[SLAddressBookHelp sharedInstance] sl_getUserContacts:self addressBookModels:^(NSArray *addressBookModels) {
    
}];

[[SLAddressBookHelp sharedInstance] sl_getAddressNameWithController:self addressName:^(NSString *name, NSString *phone) {
    NSLog(@"name:   %@  phone:  %@", name, phone);
} show:NO];
 
 */








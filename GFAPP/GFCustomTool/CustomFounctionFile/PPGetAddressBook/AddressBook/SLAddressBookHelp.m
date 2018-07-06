//
//  SLAddressBookHelp.m
//  AdressBook
//
//  Created by 武传亮 on 2018/5/4.
//  Copyright © 2018年 武传亮. All rights reserved.
//

#import "SLAddressBookHelp.h"
#ifdef NSFoundationVersionNumber_iOS_8_x_Max
#import <ContactsUI/ContactsUI.h>
#endif
#import <AddressBookUI/ABPersonViewController.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/ABPeoplePickerNavigationController.h>


static NSString * const uploadData = @"upload_Data";


@interface SLAddressBookHelp ()<CNContactPickerDelegate, ABPeoplePickerNavigationControllerDelegate>


/**  */
@property (copy, nonatomic) SLAddressNameBlock addressNameBlock;

/**  */
@property (copy, nonatomic) SLAddressBookHelpModels addressBookModels;

@end


@implementation SLAddressBookHelp

static id _instance = nil;
+ (instancetype)sharedInstance {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
        
    });
    return _instance;
}


#pragma mark - 提示进行授权
- (void)sl_getAddressBookPermissions:(UIViewController *)vc {
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请授权钱***问通讯录" message:@"请前往  设置-->隐私-->通讯录  授权***获取本人通讯录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action_1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)  {
            NSDictionary *dic;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:dic completionHandler:nil];
        }else{
            NSURL*url = [NSURL URLWithString:@"prefs:root=About"];
            if ([[UIApplication sharedApplication] canOpenURL:url]){
                [[UIApplication sharedApplication] openURL:url];
            }
        }
        
    }];
    UIAlertAction *action_2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:action_1];
    [alertController addAction:action_2];
    
    [vc presentViewController:alertController animated:YES completion:nil];
    
}



#pragma mark - API接口触发
- (void)sl_getAddressNameWithController:(UIViewController *)vc addressName:(void (^)(NSString *name, NSString *phone))addressName show:(BOOL)show {
    
    self.addressNameBlock = addressName;
    
    if ([[UIDevice currentDevice].systemVersion floatValue ] >= 9.0 ) {
        
        // 1.获取授权状态
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        // 2.判断授权状态,如果不是已经授权,则直接返回
        if (status != CNAuthorizationStatusAuthorized) {
            
            if (show) [self sl_getAddressBookPermissions:vc];
            
        } else {
            if (@available(iOS 11.0, *)) {
                [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAutomatic];
            }
            
            //通讯录视图
            CNContactPickerViewController *contactVc = [[CNContactPickerViewController alloc] init];
            // 2.设置代理
            contactVc.delegate = self;
            // 3.弹出控制器
            [vc presentViewController:contactVc animated:YES completion:nil];
        }
        
        
    } else {
        
        if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
            
            if (show) [self sl_getAddressBookPermissions:vc];
            
        } else {
            
            ABPeoplePickerNavigationController *nav = [[ABPeoplePickerNavigationController alloc] init];
            nav.peoplePickerDelegate = self;
            nav.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
            [vc presentViewController:nav animated:YES completion:nil];
            
        }
    }
}

#pragma mark - 获取单个人的联系方式
#pragma mark - CNContactPickerDelegate >9.0以上版本
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker {
    
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

///选中联系人 （这个代理是通过联系人详情页面进行选取联系方式--------另一个代理在联系人列表选取就可以触发回调）
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    
    CNContact *contact = contactProperty.contact;
    // 获取姓名
    NSString *middleName = contact.middleName;
    if (middleName == nil) middleName = @"";
    NSString *familyName = contact.familyName;
    if (familyName == nil) familyName = @"";
    NSString *givenName = contact.givenName;
    if (givenName == nil) givenName = @"";
    //头像
    //NSData *iconData = contact.imageData;
    
    NSString *name = [NSString stringWithFormat:@"%@%@%@", familyName, middleName ,givenName];
    
    if (![contactProperty.value isKindOfClass:[CNPhoneNumber class]]) {
        
        NSLog(@"请选择正确手机号");
        
        return;
    }
    
    CNPhoneNumber *phoneNumber = contactProperty.value;
    NSString *Str = phoneNumber.stringValue;
    NSCharacterSet *setToRemove = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *phoneStr = [[Str componentsSeparatedByCharactersInSet:setToRemove] componentsJoinedByString:@""];
    
    ///去除手机格式前缀
    Str = [self sl_formatPhoneNumber:phoneStr];
    
    //进行回调
    if (self.addressNameBlock) self.addressNameBlock(name, Str);
    
    
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
}



#pragma mark - ABPeoplePickerNavigationControllerDelegate <9.0之前的代理

///跳到联系人详情页点击触发回调 （这个代理是通过联系人详情页面进行选取联系方式--------另一个代理在联系人列表选取就可以触发回调））
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    long index = ABMultiValueGetIndexForIdentifier(phone, identifier);
    NSString *phoneNumber = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phone, index);
    
    phoneNumber = [self sl_formatPhoneNumber:phoneNumber];
    
    NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    if (firstName == nil) firstName = @"";
    NSString *midleName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonMiddleNameProperty);
    if (midleName == nil) midleName = @"";
    NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (lastName == nil) lastName = @"";
    
    
    NSString *totalName = [NSString stringWithFormat:@"%@%@%@", firstName, midleName, lastName];
    
    //回调
    if (self.addressNameBlock) self.addressNameBlock(totalName, phoneNumber);
    
    
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    
    CFRelease(phone);
}


///点击联系人列表触发回调
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person {
    
    //进入联系人详情页面
    ABPersonViewController *personViewController = [[ABPersonViewController alloc] init];
    personViewController.displayedPerson = person;
    
    [peoplePicker pushViewController:personViewController animated:YES];
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 获取所有的通讯录信息
- (void)sl_getUserContacts:(UIViewController *)vc addressBookModels:(SLAddressBookHelpModels)addressBookModels {
    
    
    self.addressBookModels = addressBookModels;
    
    if ([[UIDevice currentDevice].systemVersion floatValue ] >= 9.0 ) {
        [self sl_getUserContactsAboveSystemVersion9:vc];
    } else {
        [self sl_getUserContactsBelowSystemVersion9:vc];
    }
    
    
}

#pragma mark -
#pragma mark -- 大于等于9.0

//#ifdef NSFoundationVersionNumber_iOS_8_x_Max

//大于等于9.0
- (void)sl_getUserContactsAboveSystemVersion9:(UIViewController *)vc {
    
    //获取联系人
    //1创建联系人仓库
    CNContactStore *store = [[CNContactStore alloc] init];
    // 2.创建联系人的请求对象
    // keys决定这次要获取哪些信息,比如姓名/电话
    NSArray *fetchKeys = @[CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey];
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:fetchKeys];
    // 3.请求联系人
    NSError *error = nil;
    
    NSMutableArray *addressBookModels = [NSMutableArray new];
    
    [store enumerateContactsWithFetchRequest:request error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        
        SLAddressBookModel *addressBookModel = [SLAddressBookModel new];
        
        //stop决定是否要停
        // 获取姓名
        NSString *familyName = contact.familyName;
        if (familyName == nil) familyName = @"";
        NSString *givenName = contact.givenName;
        if (givenName == nil) givenName = @"";
        //头像
        //NSData *iconData = contact.imageData;
        
        NSString *name = [NSString stringWithFormat:@"%@%@", familyName ,givenName];
        //一个联系人对应多个电话号码，每个CNPhoneNumber对应一个电话Value
        NSArray *phones = contact.phoneNumbers;
        
        NSMutableArray *phonesArray = [NSMutableArray new];
        //遍历电话号码
        for (CNLabeledValue *labelValue in phones) {
            CNPhoneNumber *phoneNumber = labelValue.value;
            
            NSString *phone = phoneNumber.stringValue;
            //            phone = [NSString formatPhoneNumber:phone];
            
            [phonesArray addObject:phone];
            
        }
        
        addressBookModel.name = name;
        addressBookModel.phones = phonesArray;
        [addressBookModels addObject:addressBookModel];
        
        
    }];
    
    if (self.addressBookModels) self.addressBookModels(addressBookModels);
    
    // 1.获取授权状态
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    // 2.判断授权状态,如果不是已经授权,则直接返回
    if (status != CNAuthorizationStatusAuthorized) {
        
        [self sl_getAddressBookPermissions:vc];
        
    }
}

//#else

#pragma mark -
#pragma mark -- 小于iOS9.0

//小于iOS9.0
- (void)sl_getUserContactsBelowSystemVersion9:(UIViewController *)vc {
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    //用户授权
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        if (!error) {
            if (granted) {//允许
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self sl_fetchContactWithAddressBook:addressBook vc:vc];;
                });
            }else{//拒绝
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self sl_getAddressBookPermissions:vc];
                });
            }
        }else{
            NSLog(@"错误!");
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"授权通讯录出错");
            });
        }
    });
    
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
        
        [self sl_getAddressBookPermissions:vc];
        
    }
}

///获取所有联系人信息
- (void)sl_fetchContactWithAddressBook:(ABAddressBookRef)addressBook vc:(UIViewController *)vc {
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {////有权限访问
        //获取联系人数组
        CFArrayRef array = ABAddressBookCopyArrayOfAllPeople(addressBook);
        CFIndex count =  CFArrayGetCount(array);
        
        NSMutableArray *addressBookModels = [NSMutableArray new];
        
        for (int i = 0; i < count; i++) {
            
            SLAddressBookModel *addressBookModel = [SLAddressBookModel new];
            
            //获取联系人
            ABRecordRef people = CFArrayGetValueAtIndex(array, i);
            
            NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(people, kABPersonFirstNameProperty);
            if (firstName == nil) firstName = @"";
            NSString *midleName = (__bridge_transfer NSString *)ABRecordCopyValue(people, kABPersonMiddleNameProperty);
            if (midleName == nil) midleName = @"";
            NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(people, kABPersonLastNameProperty);
            if (lastName == nil) lastName = @"";
            
            NSString *name = [NSString stringWithFormat:@"%@%@%@", lastName, midleName, firstName];
            
            ABMutableMultiValueRef phoneNumRef = ABRecordCopyValue(people, kABPersonPhoneProperty);//联系方式
            NSMutableArray *phones = [NSMutableArray new];
            for (CFIndex i =0; i <ABMultiValueGetCount(phoneNumRef); i++) {
                CFStringRef phoneStr =   ABMultiValueCopyValueAtIndex(phoneNumRef, i);
                NSString *phone = (__bridge_transfer NSString *)(phoneStr);
                //该方法为去掉-（）等符号方法
                //                NSString *phoneNum =  [NSString formatPhoneNumber:phone];
                
                [phones addObject:phone];
                CFRelease(phoneStr);
            }
            
            addressBookModel.name = name;
            addressBookModel.phones = phones;
            
            [addressBookModels addObject:addressBookModel];
            
            
            CFRelease(people);
            
        }
        
        if (self.addressBookModels) self.addressBookModels(addressBookModels);
        
        CFRelease(array);
        
        
    } else {//无权限访问
        
        [self sl_getAddressBookPermissions:vc];
    }
}


#pragma mark - 去除号码格式
//去除号码格式
- (NSString *)sl_formatPhoneNumber:(NSString*)number
{
    number = [number stringByReplacingOccurrencesOfString:@"-"withString:@""];
    number = [number stringByReplacingOccurrencesOfString:@" "withString:@""];
    number = [number stringByReplacingOccurrencesOfString:@"("withString:@""];
    number = [number stringByReplacingOccurrencesOfString:@")"withString:@""];
    number = [number stringByReplacingOccurrencesOfString:@" "withString:@""];
    
    NSInteger len = number.length;
    if (len < 6)
    {
        return number;
    }
    
    if ([[number substringToIndex:2]isEqualToString:@"86"])
    {
        number = [number substringFromIndex:2];
    }
    else if([[number substringToIndex:3]isEqualToString:@"+86"])
    {
        number = [number substringFromIndex:3];
    }
    else if ([[number substringToIndex:4]isEqualToString:@"0086"])
    {
        number = [number substringFromIndex:4];
    }
    else if ([[number substringToIndex:5]isEqualToString:@"12593"])
    {
        number = [number substringFromIndex:5];
    }
    else if ([[number substringToIndex:5]isEqualToString:@"17951"])
    {
        number = [number substringFromIndex:5];
    }
    else if (len ==16 && [[number substringToIndex:6]isEqualToString:@"125201"])
    {
        number = [number substringFromIndex:5];
    }
    
    return number;
}

#pragma clang diagnostic pop

@end

@interface SLAddressBookModel ()

@end


@implementation SLAddressBookModel

@end


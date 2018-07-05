//
//  NQDPerfectInfoVC.m
//  NQD
//
//  Created by gaoyafeng on 2018/7/3.
//  Copyright © 2018年 魏仁欢. All rights reserved.
//

#import "NQDPerfectInfoVC.h"


//获取通讯录
/// iOS 9前的框架
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
/// iOS 9的新框架
#import <ContactsUI/ContactsUI.h>



@interface NQDPerfectInfoVC ()

///姓名
@property (weak, nonatomic) IBOutlet UITextField *tfName;

///身份证
@property (weak, nonatomic) IBOutlet UITextField *tfCardNum;

///手机号码
@property (weak, nonatomic) IBOutlet UITextField *tfphone;

///QQ维信号
@property (weak, nonatomic) IBOutlet UITextField *tfQQWeixin;

///居住地址
@property (weak, nonatomic) IBOutlet UITextField *tfHomeAddress;

///详细地址
@property (weak, nonatomic) IBOutlet UITextField *tfHomeDetail;

///下一步按钮
@property (weak, nonatomic) IBOutlet UIButton *btnNext;


@end

@implementation NQDPerfectInfoVC

- (void)popBack {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"资料补充";
    
    // 设置返回按钮
    UIImage *backImage = [UIImage imageNamed:@"back"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    leftItem.image = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    
    //请求数据
    [self getDataToNet];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //上传通讯录
        [self JudgeAddressBookPower];
    });
    
}

#pragma mark - 请求已填入的数据
- (void)getDataToNet{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *content = [[NSMutableDictionary alloc] init];
    
    [params setValue:content forKey:@"content"];
    
    //BBWeakSelf
    //[[BBUICommonToast sharedBBUICommonToast] showLoadingAnimation:[UIApplication sharedApplication].keyWindow];
//    [HttpTools postWithUrl:HTTPURL(@"/user/getSysUser") params:params success:^(id response) {
//
//        [[BBUICommonToast sharedBBUICommonToast] hiddenLoadingAnimation];
//
//        NSDictionary *dataDic = [response objectForKey:@"data"];
//        NSString *name = dataDic[@"realname"];
//        NSString *cardNum = dataDic[@"idCard"];
//        NSString *phoneNum = dataDic[@"mobile"];
//        weakSelf.tfName.text = name.length > 0 ? name : nil;
//        weakSelf.tfCardNum.text = cardNum.length > 0 ? cardNum : nil;
//        weakSelf.tfphone.text = phoneNum.length > 0 ? phoneNum : nil;
//
//    } fail:^(NSError *error) {
//        [[BBUICommonToast sharedBBUICommonToast] hiddenLoadingAnimation];
//        NSLog(@"%@",error);
//    }];
    
}




#pragma mark - 点击定位按钮
- (IBAction)onClickLocationAction:(id)sender {
    
//    if (_tfHomeAddress.text.length == 0) {
//        [[BBUICommonToast sharedBBUICommonToast] showTextToastView:@"请输入居住地址" superView:self.view afterDelay:1.0];
//    }else{
//        BBWeakSelf
//        NQDMapViewController *mapVC = [[NQDMapViewController alloc] init];
//        mapVC.searchStr = _tfHomeAddress.text;
//        mapVC.chooseAddressAction = ^(AMapPOI *poi,int type) {
//            weakSelf.tfHomeDetail.text = poi.name;
//        };
//        [self.navigationController pushViewController:mapVC animated:YES];
//    }
}


#pragma mark - 点击下一步按钮
- (IBAction)onClickNextBtnAction:(id)sender {

    
}



#pragma mark - 通讯录相关

//#define isUp_ios_9
- (void)JudgeAddressBookPower {
    ///获取通讯录权限，调用系统通讯录
    [self CheckAddressBookAuthorization:^(bool isAuthorized) {
        
        if (isAuthorized) {
            //弹出通讯录
            //[self callAddressBook];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                // 上传通讯录
                [self getContactList];
            });
            
        }else {
            NSLog(@"用户拒绝授权");
        }
    }];
}

#pragma mark - 弹出通讯录
// 弹出通讯录
- (void)callAddressBook{
    
    if (IOSAbove9) {
        CNContactPickerViewController *contactPicker = [[CNContactPickerViewController alloc] init];
        contactPicker.delegate = self;
        contactPicker.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
        [self presentViewController:contactPicker animated:YES completion:nil];
    }else {
        ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
        peoplePicker.peoplePickerDelegate = self;
        [self presentViewController:peoplePicker animated:YES completion:nil];
        
    }
}


///请求通讯录权限
- (void)CheckAddressBookAuthorization:(void (^)(bool isAuthorized))block {
    
    if (IOSAbove9) {
        CNContactStore * contactStore = [[CNContactStore alloc]init];
        if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined) {
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * __nullable error) {
                if (error)
                {
                    NSLog(@"Error: %@", error);
                }
                else if (!granted)
                {
                    
                    block(NO);
                }
                else
                {
                    block(YES);
                }
            }];
        }
        else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized){
            block(YES);
        }
        else {
            block(NO);
        }
    }else {
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
        
        if (authStatus == kABAuthorizationStatusNotDetermined)
        {
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error)
                    {
                        NSLog(@"Error: %@", (__bridge NSError *)error);
                    }
                    else if (!granted)
                    {
                        
                        block(NO);
                    }
                    else
                    {
                        block(YES);
                    }
                });
            });
        }else if (authStatus == kABAuthorizationStatusAuthorized)
        {
            block(YES);
        }else {
            block(NO);
            // NSLog(@"请到设置>隐私>通讯录打开本应用的权限设置");
        }
    }
}

#pragma mark -- CNContactPickerDelegate
// 点击cancle按钮时候就会调用
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
//  选中某一个联系人就会调用
//  注意：只要实现了这个方法, 就不会进行下一步操作(进入详情), iOS9的做法是默认返回NO
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
    
    NSLog(@"%s", __func__);
    //姓氏
    NSString *firstName = contact.familyName;
    //名字
    NSString *lastName = contact.givenName;
    NSLog(@"%@---%@", firstName, lastName);
    
    //电话信息
    NSArray *phones = contact.phoneNumbers;
    for (CNLabeledValue *phone in phones) {
        //电话号码详情
        CNPhoneNumber *phoneNum = phone.value;
        NSString *phoneStr = phoneNum.stringValue;
        phoneStr = [[self trim2:[self trim:phoneStr]] stringByReplacingOccurrencesOfString:@"+86" withString:@""];
        
//        if ([phoneStr isEqualToString:[UserDefault objectForKey:@"mobile"]]) {
//            [self showTextToastView:@"联系人手机号不能为注册手机号"];
//            return;
//        }
        
//        if ([chooseContactBtnType isEqualToString:@"1"]) {
//            _contentView.firstRelativePhoneTF.text = phoneStr;
//        }else {
//            _contentView.secondRelativePhoneTF.text = phoneStr;
//        }
        
    }
}



#pragma mark - 上传通讯录
//    上传用户通讯录
- (void)getContactList {
    
    //声明一个通讯簿的引用
    ABAddressBookRef addBook =ABAddressBookCreateWithOptions(NULL, NULL);;
    
    //获取所有联系人的数组
    CFArrayRef allLinkPeople = ABAddressBookCopyArrayOfAllPeople(addBook);
    //获取联系人总数
    CFIndex number = ABAddressBookGetPersonCount(addBook);
    
    if (number > 0) {
        
        // 数组 存全部的字典
        NSMutableArray *array = [[NSMutableArray alloc]init];
        // 进行遍历
        for (NSInteger i=0; i<number; i++) {
            
            // 字典存取联系人姓名和联系方式
            NSMutableDictionary *contactDict = [[NSMutableDictionary alloc]init];
            //获取联系人对象的引用
            ABRecordRef  people = CFArrayGetValueAtIndex(allLinkPeople, i);
            //获取当前联系人名字
            NSString*firstName=(__bridge NSString *)(ABRecordCopyValue(people, kABPersonFirstNameProperty));
            // NSLog(@"%@",firstName);
            // 联系人全称
            NSMutableString *name = [[NSMutableString alloc]init];
            
            //获取当前联系人姓氏
            NSString*lastName=(__bridge NSString *)(ABRecordCopyValue(people, kABPersonLastNameProperty));
            
            if (lastName) {
                [name appendString:lastName];
            }
            
            if (firstName) {
                [name appendString:firstName];
            }
            
            [contactDict setObject:name forKey:@"name"];
            //获取当前联系人的电话 数组
            NSMutableArray * phoneArr = [[NSMutableArray alloc]init];
            ABMultiValueRef phones= ABRecordCopyValue(people, kABPersonPhoneProperty);
            for (NSInteger j=0; j<ABMultiValueGetCount(phones); j++) {
                [phoneArr addObject:(__bridge NSString *)(ABMultiValueCopyValueAtIndex(phones, j))];
            }
            
            // 获取联系人电话  并且去掉 空格 -  +86
            if (phoneArr.count != 0) {
                NSString *phone = [phoneArr firstObject];
                if ([phone hasPrefix:@"+86"]) {
                    phone=  [phone stringByReplacingOccurrencesOfString:@"+86" withString:@""];
                }
                // 去掉空格
                phone = [self trim:phone];
                // 去掉 -
                phone = [self trim2:phone];
                
                [contactDict setObject:phone forKey:@"phone"];
            }
            
            [array addObject:contactDict];
            
        }
        
        //  将联系人数组转成json格式的字符串，发送给后台
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&parseError];
        
        NSString *contactsListStrM =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        contactsListStrM = [contactsListStrM stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        // contactsListStrM = [contactsListStrM stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        contactsListStrM = [contactsListStrM stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSDictionary *requestDict = [NSDictionary dictionaryWithObjectsAndKeys:contactsListStrM,@"contactStr", nil];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:requestDict forKey:@"content"];
        
        //上传获取到的通讯录信息
//        [HttpTools postWithUrl:HTTPURL(@"/sysUserContact/saveUserContact") params:params success:^(id response) {
//            //hasUploadContact = YES;
//        } fail:^(NSError *error) {
//            //hasUploadContact = NO;
//            NSLog(@"%@",error);
//        }];
        
    }
}

- (NSString*)trim:(NSString *)trim
{
    
    return [trim stringByReplacingOccurrencesOfString:@"  " withString:@""];
}
- (NSString*)trim2:(NSString *)trim2
{
    
    return [trim2 stringByReplacingOccurrencesOfString:@"-" withString:@""];
}





@end

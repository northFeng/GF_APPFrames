   //
//  PPDataHandle.m
//  PPAddressBook
//
//  Created by AndyPang on 16/8/17.
//  Copyright © 2016年 AndyPang. All rights reserved.
//

#import "PPAddressBookHandle.h"


@interface PPAddressBookHandle ()

@property(nonatomic,strong)NSMutableDictionary * ditcaddressbook;           // 存储用户的信息



#ifdef __IPHONE_9_0
/** iOS9之后的通讯录对象*/
@property (nonatomic, strong) CNContactStore *contactStore;
#endif

@end

@implementation PPAddressBookHandle

PPSingletonM(AddressBookHandle)


#pragma mark - 请求用户通讯录授权（如果已授权直接获取用户所有联系人信息）
- (void)requestAuthorizationWithSuccessBlock:(void (^)(void))success
{
    if(IOS9_LATER)
    {
#ifdef __IPHONE_9_0
        // 1.判断是否授权成功,若授权成功直接return
        if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized) return;
        // 2.创建通讯录
        //CNContactStore *store = [[CNContactStore alloc] init];
        // 3.授权
        
        __weak PPAddressBookHandle * weakself = self;
        
        [self.contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                NSLog(@"授权成功"); success();
                
                weakself.isContacts = @"0";
                
                [weakself.addressbookArr removeAllObjects];
                [weakself getAddressBookDataSource:^(PPPersonModel *model) {
                    
                    [weakself.addressbookArr addObject:model];
                    
                } authorizationFailure:^{
                    
                    NSLog(@"获取用户的信息失败");
                    
                }];
                
                
                
            }else{
                NSLog(@"授权失败");
                
                weakself.isContacts = @"1";
            }
        }];
#endif
    }
    else
    {
        // 1.获取授权的状态
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        // 2.判断授权状态,如果是未决定状态,才需要请求
        if (status == kABAuthorizationStatusNotDetermined) {
            // 3.创建通讯录进行授权
            
            __weak PPAddressBookHandle * weakself = self;
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                if (granted) {
                    NSLog(@"授权成功"); success();
                    
                    weakself.isContacts = @"0";
                     [weakself.addressbookArr removeAllObjects];
                    [weakself getAddressBookDataSource:^(PPPersonModel *model) {
                        
                        [weakself.addressbookArr addObject:model];
                        
                    } authorizationFailure:^{
                        
                        NSLog(@"获取用户的信息失败");
                        
                    }];
                    
                } else {
                    NSLog(@"授权失败");
                    
                    weakself.isContacts = @"1";
                }
                
            });
        }
        
    }
    
}


#pragma mark - 获取联系人信息
- (void)getAddressBookDataSource:(PPPersonModelBlock)personModel authorizationFailure:(AuthorizationFailure)failure
{
    
    if(IOS9_LATER)
    {
        [self getDataSourceFrom_IOS9_Later:personModel authorizationFailure:failure];
    }
    else
    {
        [self getDataSourceFrom_IOS9_Ago:personModel authorizationFailure:failure];
    }
    
}

#pragma mark - IOS9之前获取通讯录的方法
- (void)getDataSourceFrom_IOS9_Ago:(PPPersonModelBlock)personModel authorizationFailure:(AuthorizationFailure)failure
{
    // 1.获取授权状态
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    
    // 2.如果没有授权,先执行授权失败的block后return
    if (status != kABAuthorizationStatusAuthorized/** 已经授权*/)
    {
        failure ? failure() : nil;
        return;
    }
    
    // 3.创建通信录对象
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    //4.按照排序规则从通信录对象中请求所有的联系人,并按姓名属性中的姓(LastName)来排序
    ABRecordRef recordRef = ABAddressBookCopyDefaultSource(addressBook);
    CFArrayRef allPeopleArray = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, recordRef, kABPersonSortByLastName);
    
    // 5.遍历每个联系人的信息,并装入模型
    for(id personInfo in (__bridge NSArray *)allPeopleArray)
    {
        PPPersonModel *model = [PPPersonModel new];
        
        // 5.1获取到联系人
        ABRecordRef person = (__bridge ABRecordRef)(personInfo);
        
        // 5.2获取全名
        NSString *name = (__bridge_transfer NSString *)ABRecordCopyCompositeName(person);
        model.name = name.length > 0 ? name : @"无名氏" ;
        
        // 5.3获取头像数据
        NSData *imageData = (__bridge_transfer NSData *)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
        model.headerImage = [UIImage imageWithData:imageData];
        
        // 5.4获取每个人所有的电话号码
        ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        CFIndex phoneCount = ABMultiValueGetCount(phones);
        for (CFIndex i = 0; i < phoneCount; i++)
        {
            // 号码
            NSString *phoneValue = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, i);
            NSString *mobile = [self removeSpecialSubString:phoneValue];
            
            [model.mobileArray addObject: mobile ? mobile : @"空号"];
            
        }
        // 5.5将联系人模型回调出去
        personModel ? personModel(model) : nil;
        
        CFRelease(phones);
    }

    // 释放不再使用的对象
    CFRelease(allPeopleArray);
    CFRelease(recordRef);
    CFRelease(addressBook);
    
}

#pragma mark - IOS9之后获取通讯录的方法
- (void)getDataSourceFrom_IOS9_Later:(PPPersonModelBlock)personModel authorizationFailure:(AuthorizationFailure)failure
{
#ifdef __IPHONE_9_0
    // 1.获取授权状态
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    // 2.如果没有授权,先执行授权失败的block后return
    if (status != CNAuthorizationStatusAuthorized)
    {
        failure ? failure() : nil;
        return;
    }
    // 3.获取联系人
    // 3.1.创建联系人仓库
    //CNContactStore *store = [[CNContactStore alloc] init];
    
    // 3.2.创建联系人的请求对象
    // keys决定能获取联系人哪些信息,例:姓名,电话,头像等
    NSArray *fetchKeys = @[[CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName],CNContactPhoneNumbersKey,CNContactThumbnailImageDataKey];
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:fetchKeys];
    
    // 3.3.请求联系人
    [self.contactStore enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact,BOOL * _Nonnull stop) {
        
        // 获取联系人全名
        NSString *name = [CNContactFormatter stringFromContact:contact style:CNContactFormatterStyleFullName];
        
        // 创建联系人模型
        PPPersonModel *model = [PPPersonModel new];
        model.name = name.length > 0 ? name : @"无名氏" ;
        
        // 联系人头像
        model.headerImage = [UIImage imageWithData:contact.thumbnailImageData];
        
        // 获取一个人的所有电话号码
        NSArray *phones = contact.phoneNumbers;
        
        for (CNLabeledValue *labelValue in phones)
        {
            CNPhoneNumber *phoneNumber = labelValue.value;
            NSString *mobile = [self removeSpecialSubString:phoneNumber.stringValue];
            [model.mobileArray addObject: mobile ? mobile : @"空号"];
        }
        
        //将联系人模型回调出去
        personModel ? personModel(model) : nil;
    }];
    
#endif

}

//过滤指定字符串(可自定义添加自己过滤的字符串)
- (NSString *)removeSpecialSubString: (NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return string;
}

#pragma mark - lazy

#ifdef __IPHONE_9_0
- (CNContactStore *)contactStore
{
    if(!_contactStore)
    {
        _contactStore = [[CNContactStore alloc] init];
    }
    return _contactStore;
}
#endif



#pragma mark - 获取通讯录权限之后 上传到后台
// TB ----- 获取通讯录权限之后 上传到后台
-(void)TB_PushinfoAddressBookinfoandSuccess:(void (^)(id reslut))successblock andfailblock:(void (^)(id faileresult))failblock{
    
    NSMutableArray * tbarr = [NSMutableArray array];
    [tbarr removeAllObjects];

    
    for(PPPersonModel *model in self.addressbookArr){
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        [dict setValue:model.name forKey:@"displayName"];
        [dict setValue:model.mobileArray forKey:@"phoneNum"];
        [tbarr addObject:dict];
    }
    

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tbarr options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData)
    {
        NSLog(@"%@",error);
    }
    else
    {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *phone = [defaults objectForKey:@"phone"];
    
    [params setValue:@"1" forKey:@"clientType"];
    [params setValue:phone forKey:@"telNo"];
    [params setValue:token forKey:@"token"];
    [params setValue:self.sspassword forKey:@"spPassword"];
    // 通讯录
    [params setValue:jsonString forKey:@"contacts"];
    [params setValue:self.isContacts forKey:@"isContacts"];
    [params setValue:self.locaionstr forKey:@"location"];
    [params setValue:self.isLocation forKey:@"isLocation"];
    [params setValue:@"" forKey:@"messgae"];
    
    [params setValue:@"" forKey:@"isMessgae"];
    
    params = [self convertToJsonData:params];
    
//    [NetworkRequestEncapsulation Post:HTTPURL(@"user_info/oauth_mobile_submit") params:params success:^(id reslut) {
//        
//        NSLog(@"reslurt--%@",reslut);
//        successblock(reslut);
//        
//    } filaure:^(NSError *error) {
//        
//        NSLog(@"error--%@",error.localizedDescription);
//        
//        failblock(error);
//        
//    }];
}


-(NSMutableDictionary *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData)
    {
        NSLog(@"%@",error);
    }
    else
    {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:mutStr forKey:@"content"];
    return dic;
}


-(NSMutableDictionary *)ditcaddressbook
{
    if(!_ditcaddressbook){
        _ditcaddressbook = [[NSMutableDictionary alloc]init];
    }
    return _ditcaddressbook;
}

-(NSMutableArray *)addressbookArr
{
    if(!_addressbookArr){
    
        _addressbookArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _addressbookArr;
}


#pragma mark-------------

-(BOOL)TB_ChargeIsAddressBookAuthorization{

    
    return [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized ? YES : NO;
}



@end

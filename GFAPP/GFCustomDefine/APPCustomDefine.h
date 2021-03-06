//
//  APPCustomDefine.h
//  GFAPP
//
//  Created by XinKun on 2017/11/10.
//  Copyright © 2017年 North_feng. All rights reserved.
//

/**
 *
 *  常量命名规则（驼峰式命名规则），所有的单词首字母大写和加上与类名有关的前缀:
 *
 */

#ifndef APPCustomDefine_h
#define APPCustomDefine_h


//.h
#define SingletonIterface(class) +(instancetype) shared##class;
// .m
#define SingletonImplementation(class)         \
static class *_instance;                        \
\
+(id) allocWithZone : (struct _NSZone *) zone { \
static dispatch_once_t onceToken;           \
dispatch_once(&onceToken, ^{                \
_instance = [super allocWithZone:zone]; \
});                                         \
\
return _instance;                           \
}                                               \
\
+(instancetype) shared##class                   \
{                                           \
if (_instance == nil) {                     \
_instance = [[class alloc] init];       \
}                                           \
\
return _instance;                            \
}



// iOS tableview 置顶
#define  KTableViewInsets_NO(scrollView,vc)\
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if ([UIScrollView instancesRespondToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
[scrollView   performSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:") withObject:@(2)];\
} else {\
vc.automaticallyAdjustsScrollViewInsets = NO;\
}\
_Pragma("clang diagnostic pop") \
} while (0)


#pragma mark - 常用自定义宏
//***********************************************
//**********      常用自定义宏      *************
//***********************************************

//APPManager单利
#define APPManagerObject [APPManager sharedInstance]

//APPManager用户信息
#define APPManagerUserInfo [APPManager sharedInstance].userInfo

///weakSelf宏定义  __weak typeof(self) weakSelf = self;
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define APPWeakSelf __weak __typeof(self) weakSelf = self;
#define APPStrongSel(weakSelf) __strong __typeof(weakSelf) strongSelf = weakSelf;

//************************************** weakSelf / strongSelf ************************************************
#ifndef weakSelf
#define weakSelf(...) \
gf_keywordify \
metamacro_foreach_cxt(gf_weakSelf_,, __weak, __VA_ARGS__)
#endif

#ifndef strongSelf
#define strongSelf(...) \
gf_keywordify \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
metamacro_foreach(gf_strongSelf_,, __VA_ARGS__) \
_Pragma("clang diagnostic pop")
#endif

#define gf_weakSelf_(INDEX, CONTEXT, VAR) \
CONTEXT __typeof__(VAR) metamacro_concat(VAR, _weak_) = (VAR);

#define gf_strongSelf_(INDEX, VAR) \
__strong __typeof__(VAR) VAR = metamacro_concat(VAR, _weak_);

#if DEBUG
#define gf_keywordify autoreleasepool {}
#else
#define gf_keywordify try {} @catch (...) {}
#endif

#ifndef onExit
#define onExit \
gf_keywordify \
__strong sd_cleanupBlock_t metamacro_concat(sd_exitBlock_, __LINE__) __attribute__((cleanup(sd_executeCleanupBlock), unused)) = ^
#endif

//**************************************************************************************

//网络宏
#define HTTPURL(url) [NSString stringWithFormat:@"%@%@",[APPKeyInfo hostURL],url]

//定义字典宏
#define DictMake(firstKey, ...)     [ESMutableDictionary makeWithObjectsAndKeys:firstKey, __VA_ARGS__, nil]

//空字符串处理
#define APPString(string) [string length] > 0 ? string : @""

//可变字典宏
#define DictMake(firstKey, ...) [ESMutableDictionary makeWithObjectsAndKeys:firstKey, __VA_ARGS__, nil]

/**
 GCD中信号量是dispatch_semaphore_t类型，支持信号通知和信号等待。每当发送一个信号通知，则信号量 +1,每当发送一个等待信号时信号量 -1。如果信号量为0则信号会处于等待状态，直到信号量大于0开始执行。根据这个原理我们可以初始化一个信号量变量，默认信号量设置为1，每当有线程进入“加锁代码”之后就调用信号等待命令（此时信号量为0）开始等待，此时其他线程无法进入，执行完后发送信号通知（此时信号量为1），其他线程开始进入执行，如此就达到了线程同步的目的。
 
 通俗的说我们可以理解成他是一个红绿灯的信号，当它的信号量为0时(红灯)等待，当信号量为1或大于1时(绿灯)走。
 创建信号量，参数：信号量的初值，如果小于0则会返回NULL
 dispatch_semaphore_create（信号量值）类似线程锁  dispatch_semaphore_create(1);
 
 @property (strong, nonatomic, nonnull) dispatch_semaphore_t objectLock;
 @property (strong, nonatomic) NSObject objectlockM; //
 
 用法： objectLock = dispatch_semaphore_create(1);
       kLOCK(objectLock);//加锁
       objectlockM 处理自己的任务
       kUNLOCK(objectLock);//解锁
 */
#define kLOCK(lock) dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);//信号量-1
#define kUNLOCK(lock) dispatch_semaphore_signal(lock);//信号量+1



//获取屏幕 宽度、高度 APP_SCREEN_WIDTH  APP_SCREEN_HEIGHT APP_StatusBar_Height
#define APP_SCREEN_BOUNDS   ([[UIScreen mainScreen] bounds])
#define kScreenWidth  ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define KSCALE [UIScreen mainScreen].bounds.size.width / 375.0
///y和x必须有一个为浮点型
#define kScaleHeight(y,x,width) (y)/(x)*(width)
#define kScaleW kScreenWidth/375.0
#define kScaleH kScreenHeight/667.0

//顶部条以及tabBar条的宽度，以及工具条距离安全区域的距离
#define APP_NaviBarHeight (kStatusBarHeight > 20 ? 88. : 64.)
#define APP_NaviBar_ItemBarHeight 44.
#define APP_TabBarHeight (kStatusBarHeight > 20 ? 83. : 49.)
#define APP_TabBar_ItemsHeight 49.

#define kTopNaviBarHeight (kStatusBarHeight > 20 ? 88. : 64.)
#define kTabBarHeight (kStatusBarHeight > 20 ? 83. : 49.)
#define kTabBarBottomHeight (kStatusBarHeight > 20 ? 34. : 0.)
//iphoneX适配差值
#define kiPhoneXSafeAreaDValue ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34:0)

/**
#define KStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define KNavBarHeight 44.0
#define KNav_StatusBarFrame (KNavBarHeight+KStatusBarHeight)
#define KTabbarHeight     ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49) // 适配iPhone x 底栏高度
#define KSafeAreaBottomHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34:0)
#define KTopHeight (KStatusBarHeight + KNavBarHeight)
 */


//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO)
//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
//是否是空对象或者内容为空
#define kObjectIsEmpty(_object) (_object == nil || [_object isKindOfClass:[NSNull class]] || ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) || ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))
//是否是空指针(对象)
#define kObjectIsEmptyEntity(_object) (_object == nil || [_object isKindOfClass:[NSNull class]])

//对象不为空
#define kObjectEntity(_object) (_object != nil && ![_object isKindOfClass:[NSNull class]])


#pragma mark -- 颜色RGB宏定义
//***************************************
//        颜色RGB宏定义
//***************************************
#define UIColorFromRGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define UIColorFromRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define UIColorFromSameRGBA(r,a) [UIColor colorWithRed:(r)/255.0f green:(r)/255.0f blue:(r)/255.0f alpha:(a)]

#define UIColorFromSameRGB(r) [UIColor colorWithRed:(r)/255.0f green:(r)/255.0f blue:(r)/255.0f alpha:1]

//rgb颜色转换（16进制->10进制）
#define UIColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


//简版
#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define RGBSA(r,a) [UIColor colorWithRed:(r)/255.0f green:(r)/255.0f blue:(r)/255.0f alpha:(a)]

#define RGBS(r) [UIColor colorWithRed:(r)/255.0f green:(r)/255.0f blue:(r)/255.0f alpha:1]

//rgb颜色转换（16进制->10进制）16进制开头:0x  8进制开头:0  2进制开头:无二进制形式，16进制数是替代2进制数的表达方式
//16进制输出—>%#X   10进制输出->%d  8进制输出->%#o  2进制输出->
#define RGBX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#pragma mark - 字体宏定义(账号信息中可存储字体信息，字体赋值通过宏定义方法)
//系统字体
#define kFontOfSystem(font) [UIFont systemFontOfSize:font]
//非系统字体
#define kFontOfCustom(name,font) [UIFont fontWithName:name size:font]

///标准字体
#define kRegularFont @"PingFangSC-Regular"
///中等字体
#define kMediumFont @"PingFangSC-Medium"
///半黑体
#define kSemiboldFont @"PingFangSC-Semibold"


#pragma mark -- 约束Masory重写
//***************************************
//        约束Masory重写
//***************************************
//左边
#define kMasonry_leftToLeft(view,offset) make.left.equalTo(view).offset(offset)
#define kMasonry_leftToRight(view,offset) make.left.equalTo(view.mas_right).offset(offset)
//右边
#define kMasonry_rightToRight(view,offset) make.right.equalTo(view).offset(offset)
//上边
#define kMasonry_topToTop(view,offset) make.top.equalTo(view).offset(offset)
#define kMasonry_topToBottom(view,offset) make.top.equalTo(view.mas_bottom).offset(offset)
//底边
#define kMasonry_bottomToBottom(view,offset) make.bottom.equalTo(view).offset(offset)
//宽高
#define kMasonry_width(length) make.width.mas_equalTo(length)
#define kMasonry_height(length) make.height.mas_equalTo(length)
#define kMasonry_widthAndHeight(length) make.width.and.height.mas_equalTo(length)
//限制宽高界限(小于等于&&大于等于)
#define kMasonry_widthLessThanOrEqualTo(length) make.width.mas_lessThanOrEqualTo(length)
#define kMasonry_widthGreaterThanOrEqualTo(length) make.width.mas_greaterThanOrEqualTo(length)
#define kMasonry_heightLessThanOrEqualTo(length) make.height.mas_lessThanOrEqualTo(length)
#define kMasonry_heightGreaterThanOrEqualTo(length) make.height.mas_greaterThanOrEqualTo(length)
//中心
#define kMasonry_center(view) make.center.equalTo(view)
#define kMasonry_centerX(view,offset) make.centerX.equalTo(view.mas_centerX).offset(offset)
#define kMasonry_centerY(view,offset) make.centerY.equalTo(view.mas_centerY).offset(offset)
//内嵌
#define kMasonry_edges(view,top,left,bottom,right) make.edges.equalTo(_naviBarView).insets(UIEdgeInsetsMake(top, left, bottom, right))

#pragma mark - 登录宏定义

#pragma mark - 常用颜色定义
//***************************************
//        常用颜色定义
//***************************************
#define kColor_BaseView_BackgroundColor [UIColor whiteColor]

#pragma mark - 图片加载宏
///url转换
#define kURLString(url) [NSURL URLWithString:url]

//文件路径转换URL
#define kFilePathUrl(path) [NSURL fileURLWithPath:path]


///赋值图片
#define kImgViewSetImage(imgView,url,placeholderName) [imgView sd_setImageWithURL:kURLString(url) placeholderImage:[UIImage imageNamed:placeholderName] options:SDWebImageRetryFailed]
///赋值GIF图片
#define kImgViewSetGifImage(imgView,gifName) imgView.image = [UIImage sd_animatedGIFWithData:[[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:gifName ofType:@"gif"]]]

#pragma mark - APP内主体常用颜色

///APP内主体黑色#41434E
#define APPColor_Black RGB(65,67,78)

///#333333
#define APPColor_BlackDeep RGBS(51)

///APP内主体深灰 999999 && 文字
#define APPColor_Gray RGBS(153)

///APP内tableView背景灰色 && cell分割间隔颜色 #F0F1F3
#define APPColor_Gray_tableView RGB(240,241,243)

///APP内浅灰 D8D8D8  (按钮条)
#define APPColor_lightGray RGBS(216)

//APP内主体白色
#define APPColor_White RGBS(255)

//APP内分割线灰色 #F3F4F4
#define APPColor_Line RGBS(241)

//APP内橘黄色
#define  APPColor_Orange RGB(255,164,79)

///APP内蓝色 #439BF7(旧的) #198FFB(二期)
#define  APPColor_Blue RGB(25,143,251)

///APP内按钮边框颜色 #E7E7E7
#define APPColor_Border RGBS(225)


#pragma mark - 二期颜色
///深灰色 #666666
#define APPColor_two_grayDeep RGBS(102)

///文字灰白色 #C9C9C9
#define APPColor_two_grayWhite RGBS(201)

///分割线 #EBEBEB
#define APPColor_two_Line RGBS(235)

///红色
#define APPColor_red RGB(255,4,3)

///橙红色
#define APPColor_organRed RGB(255,80,1)



#endif /* APPCustomDefine_h */

//
//  GFObject.h
//  Demo
//  分类和代理 加属性的处理   KVO的调试
//  Created by 峰 on 2019/10/15.
//  Copyright © 2019 峰. All rights reserved.
//

#import <Foundation/Foundation.h>



NS_ASSUME_NONNULL_BEGIN

@protocol GFDelegate <NSObject>

///代理中添加属性 名字
@property (nonatomic,copy) NSString *name;

///代理中添加属性 年龄
@property (nonatomic,copy) NSString *age;

@end

@interface GFObject : NSObject <GFDelegate>


+ (void)a123;


@end


///分类
@interface GFObject (Category)

///评语  不使用runtime
@property (nonatomic,copy) NSString *message;

///分类添加属性   使用runtime
@property (nonatomic,copy) NSString *score;


+ (void)a123;

@end



NS_ASSUME_NONNULL_END

/**
对象中 添加属性 系统会自动做的三件事：1、生成set和get方法声明
                              2、根据关键词 实现 set和get方法内部
                              3、生成成员变量！！

分类中可以添加实例方法、类方法、属性、协议。但是不能添加成员变量。 添加属性的话
只会生成!!!!!!—>set、get方法的声明  set/get内部不会实现！！！！（需要自己实现set/get方法内部方法—>相当于添加了两个 可以使用点语法!! 调用的方法）
也不会!! 生成下划线成员变量。只有使用runtime动态添加属性 才会生产 带下划线的成员变量！

分类加重复方法会覆盖旧的方法：系统是在运行时将分类中对应的实例方法、类方法等插入到了原来类或元类的方法列表中，且是在列表的前边！所以，方法调用时通过isa去对应的类或元类的列表中查找对应的方法时先查到的是分类中的方法！查到后就直接调用不在继续查找。这即是’覆盖’的本质！

多个分类调用顺序：这个是与编译顺序有关，最后编译的分类中对应的信息会在整合在类或元类对应列表的最前边。所以是调用最后编译的分类中的方法！可以查看Build Phases ->Complie Source 中的编译顺序！
 
 总结：分类 和 代理 中添加属性 ——>只能起到第一种作业，系统会自动声明 set和get 方法 ！！ 但是不会内部 不会实现!!，也不会生成  成员变量!!
*/

/**
GFObject *demo = [[GFObject alloc] init];
 
demo.name = @"肖大宝";
demo.age = @"20";
demo.score = @"100";

//--->肖大宝-->20岁-->100分--->很好
NSLog(@"--->%@-->%@岁-->%@分--->%@",demo.name,demo.age,demo.score,demo.message);
*/


#pragma mark - ************************* KVO调试 *************************
/**
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _demo = [[GFObject alloc] init];
    
    _demo.name = @"肖大宝";
    _demo.age = @"20";
    _demo.score = @"100";
    
    NSLog(@"添加监听前类型--demo-->%@----->%@",object_getClass(self.demo),[self.demo class]);
    //添加监听前类型--demo-->GFObject----->GFObject
    
    NSLog(@"添加KVO监听 属性set方法-->%p",[self.demo methodForSelector:@selector(setName:)]);
    //添加KVO监听 属性set方法-->0x1010dc980
    //调试输出 (Demo`-[GFObject setName:] at GFObject.m:20)
    
    [self getMehtodsOfClass:object_getClass(self.demo)];//输出监听前的对象方法列表
    
    //添加监听
    [self.demo addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
     
    
    NSLog(@"添加监听后类型--demo-->%@----->%@",object_getClass(self.demo),[self.demo class]);
    //添加监听后类型--demo-->NSKVONotifying_GFObject----->GFObject
    // NSKVONotifying_GFObject 是使用Runtime动态创建的一个类，是GFObject的子类.
    
    NSLog(@"添加KVO监听 属性set方法-->%p",[self.demo methodForSelector:@selector(setName:)]);
    //添加KVO监听 属性set方法-->0x7fff2564cec6   与上面对比发现，该方法内存地址已经变了
    //调试输出 (Foundation`_NSSetObjectValueAndNotify)
    
    [self getMehtodsOfClass:object_getClass(self.demo)];//输出监听后的对象方法列表
    
    
    
    [self.demo setValue:@"肖大宝" forKey:@"name"];
}


// KVO监听回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    NSLog(@"被监测对象%@ ——> 监听到%@的%@属性值改变了——>新值 %@ / 旧值 %@", self.demo,object, keyPath, change[@"new"],change[@"old"]);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //self.demo.name = [NSString stringWithFormat:@"大宝%d",arc4random()%100];
    //kVC也会触发KVO
    [self.demo setValue:[NSString stringWithFormat:@"大宝%d",arc4random()%100] forKey:@"name"];
    
    //手动触发 KVO
//    [self.demo willChangeValueForKey:@"name"];
//    [self.demo didChangeValueForKey:@"name"];
}


// 获取一个对象的所有方法
- (void)getMehtodsOfClass:(Class)cls{
    
    unsigned int count;
    Method *methods = class_copyMethodList(cls, &count);
    
    NSMutableString *methodList = [[NSMutableString alloc] init];
    for (int i=0; i < count; i++) {
        Method method = methods[i];
        NSString* methodName = NSStringFromSelector(method_getName(method));
        [methodList appendString:[NSString stringWithFormat:@"| %@",methodName]];
    }
    NSLog(@"%@对象-所有方法：%@",cls,methodList);
　　//C语言的函数是需要手动释放内存的喔
    free(methods);
}

  */

#pragma mark - ************************* NSKVONotifying_GFObject 派生类中伪代码实现 *************************

/**
#import "NSKVONotifying_GFObject.h"

// KVO的原理伪代码实现
@implementation NSKVONotifying_GFObject

- (void)setAge:(int)age{
    
    _NSSetIntValueAndNotify();
}

- (void)_NSSetIntValueAndNotify{
    
    // KVO的调用顺序
    [self willChangeValueForKey:@"age"];
    [super setAge:age];
    // KVO会在didChangeValueForKey里面调用age属性变更的通知回调
    [self didChangeValueForKey:@"age"];
}

- (void)didChangeValueForKey:(NSString *)key{

    // 通知监听器，某某属性值发生了改变
    [oberser observeValueForKeyPath:key ofObject:self change:nil context:nil];
}

// 会重写class返回父类的class
// 原因：1.为了隐藏这个动态的子类  2.为了让开发者不那么迷惑
- (Class)class{
    
    return [XGPerson class];
}

- (void)dealloc{
    
    // 回收工作
}

- (BOOL)_isKVOA{
    
    return YES;
}
 */

//
//  ViewController.m
//  GFAPP
//
//  Created by XinKun on 2017/4/21.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "ViewController.h"

#import "APPCoreDataManager.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSURL *url = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1510121288363&di=d567b20790d103d07f8941ab83ec6d32&imgtype=0&src=http%3A%2F%2Fi8.hexunimg.cn%2F2011-09-15%2F133395549.jpg"];
    [_imgView sd_setImageWithURL:url placeholderImage:nil options:0];
    

    //请求网络数据
//    [[APPNetRequestManager sharedInstance].bookService postItemListWithItemPage:1 resultBack:^(GFCommonResult *result, NSArray *items) {
//
//    }];
    
    NSMutableArray *muArray = [NSMutableArray array];
    NSArray *array1 = [NSArray array];
    NSArray *array2;
    
    
    
    if (kObjectIsEmpty(muArray)) {
        NSLog(@"该对象为空");
    }else{
        NSLog(@"该对象不为空");
    }
    //16761035
    self.view.backgroundColor = UIColorFromHex(16761035);
//    BOOL b = kObjectIsEmpty(array1)
//
//    BOOL c = kObjectIsEmpty(array2)
    
    NSLog(@"muarray:%@\n array1:%@ \n array2:%@",muArray,array1,array2);
    
    
    NSLog(@"%@ \n %@",kAPP_File_TempPath,NSHomeDirectory());
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 300, 50)];
    label.backgroundColor = [UIColor redColor];
    label.text = @"哈哈哈哈哈哈哈哈";
    label.font = kSizeOfCustom(@"song", 20);//kSizeOfSystem(18);
    [self.view addSubview:label];
    
    //default/com.hackemist.SDWebImageCache.default
}


- (IBAction)addModel:(id)sender {
    static NSInteger a = 100;
    a++;
    UseModel *model = [[UseModel alloc] init];
    model.userId = [NSString stringWithFormat:@"%ld",a];
    model.name = [NSString stringWithFormat:@"我是：%ld",a];
    model.createDate = @"2017-11-04";
    
    if ([[APPCoreDataManager sharedInstance].useService addModelInfo:model]) {
        
        NSLog(@"添加成功");
    }else{
        NSLog(@"添加失败");
    }
    
    
    NSLog(@"此刻网络状态：%@ \n 网络主路径:%@",[APPNetRequestManager sharedInstance].networkStatueDescribe,[APPNetRequestManager sharedInstance].netHostUrl);
    
}

- (IBAction)deleteModel:(id)sender {
    
    UseModel *model = [[UseService sharedService] getOneInfoUserId:@"110"];
    
    NSLog(@"%@/%@/%@",model.userId,model.name,model.createDate);
    
    [[UseService sharedService] removeEntityByUserId:model.userId];
    //退出程序
    //abort();
    exit(0);
}

- (IBAction)getAllModel:(id)sender {
    
    NSArray *array = [[APPCoreDataManager sharedInstance].useService getAllData];
    
    for (UseModel *model in array) {
        
        NSLog(@"%@/%@/%@",model.userId,model.name,model.createDate);
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

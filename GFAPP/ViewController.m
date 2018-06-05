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
    
    
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

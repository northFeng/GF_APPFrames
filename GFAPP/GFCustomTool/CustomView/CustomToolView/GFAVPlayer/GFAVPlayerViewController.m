//
//  GFAVPlayerViewController.m
//  GFAPP
//
//  Created by XinKun on 2017/12/6.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "GFAVPlayerViewController.h"

#import "GFAVPlayerView.h"

@interface GFAVPlayerViewController ()<GFAVPlayerViewDelegate>

@end

@implementation GFAVPlayerViewController
{
    GFAVPlayerView *_avPlayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.naviBar setLeftFirstButtonWithTitleName:@"返回"];
    
    
    //播放网络视频
    //http://120.25.226.186:32812/resources/videos/minion_01.mp4
    //http://ips.ifeng.com/video.ifeng.com/video04/2011/03/24/480x360_offline20110324.mp4
    NSString *filePath = @"http://120.25.226.186:32812/resources/videos/minion_01.mp4";
    NSURL *fileURL = [NSURL URLWithString:filePath];
    if (fileURL == nil) {
        fileURL = [NSURL URLWithString:[filePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    //CGRectMake(0, 100, kScreenWidth, 300)
    _avPlayer = [[GFAVPlayerView alloc] initWithFrame:CGRectMake(0, APP_NaviBarHeight, kScreenWidth, 300)];
    [_avPlayer playWith:fileURL withTitle:@"凤凰网视频"];
    _avPlayer.delegate = self;
    [self.view addSubview:_avPlayer];
    
}


//点击返回按钮
- (void)AVPlayerClickBackButtonOnAVPlayerView:(id)sender{
    
    NSLog(@"点击了返回");
    
}

//点击全屏按钮
- (void)AVPlayerClickFullScreenButtonOnAVPlayerView:(BOOL)sender{
    NSLog(@"全屏按钮");
    if (sender) {
        [UIView animateWithDuration:0.3 animations:^{
            [self setScreenInterfaceOrientationRight];
            _avPlayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            [self setScreenInterfaceOrientationDefault];
            _avPlayer.frame = CGRectMake(0, 100, kScreenWidth, 300);
        }];
    }
}


//工具条显示&&隐藏
- (void)AVPlayerToolBarViewShowOrHideOnAVPlayerView:(BOOL)sender{
    
    if (sender) {
        //隐藏
        NSLog(@"工具条隐藏");
        [self setStatusBarIsHide:sender];
    }else{
        //显示
        NSLog(@"工具条显示");
        [self setStatusBarIsHide:sender];
    }
    
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //    static BOOL a = YES;
    //    if (a) {
    //        [self setScreenInterfaceOrientationRight];
    //        a = NO;
    //    }else{
    //        [self setScreenInterfaceOrientationDefault];
    //        a = YES;
    //    }
    
}


//开启自动旋转屏幕
- (BOOL)shouldAutorotate{
    
    return YES;
}
//设置旋转屏幕为左横和右横
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskAllButUpsideDown;
}


///左侧第一个按钮
- (void)leftFirstButtonClick:(UIButton *)button{
    
    //默认这个为返回按钮
    
    [self popViewControllerWithRotateVC];
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  GFAudioPlayerViewController.m
//  GFAPP
//
//  Created by XinKun on 2017/12/8.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "GFAudioPlayerViewController.h"

#import "GFAudioPlayer.h"

//引入视频框架
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "GFCacheProgressSlider.h"

@interface GFAudioPlayerViewController ()<GFAudioPlayerDelegate>

///
@property (nonatomic,strong) GFAudioPlayer *audioPlayer;

///
@property (nonatomic,strong) GFCacheProgressSlider *progressSlider;

@end

@implementation GFAudioPlayerViewController
{
    BOOL _isTouch;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //初始化数据
    _isTouch = NO;
    _btnPlay.selected = YES;
    
    [self.naviBar setLeftFirstButtonWithTitleName:@"返回"];
    self.view.backgroundColor = [UIColor greenColor];
    
    _audioPlayer = [[GFAudioPlayer alloc] init];
    _audioPlayer.delegate = self;
    [_audioPlayer playWith:[NSURL URLWithString:@"http://119.254.198.163:8090/lpdpres/audio/20170929164414014.mp3"]];
    [_silder setThumbImage:[UIImage imageNamed:@"ic_audio_timeline@2x"] forState:0];
    
    
    _progressSlider = [GFCacheProgressSlider initWithCahcePreogress:[UIColor grayColor] bottomColor:[UIColor whiteColor] sliderTintColor:[UIColor blueColor]];
    //_progressSlider.frame = CGRectMake(CGRectGetMaxX(_currentTime.frame),12.5,frame.size.width-CGRectGetMaxX(_currentTime.frame)-40,15);
    _progressSlider.minimumValue = 0.0;
    _progressSlider.maximumValue = 1.0;
    //进度条的监控
    [_progressSlider addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    //[_progressSlider addTarget:self action:@selector(touchChange:) forControlEvents:UIControlEventValueChanged];
    [_progressSlider addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
    [_progressSlider setThumbImage:[UIImage imageNamed:@"ic_audio_timeline@2x"] forState:UIControlStateNormal];
    [self.view addSubview:_progressSlider];
    [_progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(100);
        make.centerY.equalTo(_silder.mas_centerY);
        make.height.mas_equalTo(20);
        make.right.equalTo(self.view).offset(-100);
    }];
    _silder.hidden = YES;
    
}

//进度条滑动开始
-(void)touchDown:(UISlider *)sl
{
    //[_audioPlayer pause];
    _isTouch = YES;
}

////进度条滑动
//-(void)touchChange:(UISlider *)sl
//{
//    //通过进度条控制播放进度
//    if (_audioPlayer) {
//
//    }
//}

//进度条滑动结束
-(void)touchUp:(UISlider *)sl{
    
    //进行滑动进度播放
    [_audioPlayer seekToTimeProgress:sl.value];
}


/**
 *  获取当前播放时间 && 当前播放进度 && 音频总时长
 */
- (void)AudioPlayerGetCurrentTime:(NSString *)currentTime currentProgress:(CGFloat)progress totalTime:(NSString *)totalTime{
    
    _labelCurrent.text = currentTime;
    _labelTotal.text = totalTime;
    
    //当播放进度 等于 滑动条的进度时
    if (progress == _progressSlider.value) {
        //滑动播放已经实现（这样就实现了，无缝滑动衔接）
        _isTouch = NO;
    }
    if (!_isTouch) {
        //没有触摸滑动条
        _silder.value = progress;
        _progressSlider.value = progress;
    }
}

/**
 *  获取媒体资源缓存进度
 */
- (void)AudioPlayerGetMideaCacheProgress:(CGFloat)cacheProgress{
    
    
    [_progressSlider setCacheProgressValue:cacheProgress];
}

/**
 *  当前音频播放完
 */
- (void)AudioPlayerPlayTheEnd{
    
    NSLog(@"音频播放完了");
    
}

- (void)AudioPlayerPlayStatus:(AudioPlayStatus)playStatus{
    
    switch (playStatus) {
        case AudioPlayStatusPaused:
            //暂停
            [self stopWaitingAnimating];
            break;
        case AudioPlayStatusPlaying:
            //播放
            [self stopWaitingAnimating];
            break;
        case AudioPlayStatusWaitingToPlayAtSpecifiedRate:
            //正在缓存加载
            [self startWaitingAnimating];
            break;
        default:
            break;
    }
    
}


- (IBAction)onClickBtnUp:(id)sender {
    
    
}

///点击播放按钮
- (IBAction)onClickBtnPlay:(id)sender {
    
    _btnPlay.selected = !_btnPlay.selected;
    
    if (_btnPlay.selected) {
        [_audioPlayer play];
    }else{
        [_audioPlayer pause];
    }
}

- (IBAction)onClickBtnNext:(id)sender {
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

//
//  GFAudioPlayer.m
//  GFAPP
//
//  Created by XinKun on 2017/12/8.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import "GFAudioPlayer.h"

@implementation GFAudioPlayer
{
    AVPlayer *_player;
    
    id _playTimeObserver;
}

+ (GFAudioPlayer *)sharedInstance
{
    static GFAudioPlayer *audioPlayer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioPlayer = [[GFAudioPlayer alloc] init];
    });
    return audioPlayer;
}

- (instancetype)init{
    if ([super init]) {
        
        /* 不使用这种方式进行横竖屏切换
         //监听横竖屏切换
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
         */
        
        //监听程序进入后台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)name:UIApplicationWillResignActiveNotification object:nil];
        
        //监听播放结束
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
        //监听音频播放中断
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieInterruption:) name:AVAudioSessionInterruptionNotification object:nil];
    }
    
    return self;
}



#pragma mark - 监听视频进行状态处理
//程序进入后台
- (void)applicationWillResignActive:(NSNotification *)notification {
    //[self pause];//暂停播放
}
//视频播放完毕
-(void)moviePlayDidEnd:(NSNotification *)notification
{
    NSLog(@"音频播放完毕！");//处理一个回调
    //暂停
    [self pause];
//    CMTime dur = _player.currentItem.duration;
//    [_player seekToTime:CMTimeMultiplyByFloat64(dur, 0.)];
    
    [self.delegate AudioPlayerPlayTheEnd];
    
}

//音频播放中断
- (void)movieInterruption:(NSNotification *)notification {
    
    //AVAudioSession音频输入模式类
    
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger interuptionType = [[interuptionDict valueForKey:AVAudioSessionInterruptionTypeKey] integerValue];
    NSNumber  *seccondReason  = [[notification userInfo] objectForKey:AVAudioSessionInterruptionOptionKey] ;
    switch (interuptionType) {
        case AVAudioSessionInterruptionTypeBegan:
        {
            //收到中断，停止音频播放
            [self pause];
            break;
        }
        case AVAudioSessionInterruptionTypeEnded:
            //系统中断结束
            [self play];
            break;
    }
    switch ([seccondReason integerValue]) {
        case AVAudioSessionInterruptionOptionShouldResume:
            //恢复音频播放
            [self play];
            break;
        default:
            break;
    }
}

#pragma mark - 播放和暂停
//播放
- (void)play {
    
    if (_player) {
        [_player play];
        
    }else{
        //证明没有加载，在此进行重新加载
        [self playWith:_aduioUrl];
    }
}

//暂停
- (void)pause {
    if (_player) {
        [_player pause];
    }
}

#pragma mark - AVPlayer的创建
- (void)playWith:(NSURL *)url{
    
    if (_aduioUrl.absoluteString == url.absoluteString && _player != nil) {
        //如果播放URL一样则，直接播放
        [self play];
        return ;
    }
    _aduioUrl = url;
    
    //加载视频资源的类
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    //AVURLAsset 通过tracks关键字会将资源异步加载在程序的一个临时内存缓冲区中
    [asset loadValuesAsynchronouslyForKeys:[NSArray arrayWithObject:@"tracks"] completionHandler:^{
        //能够得到资源被加载的状态
        AVKeyValueStatus status = [asset statusOfValueForKey:@"tracks" error:nil];
        //如果资源加载完成,开始进行播放
        /**
         AVKeyValueStatusUnknown,//未知状态
         AVKeyValueStatusLoading,//正在加载
         AVKeyValueStatusLoaded,//已经加载
         AVKeyValueStatusFailed,//加载失败
         AVKeyValueStatusCancelled//取消
         */
        if (status == AVKeyValueStatusLoaded) {
            //将加载好的资源放入AVPlayerItem 中，item中包含视频资源数据,视频资源时长、当前播放的时间点等信息
            AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
            
            //观察播放状态
            [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
            //AVPlayerItem
            //观察缓冲进度
            [item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
            
            if (_player) {
                [_player removeTimeObserver:_playTimeObserver];
                [_player replaceCurrentItemWithPlayerItem:item];
            }else {
                _player = [[AVPlayer alloc] initWithPlayerItem:item];
            }
            _player.volume = 1.0;
            //监测缓存状态
            [_player addObserver:self forKeyPath:@"timeControlStatus" options:NSKeyValueObservingOptionNew context:nil];
            
            //需要时时显示播放的进度
            //根据播放的帧数、速率，进行时间的异步(在子线程中完成)获取
            __weak AVPlayer *weakPlayer     = _player;
            __weak typeof(self) weakSelf    = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                //缓存清零
                [weakSelf.delegate AudioPlayerGetMideaCacheProgress:0];
            });
            //开始监听(这里面不断进行回调)---->返回的是这个函数的观察者，播放器销毁的时候要移除这个观察者
            _playTimeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
                //获取当前播放时间
                NSInteger current = CMTimeGetSeconds(weakPlayer.currentItem.currentTime);
                weakSelf.currentTime = current;
                float pro = current*1.0/weakSelf.duration;
                if (pro >= 0.0 && pro <= 1.0) {
                    
                    //赋值当前时间和进度条以及音频总时长
                    [weakSelf.delegate AudioPlayerGetCurrentTime:[weakSelf getTime:current] currentProgress:pro totalTime:[weakSelf getTime:weakSelf.duration]];
                    
                }
            }];
        }else if (status == AVKeyValueStatusFailed){
            NSLog(@"加载失败");
        }
        
    }];
    
}

#pragma mark - 相关监听（播放状态——>设置播放图层 && 缓存进度 && 缓存加载状态）
//监听播放开始
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    
    if ([object isKindOfClass:[AVPlayerItem class]]) {
        
        AVPlayerItem *item = (AVPlayerItem *)object;
        
        if ([keyPath isEqualToString:@"status"]) {
            NSLog(@"监测播放状态");
            switch (item.status) {
                case AVPlayerStatusReadyToPlay:{
                    //获取当前播放时间
                    NSInteger current = CMTimeGetSeconds(item.currentTime);
                    //总时间
                    self.duration = CMTimeGetSeconds(item.duration);
                    
                    float pro = current*1.0/self.duration;
                    if (pro >= 0.0 && pro <= 1.0) {
                        //_progressSlider.value  = pro;
                        //_currentTime.text      = [self getTime:current];
                        //_totalTime.text        = [self getTime:self.duration];
                        [self.delegate AudioPlayerGetCurrentTime:[self getTime:current] currentProgress:pro totalTime:[self getTime:self.duration]];
                    }
                    
                    //开始播放
                    [self play];
                    
                    //关闭等待视图
                    NSLog(@"缓存已满足，开始播放");
                }
                    break;
                case AVPlayerStatusFailed:{
                    NSLog(@"AVPlayerStatusFailed:加载失败，网络或者服务器出现问题");
                }
                    [self pause];
                    break;
                case AVPlayerStatusUnknown:{
                    NSLog(@"AVPlayerStatusUnknown:未知状态，此时不能播放");
                    [self pause];
                }
                    break;
                    
                default:
                    break;
            }
            
        } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
            //监听播放器的下载进度
            NSTimeInterval timeInterval = [self availableDuration];
            float pro = timeInterval/self.duration;
            if (pro >= 0.0 && pro <= 1.0) {
                //NSLog(@"缓冲进度：%f",pro);
                //设置缓存进度
                //[_progressSlider setCacheProgressValue:pro];
                [self.delegate AudioPlayerGetMideaCacheProgress:pro];
            }
        }
        
    }else if ([object isKindOfClass:[AVPlayer class]]){
        if ([keyPath isEqualToString:@"timeControlStatus"]) {
            //监测视频播放状态
            /**
             AVPlayerTimeControlStatusPaused,
             AVPlayerTimeControlStatusWaitingToPlayAtSpecifiedRate,
             AVPlayerTimeControlStatusPlaying
             */
            switch (_player.timeControlStatus) {
                case AVPlayerTimeControlStatusPaused:
                    NSLog(@"AVPlayerTimeControlStatusPaused:播放暂停");
                    [self.delegate AudioPlayerPlayStatus:AudioPlayStatusPaused];
                    break;
                case AVPlayerTimeControlStatusWaitingToPlayAtSpecifiedRate:
                    NSLog(@"AVPlayerTimeControlStatusWaitingToPlayAtSpecifiedRate:播放正在缓存");
                    //开始菊花(这里可以判断网络的状态，并进行触发自动停止播放&&提示用户网络状态不好)
                    //AVPlayerWaitingToMinimizeStallsReason没有缓存
                    NSLog(@"------>缓存原因：%@",_player.reasonForWaitingToPlay);
                    [self.delegate AudioPlayerPlayStatus:AudioPlayStatusWaitingToPlayAtSpecifiedRate];
                    break;
                case AVPlayerTimeControlStatusPlaying:
                    NSLog(@"AVPlayerTimeControlStatusPlaying:播放开始");
                    [self.delegate AudioPlayerPlayStatus:AudioPlayStatusPlaying];
                    break;
                default:
                    break;
            }
        }
    }
}

#pragma mark - 计算缓冲时间
//计算缓冲时间
- (CGFloat)availableDuration {
    //时间范围集合，玩家可以随时获得媒体数据
    NSArray *loadedTimeRanges = [_player.currentItem loadedTimeRanges];
    CMTimeRange range = [loadedTimeRanges.firstObject CMTimeRangeValue];
    CGFloat start = CMTimeGetSeconds(range.start);
    CGFloat duration = CMTimeGetSeconds(range.duration);
    return (start + duration);
}

//在调用视图的layer时，会自动触发layerClass方法，重写它，保证返回的类型是AVPlayerLayer
+ (Class)layerClass
{
    return [AVPlayerLayer class];
}


#pragma mark - 滑动进度条进行播放
- (void)seekToTimeProgress:(CGFloat)progress{
    
    CMTime dur = _player.currentItem.duration;
    float current = progress;
    //跳转到指定的时间
    [_player seekToTime:CMTimeMultiplyByFloat64(dur, current)];
    
}


#pragma mark - 换算时长
//将秒数换算成具体时长
- (NSString *)getTime:(NSInteger)second
{
    NSString *time;
    if (second < 60) {
        time = [NSString stringWithFormat:@"00:%02ld",(long)second];
    }
    else {
        if (second < 3600) {
            time = [NSString stringWithFormat:@"%02ld:%02ld",second/60,second%60];
        }
        else {
            time = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",second/3600,(second-second/3600*3600)/60,second%60];
        }
    }
    return time;
}

#pragma mark - 播放器销毁  记得移除相关Item
- (void)dealloc
{
    NSLog(@"playerView释放了,无内存泄漏");
    //移除注册的观察者
    [_player removeTimeObserver:_playTimeObserver];
    [_player.currentItem removeObserver:self forKeyPath:@"status"];
    [_player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    
    //播放状态
    [_player removeObserver:self forKeyPath:@"timeControlStatus"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

//
//  GFAudioPlayer.h
//  GFAPP
//  音频在线播放器
//  Created by XinKun on 2017/12/8.
//  Copyright © 2017年 North_feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//引入视频框架
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

/**
 *  音频播放状态
 */
typedef NS_ENUM(NSInteger,AudioPlayStatus) {
    /**
     *  暂停
     */
    AudioPlayStatusPaused = 0,
    /**
     *  播放
     */
    AudioPlayStatusPlaying,
    /**
     *  正在缓存
     */
    AudioPlayStatusWaitingToPlayAtSpecifiedRate,
};
///音频播放代理
@protocol GFAudioPlayerDelegate <NSObject>

/**
 *  获取当前播放时间 && 当前播放进度 && 音频总时长
 */
- (void)AudioPlayerGetCurrentTime:(NSString *)currentTime currentProgress:(CGFloat)progress totalTime:(NSString *)totalTime;

/**
 *  获取媒体资源缓存进度
 */
- (void)AudioPlayerGetMideaCacheProgress:(CGFloat)cacheProgress;

/**
 *  当前音频播放完
 */
- (void)AudioPlayerPlayTheEnd;

/**
 *  音频播放状态变化监听
 */
- (void)AudioPlayerPlayStatus:(AudioPlayStatus)playStatus;


@end

@interface GFAudioPlayer : NSObject

///代理
@property (nonatomic,weak) id <GFAudioPlayerDelegate>delegate;

///音频地址
@property (nonatomic,strong) NSURL *aduioUrl;

//视屏总时长
@property (nonatomic, assign) CGFloat duration;

///当前时长
@property (nonatomic,assign) CGFloat currentTime;


//单利
+ (GFAudioPlayer *)sharedInstance;

///从新播放音频
- (void)playWith:(NSURL *)url;


///播放
- (void)play;


///暂停
- (void)pause;


#pragma mark - 滑动进度条进行播放
- (void)seekToTimeProgress:(CGFloat)progress;


@end

/**
 //设置声音的播放冲突
 //可播放可录音，更可以后台播放，还可以在其他程序播放的情况下暂停播放
 AVAudioSession *session = [AVAudioSession sharedInstance];
 [session setCategory:AVAudioSessionCategoryPlayAndRecord
 withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker
 error:nil];
 */

//
//  GYPlayer.m
//  AVPlayer
//
//  Created by lanou on 16/4/18.
//  Copyright © 2016年 Gary_Cherry. All rights reserved.
//

#import "GYPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface GYPlayer ()
{
    BOOL _isPlaying; //标记是否正在播放
}

@property (nonatomic, strong) AVPlayer * player;
@property (nonatomic, strong) NSTimer * timer;

@end

@implementation GYPlayer

//播放器懒加载
- (AVPlayer *) player
{
    if (!_player)
    {
        self.player = [[AVPlayer alloc]init];
    }
    return _player;
}

//创建单例对象
+ (instancetype) sharedplayer
{
    static GYPlayer * player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[GYPlayer alloc]init];
    });
    return player;
}

//初始化方法注册通知
- (instancetype) init
{
    //AVPlayerItemDidPlayToEndTimeNotification是一个系统自带的通知
    if (self = [super init])
    {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleEndTimeNotification:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}

//播放完成调用
- (void) handleEndTimeNotification:(NSNotification *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioPlayerDidFinishPlaying:)])
    {
        [self.delegate audioPlayerDidFinishPlaying:nil];
    }
}

/*
 播放是在音乐播放页面使用的，其中点击播放或者暂停的按钮，就会用到该方法
 该类是对AVPlayer封装
 该方法是开始播放音乐的方法：对AVPlayer里面的play方法封装了一下，添加了一个定时器
 但是定时器里面有包含了很多东西，因为系统的AVPlayer的play方法只能起到让音乐开始的作用，但是我们的需求是让图片旋转，进度条走动，歌词跳动，时间改变等一系列东西，所以这些东西都要放在定时器里完成
 */

- (void) play
{
    _isPlaying = YES;
    [self.player play];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(handleTimerAction:) userInfo:nil repeats:YES];
}

- (void) handleTimerAction:(NSTimer *)sender
{
    //判断代理是否存在，并且是否对应该方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioPlayer:didPlayingWithProgress:)])
        
    {
        /*
         如果响应了，就让代理执行这个方法
         为什么要在这里写一个progress方法？
         因为在该类的内部可以计算出来进度条，而正好在播放的视图控制器里面需要用进度条，那么我们就可以使用协议传值到播放页面直接使用
         该方法的具体实现要写在播放页里面
         */
//         CMTime.value/timescale = seconds
        float progress = self.player.currentTime.value / self.player.currentTime.timescale;
        [self.delegate audioPlayer:self didPlayingWithProgress:progress];
    }
}

- (void) pause
{
    _isPlaying = NO;
    [self.player pause];
    //停止timer，而非移除
    [self.timer invalidate];
    self.timer = nil;
}

- (void) stop
{
    //停止的时候要先暂停
    [self pause];
    [self.player seekToTime:CMTimeMake(0, self.player.currentTime.timescale)];
}

//拖动音乐条的方法
- (void) seekToTime:(float)time
{
    //在拖动进度条的时候先暂停
    [self pause];
    /*
     CMTimeMakeWithSeconds第一个参数是拖动到哪里，第二个参数是总时间
     */
    [self.player seekToTime:CMTimeMakeWithSeconds(time, self.player.currentTime.timescale)completionHandler:^(BOOL finished) {
        //拖动结束后重新播放
        if (finished)
        {
            [self play];
        }
    }];
}

//判断当前音乐是否真正播放
- (BOOL) isPlaying
{
    return _isPlaying;
}

//根据URL切换歌曲
- (void) setPlayerWithUrl:(NSString *)urlString
{
    //根据URL创建一个歌曲的播放对象
    AVPlayerItem * currentItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlString]];
    //用刚创建一个新的播放对象替换原来的播放对象
    [self.player replaceCurrentItemWithPlayerItem:currentItem];
}

//判断当前正在播放歌曲的URL和给定的URL是否一样
- (BOOL) isPlayingCurrentPlayerWithUrl:(NSString *)urlString
{
    //将URL转化为字符串
    NSString * url = [(AVURLAsset *)self.player.currentItem.asset URL].absoluteString;
    BOOL isEqual = [url isEqualToString:urlString];
    return isEqual;
}

- (void) setVolume:(float)volume
{
    self.player.volume = volume;
}

@end

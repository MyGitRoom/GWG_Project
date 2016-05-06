//
//  GYPlayer.h
//  AVPlayer
//
//  Created by lanou on 16/4/18.
//  Copyright © 2016年 Gary_Cherry. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GYPlayer;
@protocol GYPlayerDelegate <NSObject>

@optional

//创建播放器和进度
- (void) audioPlayer:(GYPlayer *)player didPlayingWithProgress:(float)progress;

//已经播放完毕是执行的方法
- (void) audioPlayerDidFinishPlaying:(GYPlayer *)player;

@end

@interface GYPlayer : NSObject<GYPlayerDelegate>

@property (nonatomic) float volume; //播放音量

@property (nonatomic) id<GYPlayerDelegate>delegate; //设置代理

+ (instancetype) sharedplayer;

/*
 播放
 暂停
 停止
 */
- (void) play;
- (void) pause;
- (void) stop;

- (void) setPlayerWithUrl:(NSString *) urlString; //根据URL设置播放器
- (void) seekToTime:(float) time; //跳转到指定时间播放
- (BOOL) isPlaying; //判断当前是否正在播放
- (BOOL) isPlayingCurrentPlayerWithUrl:(NSString *) urlString; //判断是否正在播放指定音乐


@end

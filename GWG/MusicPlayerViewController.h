//
//  MusicPlayerViewController.h
//  GWG_Project
//
//  Created by lanou on 16/5/5.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataDetailModel.h"
#import "GYPlayer.h"

@interface MusicPlayerViewController : UITableViewController

//定义一个index用于接收当前需要播放第几首音乐
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic, strong) DataDetailModel * detailMod;

@end

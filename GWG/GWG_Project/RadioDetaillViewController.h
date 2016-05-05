//
//  RadioDetaillViewController.h
//  GWG_Project
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWorlRequestManager.h"

#define DETAILURL @"http://www.duole.fm/api/collect/get_sound_list?device=iphone&limit=15&app_version=2.0.5&sort=1&visitor_uid=0&page=1"

@interface RadioDetaillViewController : UIViewController

@property (nonatomic, strong) NSNumber * passId;

@end

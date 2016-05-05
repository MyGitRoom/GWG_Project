//
//  DataModel.h
//  GWG_Project
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * cover_url;
@property (nonatomic, strong) NSString * intro;
@property (nonatomic, strong) NSString * count_play;
@property (nonatomic, strong) NSNumber * identifier;

@end

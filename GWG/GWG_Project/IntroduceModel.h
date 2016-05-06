//
//  IntroduceModel.h
//  GWG_Project
//
//  Created by lanou on 16/5/6.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntroduceModel : NSObject

@property (nonatomic, strong) NSString * cover_url;
@property (nonatomic, strong) NSString * intro;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSDictionary * user;
@property (nonatomic, strong) NSArray * tags;

@end

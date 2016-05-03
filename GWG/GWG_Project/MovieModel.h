//
//  MovieModel.h
//  GWG_Project
//
//  Created by lanou on 16/4/30.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieModel : NSObject

@property (nonatomic ,strong) NSNumber *identifier ;//重写字段id
@property (nonatomic ,strong) NSString *name ; //电影类型
@property (nonatomic ,strong) NSString *img_url ;//图片URL ;

@end

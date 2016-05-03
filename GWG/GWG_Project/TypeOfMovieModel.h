//
//  TypeOfMovie.h
//  GWG_Project
//
//  Created by lanou on 16/4/30.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TypeOfMovieModel : NSObject

@property (nonatomic ,strong) NSNumber *identifier ; //替代id
@property (nonatomic ,strong) NSString *img_url ; //图片URL
@property (nonatomic ,assign) BOOL is_liked ; //是否收藏该电影
@property (nonatomic ,strong) NSString *likes ;//收藏人数
@property (nonatomic ,strong) NSString *name ;//电影类型描述


@end

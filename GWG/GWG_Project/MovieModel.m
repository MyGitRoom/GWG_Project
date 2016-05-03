//
//  MovieModel.m
//  GWG_Project
//
//  Created by lanou on 16/4/30.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "MovieModel.h"

@implementation MovieModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {

    NSLog(@"MovieModel没匹配到的key = %@",key) ;
}

@end

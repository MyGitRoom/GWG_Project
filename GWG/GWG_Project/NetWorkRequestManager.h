//
//  NetWorkRequestManager.h
//  项目期02创建pch文件
//
//  Created by lanou on 16/4/11.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorkRequestManager : NSObject

//定义一个枚举表示请求类型
typedef NS_ENUM(NSInteger ,RequestType){
    GET,
    POST
    
} ;

//定义一个请求结束时的block作为回调
typedef void(^RequestFinish)(NSData *data) ;


//定义一个请求失败的block作为回调
typedef void(^RequestError)(NSError *error) ;



+(void)requestWithType:(RequestType)type urlString:(NSString *)urlString ParDic:(NSDictionary *)dic finish:(RequestFinish)finish err:(RequestError)err;


@end

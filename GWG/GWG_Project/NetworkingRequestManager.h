//
//  NetworkingRequestManager.h
//  Prefix
//
//  Created by lanou on 16/4/11.
//  Copyright © 2016年 Gary_Cherry. All rights reserved.
//

#import <Foundation/Foundation.h>

//定义一个枚举表示请求类型
typedef NS_ENUM(NSInteger, RequestType) {
    GET,
    POST
};

//定义一个请求结束的block回调
typedef void(^RequestFinish) (NSData * data);
//定义一个请求失败的block回调
typedef void(^RequestError) (NSError * error);

@interface NetworkingRequestManager : NSObject

+ (void) requestWithType:(RequestType)type
               urlString:(NSString *)urlString
                  parDic:(NSDictionary *)parDic
               headerDic:(NSDictionary *)headerDic
                  finish:(RequestFinish)finish
                   error:(RequestError)err;

@end

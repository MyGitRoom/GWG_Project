//
//  NetWorlRequestManager.h
//  Project2
//
//  Created by lanou on 16/4/11.
//  Copyright © 2016年 Wcg. All rights reserved.
//

#import <Foundation/Foundation.h>
//定义一个枚举来表示 请求类型

typedef NS_ENUM(NSInteger, RequestType){
    GET,
    POST
};

//定义一个请求结束时的block作为回调
typedef void(^RequestFinish)(NSData * data);
//定义一个请求失败时的block作为回调
typedef void(^RequstError)(NSError * error
                           );

@interface NetWorlRequestManager : NSObject

+(void)requestWithType:(RequestType)type urlString:(NSString *)urlString ParDic:(NSDictionary * )dic dicOfHeader:(NSDictionary *)dicOfHeader finish:(RequestFinish)finish error:(RequstError)err;





@end

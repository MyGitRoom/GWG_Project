//
//  NetworkingRequestManager.m
//  Prefix
//
//  Created by lanou on 16/4/11.
//  Copyright © 2016年 Gary_Cherry. All rights reserved.
//

#import "NetworkingRequestManager.h"

@implementation NetworkingRequestManager

#pragma mark- 封装+号方法是为了使用起来方便
+ (void) requestWithType:(RequestType)type urlString:(NSString *)urlString parDic:(NSDictionary *)parDic headerDic:(NSDictionary *)headerDic finish:(RequestFinish)finish error:(RequestError)err
{
    NetworkingRequestManager * manager = [[NetworkingRequestManager alloc]init];
    
    //通过参数的传递 在-方法中进行数据处理
    [manager requestWithType:type urlString:urlString parDic:parDic headerDic:headerDic finish:finish error:err];
}

- (void) requestWithType:(RequestType)type urlString:(NSString *)urlString parDic:(NSDictionary *)parDic headerDic:(NSDictionary *)headerDic finish:(RequestFinish)finish error:(RequestError)err
{
    //将字符串转化为URL
    NSURL * url = [NSURL URLWithString:urlString];
    //创建一个可变的request
    NSMutableURLRequest * mRequest = [NSMutableURLRequest requestWithURL:url];
    //判断请求类型
    if (type == POST)
    {
        //设置请求类型为post
        [mRequest setHTTPMethod:@"POST"];
        //设置body体
        if (parDic.count > 0)
        {
            //将字典转化为NSData
            NSData * data = [self dicToData:parDic];
            //将data放在body体中
            [mRequest setHTTPBody:data];
        }
    }
    
    if (headerDic.count > 0)
    {
        NSArray * array = [headerDic allKeys];
        for (int i = 0; i < array.count; i++)
        {
            [mRequest setValue:[headerDic objectForKey:array[i]] forHTTPHeaderField:array[i]];
        }
        
    }
    
    //进行数据请求
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession * session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionTask * task = [session dataTaskWithRequest:mRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data)
        {
            //能进到if语句说明data是有值的
            //在这里使用block将data传递到其他地方使用
            finish(data);
        }
        else
        {
            err(error);
        }
        
    }];
    //启动请求
    [task resume];
}

#pragma mark- 把参数字典转化为NSData的私有方法
- (NSData *) dicToData:(NSDictionary *)dic
{
    //创建一个可变数组用来存放所有的键值对
    NSMutableArray * array = [NSMutableArray array];
    
    //遍历键值对
    for (NSString * key in dic)
    {
        NSString * keyAndValue = [NSString stringWithFormat:@"%@=%@", key, dic[key]];
        [array addObject:keyAndValue];
    }
    
    //将数组转化为字符串
    NSString * parStr = [array componentsJoinedByString:@"&"];
//    NSLog(@"parStr = %@", parStr);
    
    //将字符串转化为NSData
    NSData * data = [parStr dataUsingEncoding:NSUTF8StringEncoding];
    
    return data;
}

@end






















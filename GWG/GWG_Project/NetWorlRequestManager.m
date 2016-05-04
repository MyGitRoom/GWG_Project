//
//  NetWorlRequestManager.m
//  Project2
//
//  Created by lanou on 16/4/11.
//  Copyright © 2016年 Wcg. All rights reserved.
//

#import "NetWorlRequestManager.h"
#pragma mark-  封装成+号方法,是为了使用起来方便
@implementation NetWorlRequestManager
+(void)requestWithType:(RequestType)type urlString:(NSString *)urlString ParDic:(NSDictionary * )dic dicOfHeader:(NSDictionary *)dicOfHeader finish:(RequestFinish)finish error:(RequstError)err
{
    NetWorlRequestManager * manager = [[NetWorlRequestManager alloc]init];
    //通过参数的船体 在-号方法中进行数据处理
    [manager requestWithType:type urlString:urlString ParDic:dic dicOfHeader:dicOfHeader  finish:finish errror:err];
  
}
-(void)requestWithType:(RequestType)type urlString:(NSString *)urlString ParDic:(NSDictionary *)dic dicOfHeader:(NSDictionary *)dicOfHeader finish:(RequestFinish)finish errror:(RequstError)err
{
    //1 将字符串转化为url
    NSURL * url = [NSURL URLWithString:urlString];
    //2 创建一个可变的request
    NSMutableURLRequest * mRequest  =[NSMutableURLRequest requestWithURL:url];
    //3 判断请求类型
    if (type == POST) {
        //3.1 设置请求类型为POST
        [mRequest setHTTPMethod:@"POST"];
        //3.2 设置body体
        if (dic.count>0) {
            
            //3.3 将字典转化为NSData的方法
            NSData * data = [self DicToData:dic];
            //3.4 将data放在body体中
            [mRequest setHTTPBody:data];
            
            
        }
    }
    
    //设置HTTPHeader
    if (dicOfHeader.count>0) {
        NSArray * array  = [dicOfHeader allKeys];
        for (int i = 0; i<[array count]; i++) {
            NSString * str = [dicOfHeader objectForKey:array[i]];
            //设置头方法
            [mRequest setValue:str forHTTPHeaderField:array[i]];
            
        }
    }
    
    //4 进行数据请求
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession * session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:mRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            //能进到if语句说明data是有值的
            //在这里使用block的技术将data 传递到其他的地方使用
            finish(data);
        }else
        {
            err(error);
        }
        
    }];
    //启动请求
    [task resume];
    
    
}




#pragma mark- 把参数字典转化为NSData的私有方法
-(NSData *)DicToData:(NSDictionary * )dic
{   //1 创建一个可变数组用来存放所有的键值对
    NSMutableArray * arrayWithKeyAndValue = [NSMutableArray array];
    //2 遍历出来所有的键值对
    for (NSString * key in dic) {
        NSString * KeyAndValue = [NSString stringWithFormat:@"%@=%@",key,dic[key]];
        [arrayWithKeyAndValue addObject:KeyAndValue];
        
    }
    //array = ["a=b","c=d","e=f"]
    
    //3 将数组里的字符串转化成一个字符串
    NSString * newStr = [arrayWithKeyAndValue componentsJoinedByString:@"&"];
    // a=b&c=d&e=f
//    NSLog(@"newStr =%@",newStr);
    //4 将字符串转化为NSData
    NSData * data =[newStr dataUsingEncoding:NSUTF8StringEncoding];
    
    
    return data;
    
  
}


@end

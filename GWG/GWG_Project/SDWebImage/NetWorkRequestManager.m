//
//  NetWorkRequestManager.m
//  项目期02创建pch文件
//
//  Created by lanou on 16/4/11.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "NetWorkRequestManager.h"


@implementation NetWorkRequestManager

#pragma   mark -- 封装成+号方法,是为了方便引用

+(void)requestWithType:(RequestType)type urlString:(NSString *)urlString ParDic:(NSDictionary *)dic finish:(RequestFinish)finish err:(RequestError)err{

    NetWorkRequestManager *manager = [[NetWorkRequestManager alloc]init];

    //通过参数的传递 在减号方法中进行数据处理
    [manager requestWithType:type urlString:urlString ParDic:dic finish:finish err:err];


   }
-(void)requestWithType:(RequestType)type urlString:(NSString *)urlString ParDic:(NSDictionary *)dic finish:(RequestFinish)finish err:(RequestError)err{
   
    //1.将字符串转化为URL
    NSURL *url = [NSURL URLWithString:urlString];
   
    //2.创建一个可变的request
    NSMutableURLRequest *mRequest = [NSMutableURLRequest requestWithURL:url];
    
    //3判断请求类型
    if(type == POST){
       //3.1设置请求类型为POST
        [mRequest setHTTPMethod:@"POST"];
       //3.2设置Body体
        if(dic.count>0){
         
            //3.3将一个字典转化为NSData
            
            NSData *data = [self DicToDataWithDic:dic];
            //3.4将Data 放在Body体中
            [mRequest setHTTPBody:data];
        }
        
    }
//4.进行数据请求
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask  *task = [session dataTaskWithRequest:mRequest
                                             completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                 
                                                 if(data){
                                                  //能进到里面说明Data是有值的
                                                     
                                                //在这里使用Block的技术将Data传递到其他的地方使用
                                                     finish(data);
                                                 
                                                 }else{
                                                     err(error);
                                                     
                                                 }
                                                 
                                             }];
    //启动请求
    [task resume];
    
  }




/*
 字典的形式
 {a = b ,c=d, e=f}
 
 */
#pragma mark -- 把参数字典转化为NSData的私有方法
-(NSData *)DicToDataWithDic:(NSDictionary *)dic{
    //1创建一个可变数组用来存放所有的键值对
    NSMutableArray *array = [NSMutableArray array];
    //2便利出来所有的键值对
    for (NSString *key in dic) {
        NSString *KeyAndValue = [NSString stringWithFormat:@"%@=%@",key,dic[key]];
        [array addObject:KeyAndValue];
    }
    
    //3将数组转化为字符串
    NSString *parstr = [array componentsJoinedByString:@"&"];
    
//    4将字符串转化为NSData
    NSData *data = [parstr  dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return data;
}

@end

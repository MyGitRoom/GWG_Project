//
//  RadioDetaillViewController.m
//  GWG_Project
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "RadioDetaillViewController.h"

@interface RadioDetaillViewController ()

@end

@implementation RadioDetaillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    
    self.view.backgroundColor = [UIColor whiteColor];
}


#pragma mark- 请求数据
- (void) requestData
{
    NSDictionary * headerDic = [NSDictionary dictionaryWithObject:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
    [NetWorlRequestManager requestWithType:POST urlString:[DETAILURL stringByAppendingPathComponent:[NSString stringWithFormat:@"&collect_id=%@",[self.passId stringValue]]] ParDic:nil dicOfHeader:headerDic finish:^(NSData *data) {
        //        NSLog(@"%@",data);
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        
        
    } error:^(NSError *error) {
        NSLog(@"Error:%@",error);
    }];
}



@end

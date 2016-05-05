//
//  TechnologyDetailsViewController.m
//  GWG_Project
//
//  Created by Wcg on 16/5/5.
//  Copyright © 2016年 关振发. All rights reserved.
//http://www.dgtle.com/api/dgtle_api/v1/api.php?actions=view&aid=14338&apikeys=DGTLECOM_APITEST1&charset=UTF8&dataform=json&inapi=yes&modules=portal&platform=ios&swh=480x800&version=2.8

#import "TechnologyDetailsViewController.h"
#import "NetWorlRequestManager.h"
@interface TechnologyDetailsViewController ()
//Web//
@property(nonatomic,strong)UIWebView *techWebView;
//html 字符串//
@property(nonatomic,strong)NSString *strHtml;

@end

@implementation TechnologyDetailsViewController

- (void)viewDidLoad {
//    self.navigationController.hidesBarsOnSwipe = YES;
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData:_aid];
    
   
}
#pragma  -mark 建立webView
-(void)creatWebView
{
    _techWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _techWebView.scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    _techWebView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_techWebView];
    NSString * strHTML = [self reSizeImageWithHTMLNoHead:_strHtml];
    [_techWebView loadHTMLString:strHTML baseURL:nil];
}
//给网页中的图片加 header ，方便控制固定的宽度
- (NSString *)reSizeImageWithHTMLNoHead:(NSString *)html {
  
    return [NSString stringWithFormat:@"<head><style>img{width:%fpx !important;}</style></head>%@",KScreenWidth-20, html];
}

#pragma -mark 处理接口数据
-(void)loadData:(NSInteger)aid
{
    [NetWorlRequestManager requestWithType:GET urlString:[NSString stringWithFormat:@"http://www.dgtle.com/api/dgtle_api/v1/api.php?actions=view&aid=%ld&apikeys=DGTLECOM_APITEST1&charset=UTF8&dataform=json&inapi=yes&modules=portal&platform=ios&swh=480x800&version=2.8",aid] ParDic:nil dicOfHeader:nil finish:^(NSData *data) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary * dic1 = [dic objectForKey:@"returnData"];
        NSDictionary *  dic2 = [dic1 objectForKey:@"article_content"];
        _strHtml = [dic2 objectForKey:@"content"];
        dispatch_async(dispatch_get_main_queue(), ^{
           [self creatWebView];
            
        });
    } error:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    

}

@end

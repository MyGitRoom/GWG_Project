//
//  ReadingDetailViewController.m
//  GWG_Project
//
//  Created by lanou on 16/5/3.
//  Copyright © 2016年 关振发. All rights reserved.
//http://static.owspace.com/wap/292017.html?device_id=F8AA41A8-AE6B-4AC3-B3F9-5673BF17E6E1&version=iOS_1.1.0&client=iOS

#import "ReadingDetailViewController.h"

@interface ReadingDetailViewController ()<UIScrollViewDelegate,UIWebViewDelegate>
@property(nonatomic,strong)UIWebView * webView;

@end

@implementation ReadingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.374 green:0.353 blue:0.234 alpha:1.000];

    self.navigationController.navigationBarHidden = YES;
    [self creatWebView];
    
}
-(void)creatWebView
{
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, -64, KScreenWidth, KScreenHeight+64)];
    NSURL * url = [NSURL URLWithString:_webStr];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    _webView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_webView];
    
}





@end

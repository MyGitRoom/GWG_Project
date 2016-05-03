//
//  MovieDetailViewController.h
//  GWG_Project
//
//  Created by 关振发 on 16/4/30.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieDetailViewController : UIViewController

@property (nonatomic,strong) UIWebView *wed ;//创建一个webview解析传过来的数据

@property (nonatomic ,strong) NSDictionary *dic ;//创建一个字典接收传过来的请求体

@end

 //
//  MovieDetailViewController.m
//  GWG_Project
//
//  Created by 关振发 on 16/4/30.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "NetWorkRequestManager.h"
#import "MBProgressHUD.h"
@interface MovieDetailViewController ()<UIWebViewDelegate>

@property (nonatomic ,strong) MBProgressHUD *mbHUD ;

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 60)];
    view.backgroundColor = [UIColor colorWithRed:0.201 green:0.273 blue:0.512 alpha:1.000];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(10, 15, 60, 30);
    [view addSubview:btn];
    [self.view addSubview:view ];
    
    self.wed = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64)];
    [self getData];
    [self.view addSubview:self.wed];


    

}


-(void)getData{

    self.mbHUD = [[MBProgressHUD alloc]initWithView:self.wed];
    [self.mbHUD show:YES];
    [self.wed addSubview:self.mbHUD];
   [NetWorkRequestManager requestWithType:POST urlString:@"http://mark.intlime.com/singles/detail" ParDic:self.dic finish:^(NSData *data) {

       NSDictionary *datadic = [NSDictionary dictionary];
       datadic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//       NSLog(@"%@",data);
       NSDictionary *dict = [datadic objectForKey:@"data"];
       NSString *HtmlStr = [dict objectForKey:@"content"];
//       NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"查看详情"];
//       NSString *str3 = [HtmlStr stringByTrimmingCharactersInSet:set];
       NSString *str = [HtmlStr stringByReplacingOccurrencesOfString:@"由Mark重新编辑整理发布" withString:@""];
       NSString *str2 = [str stringByReplacingOccurrencesOfString:@"想看" withString:@""];
       NSString *str3 = [str2 stringByReplacingOccurrencesOfString:@"查看详情" withString:@""];
       NSString *str4 = [str3 stringByReplacingOccurrencesOfString:@"class=\"btn-movie notadded\""withString:@""];
       NSString *str5 = [str4 stringByReplacingOccurrencesOfString:@"class=\"icon icon-ok\"" withString:@""];
//        NSString *str6 = [str5 string];
              dispatch_async(dispatch_get_main_queue(), ^{
                  
           [self.wed loadHTMLString:str5 baseURL:nil];
                
           
           [self.view reloadInputViews];
        
            [self.mbHUD hide:YES];
       });
   } err:^(NSError *error) {
       
   }];
    

 }

//点击返回按钮实现的方法
-(void)back:(UIButton *)btn{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

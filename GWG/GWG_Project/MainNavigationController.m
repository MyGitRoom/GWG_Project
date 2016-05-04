//
//  MainNavigationController.m
//  GWG_Project
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "MainNavigationController.h"

@interface MainNavigationController ()

@property (nonatomic ,strong) UINavigationBar *bar ;

@end

@implementation MainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"标题";
    self.title = @"123" ;
//    self.bar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
//    
//    self.bar.backgroundColor = [UIColor colorWithRed:1.000 green:0.094 blue:0.070 alpha:1.000];
    
//    self.navigationItem .title = @"标题";
//    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
//    la .text = @"标题" ;
//    [self.bar addSubview:la];
//    self.navigationController.navigationBar.translucent = NO ;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack ;
//    self.navigationController.navigationBar.barStyle = uibar
    
    [self.view addSubview:self.bar];
    
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

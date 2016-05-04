
//
//  MainViewController.m
//  GWG_Project
//
//  Created by lanou on 16/4/29.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "MainViewController.h"
#import "DBSphereView.h"
#import "ReadingViewController.h"
#import "TechnologyViewController.h"
#import "RadioViewController.h"
#import "MovieViewController.h"
@interface MainViewController ()

@property (nonatomic ,strong)DBSphereView *sphereView ;
@property (nonatomic ,strong)UIImageView *imagev ;
@property (nonatomic ,assign) NSInteger i ;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imagev = [[UIImageView alloc]initWithFrame:self.view.frame];
    self.i = 1 ;
    self.imagev.image = [UIImage imageNamed:@"1.jpg"];
    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(changePic) userInfo:nil repeats:YES];
    [self.view addSubview:self.imagev];
    [self createCloudTag] ;
    NSLog(@"测试一下git");
    NSLog(@"测试一下gitaaaa");
    NSLog(@"测试一下分支");
    
    
}
//创建云标签
-(void)createCloudTag{
    self.sphereView = [[DBSphereView alloc]initWithFrame:CGRectMake(30, KScreenHeight-64-49, 100, 100)];
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:0];
    NSArray *titleArr = [NSArray arrayWithObjects:@"Movie",@"Reading",@"Radio",@"Science", nil];
    for (NSInteger i = 0; i<4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //根据tag标记进行跳转到那个页面
        btn.tag = i ;
        btn.frame = CGRectMake(0, 0, 100, 20);
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
         btn.titleLabel.font = [UIFont boldSystemFontOfSize:24];
        btn.titleLabel.font = [UIFont fontWithName:@"Zapfino" size:17];
       
        [btn addTarget:self action:@selector(jump:) forControlEvents:UIControlEventTouchUpInside];
        [array addObject:btn];
        [self.sphereView addSubview:btn];
    }
    
    [self.sphereView setCloudTags:array];
    [self.view addSubview:self.sphereView];


}
//点击按钮执行的方法
-(void)jump:(UIButton *)btn {
    //点击按钮定时器停止
    [self.sphereView timerStop];
    
    [UIView animateWithDuration:0.3 animations:^{
        btn.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            btn.transform = CGAffineTransformMakeScale(1., 1.);
        } completion:^(BOOL finished) {
            [self.sphereView timerStart];
        }];
        
    }];
    
    if(btn.tag == 0){
        MovieViewController *movieVc = [[MovieViewController alloc]init];
        
        //模态跳转
        [self presentViewController:movieVc animated:YES completion:nil];
    
    }else if (btn.tag ==1){
    
        ReadingViewController *readingVc = [[ReadingViewController alloc]init];
        //模态跳转
        [self presentViewController:readingVc animated:YES completion:nil];
    }else if (btn.tag == 2){
    
        RadioViewController *radioVc = [[RadioViewController alloc]init];
        //模态跳转
        [self presentViewController:radioVc animated:YES completion:nil];
    }else{
    
        TechnologyViewController *technoloVc =[[TechnologyViewController alloc]init];
        //模态跳转
        [self presentViewController:technoloVc animated:YES completion:nil];
    }
    
    

}



//切换图片的方法
-(void)changePic{
    
    
    self.imagev.image =[UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",_i]];
    
    if (_i==4) {
        _i=1;
    }
    _i++ ;
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

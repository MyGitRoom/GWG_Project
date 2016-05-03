//
//  TypeOfMovieViewController.m
//  GWG_Project
//
//  Created by 关振发 on 16/4/30.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "TypeOfMovieViewController.h"
#import "TypeOfMovieTableViewCell.h"
#import "NetWorkRequestManager.h"
#import "UIImageView+WebCache.h"
#import "TypeOfMovieModel.h"
#import "MovieDetailViewController.h"
#import "MBProgressHUD.h"
@interface TypeOfMovieViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong) NSMutableArray <TypeOfMovieModel*>*array ;//建一个数组接收解析数据
@property (nonatomic,strong) UITableView *tab ;
@property (nonatomic ,strong)MBProgressHUD *mbHUD;

@end

@implementation TypeOfMovieViewController

//懒加载
-(NSMutableArray*)array {
        if (!_array) {
            self.array = [NSMutableArray array];
        }
        
        return _array ;
    }
    

- (void)viewDidLoad {
        [super viewDidLoad];
        
//    self.view.backgroundColor = [UIColor blueColor];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(back:)];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
    
    view.backgroundColor = [UIColor blueColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(5,20, 60, 30) ;
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:btn];
    [self.view addSubview:view];
    self.tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 69, KScreenWidth,KScreenHeight-68) style:UITableViewStylePlain];
    
        self.tab.delegate = self ;
        self.tab.dataSource = self ;
    
        self.tab.separatorStyle = UITableViewCellSeparatorStyleNone ;
        //注册cell
        [self.tab registerClass:[TypeOfMovieTableViewCell class] forCellReuseIdentifier:@"cell"];
        
    self.view.backgroundColor = [UIColor whiteColor];
      [self.view addSubview:self.tab];
    
        [self getData];
        
    }
    //获取数据
    -(void)getData{
//        NSLog(@"%@",self.dic);
        self.mbHUD = [[MBProgressHUD alloc]initWithView:self.tab];
        [self.mbHUD show:YES];
        [self.tab addSubview:self.mbHUD];
        [NetWorkRequestManager requestWithType:POST urlString:@"http://114.215.104.21/v130/singles/catlist" ParDic:self.dic finish:^(NSData *data) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *arr = [dict objectForKey:@"data"];
            for (NSDictionary *dataDic in arr) {
                TypeOfMovieModel *modle = [[TypeOfMovieModel alloc]init];
                [modle setValuesForKeysWithDictionary:dataDic];
                modle.identifier = [dataDic objectForKey:@"id"];//id作为特殊字段要单独赋值
                [self.array addObject:modle];
//                NSLog(@"%ld",self.array.count);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //主线程刷新
                [self.tab reloadData];
                [self.mbHUD hide: YES];
            });
            
        } err:^(NSError *error) {
            
        }];
        
        
    }
    
    
#pragma mark tableview 的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return self.array.count;
    }
    
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
    
        TypeOfMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[TypeOfMovieTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        cell.titleLabel.text = self.array[indexPath.row].name ;
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:self.array[indexPath.row].img_url]];
        
        
        return cell;
        
    }
    
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        return  (KScreenWidth-10)*0.618 ;
    }

//点击跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    MovieDetailViewController *movieDeatilVc = [[MovieDetailViewController alloc]init];
    
    NSDictionary *dic = [NSDictionary dictionary];
    
    dic = @{@"Content-Type":@"application/x-www-form-urlencoded",@"id":self.array[indexPath.row].identifier} ;
    movieDeatilVc.dic = dic;
    
    [self presentViewController:movieDeatilVc animated:YES completion:nil];



}


//实现点击返回按钮的功能
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

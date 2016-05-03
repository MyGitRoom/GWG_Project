//
//  MovieViewController.m
//  GWG_Project
//
//  Created by lanou on 16/4/29.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "MovieViewController.h"
#import "MovieCollectionViewCell.h"
#import  "UIImageView+WebCache.h"
#import  "NetWorkRequestManager.h"
#import "MovieModel.h"
#include "TypeOfMovieViewController.h"
@interface MovieViewController ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic ,strong)UICollectionView *collectView ;
@property (nonatomic ,strong)NSMutableArray<MovieModel*>  *array ;
@end

@implementation MovieViewController
//懒加载
-(NSMutableArray *)array {
    if (!_array) {
        self.array = [NSMutableArray array];
    }
    return  _array ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor colorWithRed:0.464 green:0.471 blue:0.515 alpha:1.000];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(5,15, 40, 30);
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget: self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    

    
    
    
    [self getData];
    
    //调用创建collectionView 的方法

    [self createCollectView];
    
   
    
    
}


//获取数据
-(void)getData {

  [NetWorkRequestManager requestWithType:GET urlString:@"http://114.215.104.21/v130/singles/groupcat" ParDic:nil finish:^(NSData *data) {
      
     NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
      NSArray *arr = [dic objectForKey:@"data"];
      
      NSDictionary *dict = arr [0];
      NSDictionary *dataArr = [dict objectForKey:@"cat"];
//      NSLog(@"%@",dataArr);
      for (NSDictionary *dict in dataArr) {
          MovieModel *Movie = [[MovieModel alloc]init];
          [Movie setValuesForKeysWithDictionary:dict];
          Movie.identifier = [dict objectForKey:@"id"]; //id是关键字要单独赋值
          [self.array addObject:Movie];
      }
       NSLog(@"%ld",self.array.count);
      dispatch_async(dispatch_get_main_queue(), ^{
          [self.collectView reloadData];
      });
      
      
  } err:^(NSError *error) {
      
  }];
    

}



//点击返回按钮的方法
-(void)back:(UIButton *)btn {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//创建collectView
-(void)createCollectView{
   
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    //最小间距
    flowLayout.minimumInteritemSpacing = 10 ;
    flowLayout.minimumLineSpacing = 10 ;
    //边沿距离
    flowLayout.sectionInset  = UIEdgeInsetsMake(2, 10, 10, 10);
    
    
    self.collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,50, KScreenWidth, KScreenHeight-50) collectionViewLayout:flowLayout];
    self.collectView.backgroundColor = [UIColor colorWithWhite:0.908 alpha:1.000];
    
    self.collectView.delegate = self ;
    self.collectView.dataSource = self ;
    
    //注册collectionViewCell

    [self.collectView registerClass:[MovieCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.collectView];
 


}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{


    return  self.array.count-5 ;

}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//   NSLog(@"%f,%f",(KScreenWidth-40)/3,((KScreenWidth-30)/3+20));
    return CGSizeMake((KScreenWidth-45)/3,(KScreenWidth-45)/3/0.75);
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{


    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//    cell.titleLabel.text = self.array[indexPath.item].name;
    

    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.array[indexPath.item].img_url]];
    return cell ;
}

//点击item进行跳转
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = [NSDictionary dictionary];
    dict = @{@"Content-Type":@"application/x-www-form-urlencoded",@"start":@"0",@"count":@"15",@"id":self.array[indexPath.item].identifier,} ;
    TypeOfMovieViewController *typeMovie = [[TypeOfMovieViewController alloc]init];
  
    typeMovie.dic = dict ;
//    NSLog(@"%@",typeMovie.dic);
    [self presentViewController:typeMovie animated:YES completion:nil];
   
    
    
    /*
//    [self.navigationController pushViewController:typeMovie animated:YES];
//    NSLog(@"%@",self.array[indexPath.item].identifier);
//    [NetWorkRequestManager requestWithType:POST urlString:@"http://114.215.104.21/v130/singles/catlist" ParDic:@{@"Content-Type":@"application/x-www-form-urlencoded",@"start":@"0",@"count":@"15",@"id":self.array[indexPath.item].identifier} finish:^(NSData *data) {
//        
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@",[dic objectForKey:@"data"]);
//    } err:^(NSError *error) {
//        
//    }];
//  
    
*/

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

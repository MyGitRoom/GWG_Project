//
//  TechnologyViewController.m
//  GWG_Project
//
//  Created by lanou on 16/4/29.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "TechnologyViewController.h"
#import "Technology.h"
#import "TechnologyTableViewCell.h"
#import "NetWorlRequestManager.h"
#import "UIImageView+WebCache.h"
#import "RPSlidingMenuCell.h"
#import "RPSlidingMenuLayout.h"
#import "TechnologyDetailsViewController.h"

@interface TechnologyViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
{

    NSInteger flag;
    NSInteger i ;
    
}
//tab//
@property(nonatomic,strong)UITableView * technologyTab;
/*数据数组*/
@property (nonatomic,strong)NSMutableArray * dataArray;
//Colleciton//
@property(nonatomic,strong)UICollectionView *collectionView;
@end

@implementation TechnologyViewController


-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden =NO;
//    self.navigationController.hidesBarsOnSwipe = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
      _dataArray = [NSMutableArray array];
    i = 1;
    [self creatCollectionView];
    [self loadTechnologyData];
}
#pragma -mark 处理数据
-(void)loadTechnologyData
{
  NSString * str = [NSString stringWithFormat:@"http://www.dgtle.com/api/dgtle_api/v1/api.php?actions=article&apikeys=DGTLECOM_APITEST1&charset=UTF8&dataform=json&inapi=yes&limit=%ld_20&modules=portal&order=dateline_desc&platform=ios&swh=480x800&version=2.8",(long)flag];
    [NetWorlRequestManager requestWithType:GET urlString:str ParDic:nil dicOfHeader:nil finish:^(NSData *data) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary * dic1 = [dic objectForKey:@"returnData"];
            NSDictionary * dic2 = [dic1 objectForKey:@"articlelist"];
            NSArray * arr = [dic2 allValues];
            for (NSDictionary * dicA in arr) {
                Technology * tech = [[Technology alloc]init];
                [tech setValuesForKeysWithDictionary:dicA];
                

                [_dataArray addObject:tech];
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_collectionView reloadData];
            });
        });
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
}
-(void)creatCollectionView
{
    RPSlidingMenuLayout * layout = [[RPSlidingMenuLayout alloc]initWithDelegate:nil];
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor lightGrayColor];
    _collectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[RPSlidingMenuCell class] forCellWithReuseIdentifier:@"cell"];

}
#pragma -mark Collection Datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_dataArray count];
    

}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RPSlidingMenuCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
        Technology * tech = [_dataArray objectAtIndex:indexPath.row];
        cell.textLabel.text = tech.title;
        [cell.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:tech.pic_url] placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
    cell.detailTextLabel.text = tech.summary;

    return cell;
    
}
#pragma -mark 滑动监听方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_collectionView.contentOffset.y>3000*i) {
         [self loadMoreData];
    }
}
#pragma -mark 加载更多数据
-(void)loadMoreData
{
    flag = flag+20;
    i++;
    [self loadTechnologyData];
    NSLog(@"加载");
    
}
#pragma -mark 点击item跳转方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Technology * tech = [_dataArray objectAtIndex:indexPath.row];
    TechnologyDetailsViewController * t = [[TechnologyDetailsViewController alloc]init];
    t.aid = tech.aid;
    [self.navigationController pushViewController:t animated:YES];
}


@end

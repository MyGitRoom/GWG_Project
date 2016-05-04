//
//  ReadingViewController.m
//  GWG_Project
//
//  Created by lanou on 16/4/29.
//  Copyright © 2016年 关振发. All rights reserved.
//
#import "Reading.h"
#import "MJRefresh.h"
#import "MJRefreshAutoFooter.h"
#import "ReadingViewController.h"
#import "ReadingTableViewCell.h"
#import "NetWorlRequestManager.h"
#import "UIImageView+WebCache.h"
#import "ReadingDetailViewController.h"
@interface ReadingViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    //记录接口数组下标
    NSInteger flag;
}

/*列表*/
@property (nonatomic,strong)UITableView * readingTableView;
/*装数据的数组*/
@property (nonatomic,strong)NSMutableArray * readingArray;
/*装数据接口的数组*/
@property (nonatomic,strong)NSMutableArray * dataOpenArray;
@end

@implementation ReadingViewController
-(void)viewWillAppear:(BOOL)animated
{

    self.navigationController.navigationBarHidden=NO;


//    self.navigationController.navigationBarHidden = NO ;
//    self.tabBarController.hidesBottomBarWhenPushed = NO ;
    [[[self.navigationController.navigationBar subviews]objectAtIndex:0]setAlpha:0];

//    [[[self.navigationController.navigationBar subviews]objectAtIndex:0]setAlpha:1];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.820 green:0.750 blue:0.376 alpha:1.000];
    _readingArray = [NSMutableArray array];

    [self creatTableView];
    NSString * strFirst = @"http://static.owspace.com/index.php?m=Home&c=Api&a=getList&model=1&p=1&client=iphone&page_id=0&create_time=0&device_id=F8AA41A8-AE6B-4AC3-B3F9-5673BF17E6E1&iOS_version=1.1.0";
    [self loadReadingData:strFirst];
    [self creatFooterRefresh];
    
}
#pragma -mark 解析数据
-(void)loadReadingData:(NSString * )str
{
    //单读
    
    [NetWorlRequestManager requestWithType:GET urlString:str ParDic:nil dicOfHeader:nil finish:^(NSData *data) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSArray * array = [dic objectForKey:@"datas"];
        for (NSDictionary * dic1 in array) {
            Reading * read = [[Reading alloc]init];
            [read setValuesForKeysWithDictionary:dic1];
//            NSLog(@"%@",read.author);
            [_readingArray addObject:read];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_readingTableView reloadData];
        });
        
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
#pragma -mark 建立tab
-(void)creatTableView
{
    _readingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _readingTableView.delegate = self;
    _readingTableView.dataSource = self;
    _readingTableView.showsVerticalScrollIndicator = NO;
    _readingTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _readingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _readingTableView.pagingEnabled= YES;
    _readingTableView.backgroundColor = [UIColor lightGrayColor];
    _readingTableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    [self.view addSubview:_readingTableView];


}
#pragma -mark Tab代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_readingArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"reading";
    ReadingTableViewCell * readingCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (readingCell == nil) {
        readingCell = [[ReadingTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];  
    }
    
    Reading * read = [_readingArray objectAtIndex:indexPath.row];
    [readingCell.readImageView sd_setImageWithURL:[NSURL URLWithString:read.thumbnail] placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    readingCell.titleLabel.text = read.title;
    readingCell.detailsLabel.text = read.excerpt;
    readingCell.authorLabel.text = read.author;
    readingCell.selectionStyle =UITableViewCellSelectionStyleNone;
    
  

    return readingCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KScreenHeight;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Reading * read = [_readingArray objectAtIndex:indexPath.row];
    
    ReadingDetailViewController * readDetails = [[ReadingDetailViewController alloc]init];
    readDetails.webStr = read.share;
    readDetails.modalTransitionStyle = UIModalPresentationCurrentContext;
    [self presentViewController:readDetails animated:YES completion:nil];
    


}

#pragma  -mark 下拉刷新的方法
-(void)creatFooterRefresh
{
    _readingTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}
-(void)loadMoreData
{
    flag++;
    _dataOpenArray = [NSMutableArray arrayWithObjects:@"http://static.owspace.com/index.php?m=Home&c=Api&a=getList&model=1&p=1&client=iphone&page_id=0&create_time=0&device_id=F8AA41A8-AE6B-4AC3-B3F9-5673BF17E6E1&iOS_version=1.1.0",@"http://static.owspace.com/index.php?m=Home&c=Api&a=getList&model=1&p=2&client=iphone&page_id=291924&create_time=1460246400&device_id=F8AA41A8-AE6B-4AC3-B3F9-5673BF17E6E1&iOS_version=1.1.0",@"http://static.owspace.com/index.php?m=Home&c=Api&a=getList&model=1&p=3&client=iphone&page_id=291799&create_time=1458086400&device_id=F8AA41A8-AE6B-4AC3-B3F9-5673BF17E6E1&iOS_version=1.1.0",@"http://static.owspace.com/index.php?m=Home&c=Api&a=getList&model=1&p=4&client=iphone&page_id=291711&create_time=1455761640&device_id=F8AA41A8-AE6B-4AC3-B3F9-5673BF17E6E1&iOS_version=1.1.0",@"http://static.owspace.com/index.php?m=Home&c=Api&a=getList&model=1&p=5&client=iphone&page_id=291603&create_time=1453334400&device_id=F8AA41A8-AE6B-4AC3-B3F9-5673BF17E6E1&iOS_version=1.1.0",@"http://static.owspace.com/index.php?m=Home&c=Api&a=getList&model=1&p=6&client=iphone&page_id=291480&create_time=1449726780&device_id=F8AA41A8-AE6B-4AC3-B3F9-5673BF17E6E1&iOS_version=1.1.0",@"http://static.owspace.com/index.php?m=Home&c=Api&a=getList&model=1&p=7&client=iphone&page_id=291524&create_time=1438398300&device_id=F8AA41A8-AE6B-4AC3-B3F9-5673BF17E6E1&iOS_version=1.1.0", nil];
    [self loadReadingData:_dataOpenArray[flag]];
    [_readingTableView reloadData];
    [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(timeStopP) userInfo:nil repeats:NO];

}
-(void)timeStopP
{
 [_readingTableView.mj_footer endRefreshing];
}

@end

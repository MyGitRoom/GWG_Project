//
//  RadioViewController.m
//  GWG_Project
//
//  Created by lanou on 16/4/29.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "RadioViewController.h"

@interface RadioViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * tab;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation RadioViewController

#pragma mark- 懒加载
- (NSMutableArray *) dataArray
{
    if (!_dataArray)
    {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


#pragma mark- 加载视图
- (void)viewDidLoad {
    self.navigationController.navigationBarHidden = NO;
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self requestData];
}

#pragma mark- 创建tableview
- (void) createTableView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    self.tab = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    [self.view addSubview:_tab];
    _tab.delegate = self;
    _tab.dataSource = self;
    _tab.separatorStyle = UITableViewCellSelectionStyleNone;
    _tab.showsVerticalScrollIndicator = NO;
}

#pragma -mark tableview代理方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MyTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    //设置cell无点击效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    DataModel * datmo = [_dataArray objectAtIndex:indexPath.row];
    cell.imageV.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:datmo.cover_url]]];
    cell.titleLab.text = datmo.title;
    cell.introLab.text = datmo.intro;
//    cell.countLab.text = datmo.cover_path;
    if ([datmo.count_play integerValue]/10000>0)
    {
        NSString * string = [NSString stringWithFormat:@"%.2f万人收听",[datmo.count_play integerValue]/10000.0];
        cell.countLab.text = string;
//        NSLog(@"%@",string);
    }
    
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DataModel * dat = [_dataArray objectAtIndex:indexPath.row];
    RadioDetaillViewController * detail = [[RadioDetaillViewController alloc]init];
    detail.passId = dat.identifier;
    [self.navigationController pushViewController:detail animated:YES];
}

/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //去除tableview与边缘的15像素的距离
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
*/

#pragma mark- 请求数据
- (void) requestData
{

    [NetWorlRequestManager requestWithType:GET urlString:RADIOURL  ParDic:nil dicOfHeader:nil finish:^(NSData *data) {
//        NSLog(@"%@",data);
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray * dataArray = [dic objectForKey:@"data"];
        for (NSDictionary * dic in dataArray)
        {
            DataModel * dat = [[DataModel alloc]init];
            [dat setValuesForKeysWithDictionary:dic];
            dat.identifier = [dic objectForKey:@"id"];
            [self.dataArray addObject:dat];
        }
//        NSLog(@"%@",self.dataArray);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createTableView];
        });
        
    } error:^(NSError *error) {
        NSLog(@"Error:%@",error);
    }];
    
}


@end

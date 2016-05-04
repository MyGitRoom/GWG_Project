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
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self requestData];
}

#pragma mark- 创建tableview
- (void) createTableView
{
    self.tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 10*100) style:UITableViewStylePlain];
    [self.view addSubview:_tab];
    _tab.delegate = self;
    _tab.dataSource = self;
    _tab.separatorStyle = UITableViewCellSelectionStyleNone;
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

#pragma mark- 请求数据
- (void) requestData
{

    [NetworkingRequestManager requestWithType:GET urlString:RADIOURL  parDic:nil headerDic:nil finish:^(NSData *data) {
//        NSLog(@"%@",data);
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray * dataArray = [dic objectForKey:@"data"];
        for (NSDictionary * dic in dataArray)
        {
            DataModel * dat = [[DataModel alloc]init];
            [dat setValuesForKeysWithDictionary:dic];
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

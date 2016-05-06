//
//  RadioDetaillViewController.m
//  GWG_Project
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "RadioDetaillViewController.h"

@interface RadioDetaillViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * tab;

@property (nonatomic, strong) NSMutableArray * dataDetailArray;
@property (nonatomic, assign) BOOL flagBtn;

@end

@implementation RadioDetaillViewController

#pragma mark- 懒加载
- (NSMutableArray *) dataDetailArray
{
    if (!_dataDetailArray)
    {
        self.dataDetailArray = [NSMutableArray array];
    }
    return _dataDetailArray;
}

#pragma mark- 加载视图
- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    
    self.view.backgroundColor = [UIColor whiteColor];
}


#pragma mark- 请求数据
- (void) requestData
{
    NSDictionary * headerDic = [NSDictionary dictionaryWithObject:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
    NSDictionary * parDic = [NSDictionary dictionaryWithObjectsAndKeys:@"app_version",@"2.0.5",@"sort",@"1",@"visitor_uid",@"0",@"page",@"1", nil];
    [NetWorlRequestManager requestWithType:POST urlString:[DETAILURL stringByAppendingPathComponent:[NSString stringWithFormat:@"&collect_id=%@",[self.passId stringValue]]] ParDic:parDic dicOfHeader:headerDic finish:^(NSData *data) {
//        NSLog(@"%@",data);
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@",dic);
        NSArray * dataArray = [dic objectForKey:@"data"];
        self.flag = 0;
        for (NSDictionary * dic in dataArray)
        {
            DataDetailModel * dade = [[DataDetailModel alloc]init];
            [dade setValuesForKeysWithDictionary:dic];
            dade.model_flag = self.flag;
            [self.dataDetailArray addObject:dade];
            self.flag++;
//            NSLog(@"%ld",(long)dade.model_flag);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createTableView];
        });
        
    } error:^(NSError *error) {
        NSLog(@"Error:%@",error);
    }];
}

#pragma mark- 创建tableview
- (void) createTableView
{
    self.tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight) style:UITableViewStylePlain];
    [self.view addSubview:_tab];
    _tab.delegate = self;
    _tab.dataSource = self;
//    _tab.separatorStyle = UITableViewCellSelectionStyleNone;
    _tab.showsVerticalScrollIndicator = NO;
}

#pragma -mark tableview代理方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
//        cell = [[DetailTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell = [[[NSBundle mainBundle]loadNibNamed:@"DetailTableViewCell" owner:self options:nil] lastObject];
    }
    //设置cell无点击效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    DataDetailModel * dataD = [self.dataDetailArray objectAtIndex:indexPath.row];
    cell.titleLab.text = dataD.title;
    cell.typeLab.text = [dataD.user objectForKey:@"nick"];
    [cell.picView sd_setImageWithURL:[NSURL URLWithString:dataD.cover_url]];
    cell.countLab.text = [NSString stringWithFormat:@"%@人收听",dataD.count_play];
    [cell.playBtn addTarget:self action:@selector(playRadio:) forControlEvents:UIControlEventTouchUpInside];
    self.flagBtn = NO;
    return cell;
}

//button点击事件
- (void) playRadio:(UIButton *)btn
{
//    self.flagBtn = YES;
    [btn setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataDetailArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self initMusicPlayerControllerWithIndex:indexPath.row];
}

//根据索引下标创建对应的音乐播放的视图控制器
-(void)initMusicPlayerControllerWithIndex:(NSInteger)index
{
    MusicPlayerViewController * musicPlay;
    if (!musicPlay)
    {
        musicPlay = [[MusicPlayerViewController alloc]init];
    }
    musicPlay.currentIndex = index;
    musicPlay.detailMod = [self.dataDetailArray objectAtIndex:index];
    musicPlay.passDataArray = self.dataDetailArray;
    [self.navigationController pushViewController:musicPlay animated:YES];
}


//给cell添加动画
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //设置Cell的动画效果为3D效果
    //设置x和y的初始值为0.1；
    cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
    //x和y的最终值为1
    [UIView animateWithDuration:1 animations:^{
        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
    
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













@end

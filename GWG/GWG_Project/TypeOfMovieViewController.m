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
    
    
    self.navigationController.navigationBarHidden = NO ;
    
    self.tab = [[UITableView alloc]initWithFrame:CGRectMake(0,0, KScreenWidth,KScreenHeight) style:UITableViewStylePlain];
    
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
    
//    [self presentViewController:movieDeatilVc animated:YES completion:nil];
    [self.navigationController pushViewController:movieDeatilVc animated:YES];



}

//给cell添加动画
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //设置Cell的动画效果为3D效果
//    //设置x和y的初始值为0.1；
//    cell.layer.transform = CATransform3DMakeScale(0.5, 1, 1);
//    //x和y的最终值为1
//    [UIView animateWithDuration:0.5 animations:^{
//        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
//    }];
//}


//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//
//
//    CGFloat offsetY = scrollView.contentOffset.y + _tab.contentInset.top;//注意
//    CGFloat panTranslationY = [scrollView.panGestureRecognizer translationInView:self.tab].y;
//    
//    if (offsetY > 64) {
//        if (panTranslationY > 0) { //下滑趋势，显示
//            [self.navigationController setNavigationBarHidden:NO animated:YES];
//        }
//        else {  //上滑趋势，隐藏
//            [self.navigationController setNavigationBarHidden:YES animated:YES];
//        }
//    }
//    else {
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//    }
//}
//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    self.navigationController.navigationBarHidden = YES ;
//}
//
//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//
//    self.navigationController.navigationBarHidden = NO ;
//}


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

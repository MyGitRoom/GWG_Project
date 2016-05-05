
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
#import "UIImageView+WebCache.h"
#define DAILYURL @"http://dict-mobile.iciba.com/interface/index.php?c=sentence&m=getsentence&client=1&type=1&field=1,2,3,4,5,6,7,8,9,10,11,12,13&timestamp=1434767570&sign=6124a62ff73a033a&uuid=3dd23ff24ea543c1bdca57073d0540e1&uid="
@interface MainViewController ()

@property (nonatomic ,strong)DBSphereView *sphereView ;
@property (nonatomic ,strong)UIImageView *imagev ;
@property (nonatomic ,assign) NSInteger i ;

@property (nonatomic, strong) UIImageView * imageV;
@property (nonatomic, strong) UIView * vi;
@property (nonatomic, strong) UILabel * textLabel;
@property (nonatomic, strong) NSMutableArray * msgArray;
@property (nonatomic, strong) NSString * tagMP3; //音频的URL
@property (nonatomic, strong) UIButton * mainBtn;


@property (nonatomic ,strong) NSTimer *Scaletimer ;//创建一个定时器控制按钮动画

@end

@implementation MainViewController

#pragma mark- 懒加载
- (NSMutableArray *) msgArray
{
    if (!_msgArray)
    {
        self.msgArray = [NSMutableArray array];
    }
    return _msgArray;
}

- (AVPlayer *) player
{
    if (!_player)
    {
        self.player = [[AVPlayer alloc]init];
    }
    return _player;
}


#pragma mark- 隐藏导航栏
-(void)viewWillAppear:(BOOL)animated {
 self.navigationController.navigationBarHidden = YES ;
    
}


#pragma mark- 加载视图
- (void)viewDidLoad {
    [super viewDidLoad];

   
    self.imagev = [[UIImageView alloc]initWithFrame:self.view.frame];
    self.i = 1 ;
    self.imagev.image = [UIImage imageNamed:@"1.jpg"];
    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(changePic) userInfo:nil repeats:YES];
    
    //添加毛玻璃效果
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectvi = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectvi.frame = CGRectMake(0, 0,KScreenWidth  , KScreenHeight);
    effectvi.alpha = .95;
    [self.view addSubview:self.imagev];
    [self.view addSubview:effectvi];
    
//    effectvi.hidden = YES ;
//    self.vi.hidden = YES ;
    
    //创建标签云

    [self createCloudTag] ;
    
    //加载数据
    [self requestData];
    
}


#pragma mark- 创建云标签
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



#pragma mark- 点击标签云按钮执行的方法
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
        [self.navigationController pushViewController:movieVc animated:YES];
    
    }else if (btn.tag ==1){
    
        ReadingViewController *readingVc = [[ReadingViewController alloc]init];
        [self.navigationController pushViewController:readingVc animated:YES];

    }else if (btn.tag == 2){
    
        RadioViewController *radioVc = [[RadioViewController alloc]init];
        [self.navigationController pushViewController:radioVc animated:YES];
    }else{
    
        TechnologyViewController *technoloVc =[[TechnologyViewController alloc]init];
        [self.navigationController pushViewController:technoloVc animated:YES];
    }
    
    
}



#pragma mark- 切换图片的方法
-(void)changePic{
    
    if (_i==5) {

//    self.imagev.image =[UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",_i]];
    
//    if (_i==4) {

        _i=1;
    }
    self.imagev.image =[UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",_i]];
    _i++ ;
}





#pragma mark- 请求数据
- (void) requestData
{
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString * string = [formatter stringFromDate:date];
    //    NSLog(@"%@",string);
    
    
    [NetWorlRequestManager requestWithType:GET urlString:[DAILYURL stringByAppendingString:string] ParDic:nil dicOfHeader:nil finish:^(NSData *data) {
        //        NSLog(@"%@",data);
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary * dataDic = [dic objectForKey:@"message"];
        //        NSLog(@"%@",dic);
        Message * msg = [[Message alloc]init];
        msg.content = [dataDic objectForKey:@"content"];
        msg.love = [dataDic objectForKey:@"love"];
        msg.note = [dataDic objectForKey:@"note"];
        msg.picture = [dataDic objectForKey:@"picture"];
        msg.title = [dataDic objectForKey:@"title"];
        msg.translation = [dataDic objectForKey:@"translation"];
        msg.tts = [dataDic objectForKey:@"tts"];
        [self.msgArray addObject:msg];
        //        NSLog(@"%@",[_msgArray objectAtIndex:0]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadTodayView];
        });
        
    } error:^(NSError *error) {
        NSLog(@"Error:%@",error);
    }];
    
}



#pragma mark- 添加视图
- (void) loadTodayView
{

    self.vi = [[UIView alloc]initWithFrame:CGRectMake(KScreenWidth/2-KScreenWidth/1.3/2, KScreenHeight/2-KScreenHeight/1.3/2-40, KScreenWidth/1.3, KScreenHeight/1.38)];
    _vi.backgroundColor = [UIColor colorWithWhite:0.850 alpha:1.000];
//        _vi.alpha = .8;

    _vi.layer.cornerRadius = 7;
    _vi.layer.masksToBounds = YES;
    [self.view addSubview:_vi];
    [self createControls];
}

//创建视图上控件
- (void) createControls
{
    
    //取数据
    Message * msg = [self.msgArray lastObject];
    self.tagMP3 = msg.tts;
    //日期Label
    UILabel * dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.vi.frame.size.width, 40)];
    dateLabel.text = msg.title;
    [self.vi addSubview:dateLabel];
    
    //图片
    self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40+20, self.vi.frame.size.width, self.vi.frame.size.width*0.618)];

    [self.imageV sd_setImageWithURL:[NSURL URLWithString:msg.picture]];
//    self.imageV.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:msg.picture]]];
    [self.vi addSubview:self.imageV];
    
    //中英文对照
    self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.imageV.frame.origin.y + self.vi.frame.size.width*0.618 + 10, self.vi.frame.size.width - 20, 100)];
    _textLabel.numberOfLines = 20;
    _textLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:14];
//    _textLabel.font = [UIFont fontWithName:@"TimesNewRomanPS-ItalicM" size:12];
    NSString * text1 = [msg.content stringByAppendingString:@"\n\n"];
    NSString * text2 = [text1 stringByAppendingString:msg.note];
    _textLabel.text = text2;
    [self.vi addSubview:_textLabel];

    //播放音频按钮
    self.mainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _mainBtn.layer.cornerRadius = KScreenWidth*0.217/2;
    _mainBtn.layer.masksToBounds = YES;
    _mainBtn.layer.borderWidth = 0;
//    NSLog(@"%f --%f",_mainBtn.center.x ,_mainBtn.center.y);
   
    [_mainBtn setTitle:@"Listen me" forState:UIControlStateNormal];
    _mainBtn.titleLabel.textColor = [UIColor colorWithWhite:0.911 alpha:1.000];
    _mainBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _mainBtn.frame = CGRectMake(KScreenWidth/2- 45, self.vi.frame.size.height -100, KScreenWidth*0.217, KScreenWidth*0.217);
     _mainBtn.center = CGPointMake(self.vi.center.x-KScreenWidth*0.217/2, self.vi.frame.size.height -KScreenWidth*0.217/2-8) ;
    [_mainBtn addTarget:self action:@selector(touchChange:) forControlEvents:UIControlEventTouchUpInside];
    [self.vi addSubview:_mainBtn];
    _mainBtn.backgroundColor = [UIColor colorWithRed:60/255.5 green:74/255.0 blue:157/255.0 alpha:.8] ;
//    _mainBtn.backgroundColor = [UIColor colorWithRed:0.996 green:0.824 blue:0.224 alpha:1.000];
    

}



- (void) touchChange:(UIButton *)btn
{
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.tagMP3]];

    self.player = [AVPlayer playerWithPlayerItem:playerItem];

    [self.player play];
    
    
    //添加监听事件,监测音频是否播放结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEndTimeNotification:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
  /*
    
//    CMTime duration = playerItem.duration;
//    NSUInteger dTotalSeconds = CMTimeGetSeconds(duration);
//    
//    _dSeconds = floor(dTotalSeconds % 3600 % 60);
//     NSLog(@"%lu",(unsigned long)_dSeconds);

////    
//    NSLog(@"%lld",duration.value);
//    NSLog(@"%d",duration.timescale);
//    _dSeconds = self.player.currentTime.value /self.player.currentTime.timescale ;
    
    
    
    //    NSUInteger dHours = floor(dTotalSeconds / 3600);
    //    NSUInteger dMinutes = floor(dTotalSeconds % 3600 / 60);
    //    NSString *videoDurationText = [NSString stringWithFormat:@"%i:%02i:%02i",dHours, dMinutes,dSeconds];
         NSLog(@"%lu",(unsigned long)_dSeconds);
    
    
//    [UIView animateWithDuration:1 animations:^{
//        btn.layer.transform = CATransform3DMakeScale(1.2,1.2, 1);
//    }];
    */
   
    btn.layer.transform = CATransform3DMakeScale(1, 1, 1);

    self.Scaletimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(AnimationScale) userInfo:nil repeats:YES];
    
   
  
}

#pragma mark--播放完成调用该方法
-(void)handleEndTimeNotification:(NSNotification *)sender
{
     //播放结束,释放定时器
    [self.Scaletimer invalidate];
}


#pragma  mark -Listen me 按钮的动画效果
-(void)AnimationScale{


    
        [UIView animateWithDuration:1 animations:^{
            _mainBtn.layer.transform = CATransform3DMakeScale(1.1,1.1, 1);
            
            } completion:^(BOOL finished) {
        
            [UIView animateWithDuration:1 animations:^{
                _mainBtn.layer.transform = CATransform3DMakeScale(1,1, 1);
            }];
            
            
        }];
      


}






@end

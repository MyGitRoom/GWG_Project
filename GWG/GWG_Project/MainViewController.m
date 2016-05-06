
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
#import "LazyFadeInView.h"
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
@property (nonatomic ,strong) UIButton *hideBtn ;//隐藏主页中间View的按钮
@property (nonatomic ,strong) UIButton *showViewBtn ;//展开主语中间的Vie的按钮

@property (nonatomic ,strong) NSTimer *Scaletimer ;//创建一个定时器控制按钮动画
@property (nonatomic ,strong) UIVisualEffectView *effectvi ;//创建毛玻璃的View

@property (nonatomic ,strong) LazyFadeInView *wordView ;
@property (nonatomic ,strong) NSString *word ;
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
    
//    [UIView animateWithDuration:1 animations:^{
//        self.wordView.layer.transform = CATransform3DMakeScale(1, 1, 1);
//    }];
    
    
//    [self.view addSubview:self.wordView];
    NSLog(@"%f",self.wordView.frame.size.width);
//    self.wordView.hidden = NO ;
    self.wordView = [[LazyFadeInView alloc]initWithFrame:CGRectMake(20, 60, 100, 300)];
    self.wordView.text = self.word ;
    [self.view addSubview:self.wordView];
}


#pragma mark- 加载视图
- (void)viewDidLoad {
    [super viewDidLoad];

   
    self.imagev = [[UIImageView alloc]initWithFrame:self.view.frame];
    self.i = 1 ;
    self.imagev.image = [UIImage imageNamed:@"1.jpg"];
    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(changePic) userInfo:nil repeats:YES];
    
    
    //创建展开中间View 的按钮
    self.showViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.showViewBtn.frame = CGRectMake(KScreenWidth-30, KScreenHeight-30, 60, 60);
    self.showViewBtn.layer.cornerRadius = 30 ;
    self.showViewBtn.layer.masksToBounds = YES ;
    [self.showViewBtn addTarget:self action:@selector(showView:) forControlEvents:UIControlEventTouchUpInside];
    [self.showViewBtn setImage:[UIImage imageNamed:@"showView"] forState:UIControlStateNormal];
    self.showViewBtn.backgroundColor = [UIColor colorWithRed:0.778 green:0.894 blue:1.000 alpha:0.700];
    self.showViewBtn.hidden = YES ;
    
    //添加毛玻璃效果
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.effectvi = [[UIVisualEffectView alloc]initWithEffect:blur];
    self.effectvi.frame = CGRectMake(0, 0,KScreenWidth  , KScreenHeight);
    self.effectvi.alpha = .95;
    [self.view addSubview:self.imagev];
    [self.view addSubview:self.effectvi];
   
    [self.view addSubview:self.showViewBtn];
    

    
    //创建显示渐变文字的View
    self.wordView = [[LazyFadeInView alloc]initWithFrame:CGRectMake(20, 60, 100, 300)];

     [self.view addSubview:self.wordView];
    
    //创建标签云

    [self createCloudTag] ;
    
    //加载数据
    [self requestData];
    
    self.wordView.text = self.word ;
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
        
        //赋值给word
       
        self.word = msg.content ;
        
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
    [self.effectvi addSubview:_vi];
    [self createControls];
}

#pragma mark -- 创建视图上控件
- (void) createControls
{
    
    //取数据
    Message * msg = [self.msgArray lastObject];
    self.tagMP3 = msg.tts;
    //日期Label
    UILabel * dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.vi.frame.size.width, 40)];
    dateLabel.text = msg.title;
    
    //隐藏中间View的按钮
    self.hideBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    self.hideBtn.frame = CGRectMake(self.vi.frame.size.width-35, 15, 25, 25);
    [self.hideBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
//    self.hideBtn.backgroundColor = [UIColor blueColor];
    [self.hideBtn addTarget:self action:@selector(hideView:) forControlEvents:UIControlEventTouchUpInside ];
    self.hideBtn.layer.cornerRadius = 25/2;
    self.hideBtn.layer.masksToBounds = YES ;
    
    
    [self.vi addSubview:dateLabel];
    [self.vi addSubview:self.hideBtn];
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

#pragma  mark - 实现隐藏中间View 的按钮 

-(void)hideView:(UIButton *)hideBtn{
    
    [UIView animateWithDuration:3 animations:^{

        CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        CGMutablePathRef path = CGPathCreateMutable() ;
        //指定self.vi 的中心为起点
//        CGPathMoveToPoint(path, NULL,self.vi.frame.origin.x, self.vi.frame.origin.y);
        CGPathMoveToPoint(path, NULL,self.vi.center.x, self.vi.center.y);
//        CGPathMoveToPoint(path, NULL, KScreenWidth/2-KScreenWidth/1.3/2, KScreenHeight/2-KScreenHeight/1.3/2-40);
        CGPathAddLineToPoint(path, NULL, KScreenWidth,KScreenHeight);
        //设置时间
        [keyAnimation setDuration:2];
        
        //设置path
        [keyAnimation setPath:path];
        
          //设置动画执行完毕后，不删除动画
        keyAnimation.removedOnCompletion=NO;
            //设置保存动画的最新状态
        keyAnimation.fillMode=kCAFillModeForwards;
        
        self.vi.layer.transform = CATransform3DMakeScale(0.00000001,0.00000001, 1);
        [self.vi.layer addAnimation:keyAnimation forKey:@"position"];
        
    } completion:^(BOOL finished) {
        self.wordView.hidden = NO ;
        self.showViewBtn.hidden = NO ;
        
        self.wordView.text = self.word ;
        [UIView animateWithDuration:0.8 animations:^{
            self.showViewBtn.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1);

        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1 animations:^{
                 self.showViewBtn.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1);
            }];
           

        }];
        
    }];

}

#pragma  mark - 显示隐藏的中间View
-(void)showView:(UIButton *)showViewBtn{
    
    self.wordView.hidden = YES ;
    [UIView animateWithDuration:2 animations:^{
        CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        CGMutablePathRef path = CGPathCreateMutable() ;
        //指定self.vi 的中心为起点
        CGPathMoveToPoint(path, NULL, KScreenWidth,KScreenHeight);
        //设置终点
        CGPathAddLineToPoint(path, NULL,self.vi.frame.origin.x, self.vi.frame.origin.y);
        //设置时间
        [keyAnimation setDuration:2];
        
        //设置path
        [keyAnimation setPath:path];
        
        //设置动画执行完毕后，不删除动画
        keyAnimation.removedOnCompletion=NO;
        //设置保存动画的最新状态
        keyAnimation.fillMode=kCAFillModeForwards;
        
        [self.vi.layer addAnimation:keyAnimation forKey:@"position"];
        
        self.effectvi.layer.transform = CATransform3DMakeScale(1, 1, 1) ;
        self.vi.layer.transform = CATransform3DMakeScale(1, 1, 1);
        self.showViewBtn.layer.transform = CATransform3DMakeScale(0.0001, 0.0001, 0.0001);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2 animations:^{
            self.showViewBtn.layer.transform = CATransform3DMakeScale(0, 0, 0);
        }];
    }];


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

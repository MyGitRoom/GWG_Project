
//
//  MainViewController.m
//  GWG_Project
//
//  Created by lanou on 16/4/29.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "MainViewController.h"
#define DAILYURL @"http://dict-mobile.iciba.com/interface/index.php?c=sentence&m=getsentence&client=1&type=1&field=1,2,3,4,5,6,7,8,9,10,11,12,13&timestamp=1434767570&sign=6124a62ff73a033a&uuid=3dd23ff24ea543c1bdca57073d0540e1&uid="

@interface MainViewController ()

@property (nonatomic ,strong)DBSphereView *sphereView ;
@property (nonatomic ,strong)UIImageView *imagev ;
@property (nonatomic ,assign) NSInteger i ;
@property (nonatomic, strong) UIImageView * imageV;
@property (nonatomic, strong) UIView * vi;
@property (nonatomic, strong) UILabel * textLabel;
@property (nonatomic, strong) NSMutableArray * msgArray;
@property (nonatomic, strong) NSString * tagMP3;

@property (nonatomic, strong) UIButton * mainBtn;
@property (nonatomic, strong) UIButton * borderBtn;
@end

@implementation MainViewController

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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //首页导航
    self.imagev = [[UIImageView alloc]initWithFrame:self.view.frame];
    self.i = 1 ;
    self.imagev.image = [UIImage imageNamed:@"1.jpg"];
    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(changePic) userInfo:nil repeats:YES];
    [self.view addSubview:self.imagev];
    [self createCloudTag];
    
    //加载数据
//    [self requestData];
    
    
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
//点击按钮执行的方法
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
        
        //模态跳转
        [self presentViewController:movieVc animated:YES completion:nil];
    
    }else if (btn.tag ==1){
    
        ReadingViewController *readingVc = [[ReadingViewController alloc]init];
        //模态跳转
        [self presentViewController:readingVc animated:YES completion:nil];
    }else if (btn.tag == 2){
    
        RadioViewController *radioVc = [[RadioViewController alloc]init];
        //模态跳转
        [self presentViewController:radioVc animated:YES completion:nil];
    }else{
    
        TechnologyViewController *technoloVc =[[TechnologyViewController alloc]init];
        //模态跳转
        [self presentViewController:technoloVc animated:YES completion:nil];
    }
    
    

}

//切换图片的方法
-(void)changePic{
    
    
    self.imagev.image =[UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",_i]];
    
    if (_i==4) {
        _i=1;
    }
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
    
    
    [NetworkingRequestManager requestWithType:GET urlString:[DAILYURL stringByAppendingString:string] parDic:nil headerDic:nil finish:^(NSData *data) {
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
    self.vi = [[UIView alloc]initWithFrame:CGRectMake(KScreenWidth/2-KScreenWidth/1.3/2, KScreenHeight/2-KScreenHeight/1.3/2-50, KScreenWidth/1.3, KScreenHeight/1.3)];
    _vi.backgroundColor = [UIColor whiteColor];
//    _vi.alpha = .8;
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
    self.imageV.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:msg.picture]]];
    [self.vi addSubview:self.imageV];
    
    //中英文对照
    self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.imageV.frame.origin.y + self.vi.frame.size.width*0.618 + 10, self.vi.frame.size.width - 20, 100)];
    _textLabel.numberOfLines = 20;
    _textLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:14];
    NSString * text1 = [msg.content stringByAppendingString:@"\n\n"];
    NSString * text2 = [text1 stringByAppendingString:msg.note];
    _textLabel.text = text2;
    [self.vi addSubview:_textLabel];
    
    //播放音频按钮
    self.mainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _mainBtn.layer.cornerRadius = 50;
    _mainBtn.layer.masksToBounds = YES;
    _mainBtn.layer.borderWidth = 2;
    
    UIColor * color = [self randomColor];
    [_mainBtn setTitle:@"Listen me" forState:UIControlStateNormal];
    _mainBtn.frame = CGRectMake(self.vi.frame.size.width/2-50, self.textLabel.frame.size.height + self.imageV.frame.size.height + 120, 100, 100);
    [_mainBtn addTarget:self action:@selector(touchChange:) forControlEvents:UIControlEventTouchUpInside];
    [self.vi addSubview:_mainBtn];
    _mainBtn.backgroundColor = [UIColor colorWithRed:0.996 green:0.824 blue:0.224 alpha:1.000];
    
    self.borderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _borderBtn.frame = CGRectMake(self.vi.frame.size.width/2-50, self.textLabel.frame.size.height + self.imageV.frame.size.height + 120, 100, 100);
    _borderBtn.layer.borderColor = color.CGColor;
    _borderBtn.layer.borderWidth = 2;
    _borderBtn.backgroundColor = [UIColor clearColor];
}

//随机颜色的方法
- (UIColor *) randomColor {
    //色调
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    //饱和度
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    //明亮度
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (void) touchChange:(UIButton *)btn
{
    
    //    self.player = [AVPlayer playerWithURL:[NSURL URLWithString:self.tagMP3]];
    //    [self.player play];
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.tagMP3]];
    
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    [self.player play];
    CMTime duration = playerItem.duration;
    NSUInteger dTotalSeconds = CMTimeGetSeconds(duration);
    //    NSUInteger dHours = floor(dTotalSeconds / 3600);
    //    NSUInteger dMinutes = floor(dTotalSeconds % 3600 / 60);
    NSUInteger dSeconds = floor(dTotalSeconds % 3600 % 60);
    //    NSString *videoDurationText = [NSString stringWithFormat:@"%i:%02i:%02i",dHours, dMinutes,dSeconds];
    //    NSLog(@"%lu",(unsigned long)dSeconds);
    [UIView animateWithDuration:dSeconds animations:^{
        CABasicAnimation * basic = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        basic.duration = .5;
        basic.repeatCount = MAXFLOAT;
        basic.fromValue = [NSNumber numberWithInt:.5];
        basic.toValue = [NSNumber numberWithInt:1];
        [self.borderBtn.layer addAnimation:basic forKey:nil];
    } completion:^(BOOL finished) {
        //        [btn.layer removeAllAnimations];
    }];
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

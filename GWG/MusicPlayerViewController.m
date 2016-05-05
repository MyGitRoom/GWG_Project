//
//  MusicPlayerViewController.m
//  GWG_Project
//
//  Created by lanou on 16/5/5.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "MusicPlayerViewController.h"

@interface MusicPlayerViewController ()<GYPlayerDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, strong) NSMutableArray * settings;
@property (nonatomic, strong) UIImageView * albumView;

@end

@implementation MusicPlayerViewController

#pragma mark- 懒加载
- (NSMutableArray *) settings
{
    if (!_settings)
    {
        self.settings = [NSMutableArray array];
    }
    return _settings;
}

-(UIImageView *)albumView
{
    if (!_albumView)
    {
        self.albumView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 50, KScreenWidth-80, KScreenWidth-80)];
        //设置圆形的半径
        self.albumView.layer.cornerRadius = (KScreenWidth - 80)/2;
        self.albumView.layer.masksToBounds = YES;
        [self.scrollView addSubview:_albumView];
    }
    return _albumView;
}

- (void) loadView
{
    //创建背景视图并且设置毛玻璃效果
    UIImageView * imageV = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageV.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.detailMod.cover_url]]];
    self.view = imageV;
        self.view.userInteractionEnabled = YES;
    //毛玻璃效果
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    visualView.frame = self.view.frame;
    [self.view addSubview:visualView];
    
    //创建切换的srcolView
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-kControlBarHeight)];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(KScreenWidth*2, CGRectGetHeight(self.scrollView.bounds));
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    //对控制台设置一个白色的毛玻璃效果
    UIVisualEffectView *eView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    eView.frame = CGRectMake(0, kControlBarOriginY, KScreenWidth, kControlBarHeight);
    [self.view addSubview:eView];
    
    NSLog(@"%@",self.detailMod.sound_url);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //*********初始化返回的按钮**********
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(16, 24, 20, 20);
    [backBtn setImage:[UIImage imageNamed:@"arrowdown.png"] forState:UIControlStateNormal];
    backBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    backBtn.layer.cornerRadius = 10;
    backBtn.layer.masksToBounds = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [backBtn addTarget:self action:@selector(handleDismissAction:) forControlEvents:UIControlEventTouchDown];
    
    [self setControlButton];
    [self setNameAndAlbumLabel];
    
    //添加一个观察者，观察我们的应用程序有没有计入后台，一旦进入后台系统就会自动给我们发送一个通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadVolume) name:UIApplicationDidEnterBackgroundNotification object:nil];
    //每次进来默认播放音乐
    [self reloadMusic];
}

//点击返回按钮时执行的方法
-(void)handleDismissAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//当我们点击Home键就会执行该方法
-(void)loadVolume
{
    //保存退出之前正在播放的音乐
    [[NSUserDefaults standardUserDefaults] setInteger:self.currentIndex forKey:@"index"];
    
}

-(void)setNameAndAlbumLabel
{
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.tag = 20086;
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.center = CGPointMake(KScreenWidth/2, kControlBarCenterY-100);
    nameLabel.text = self.detailMod.title;
    [self.view addSubview:nameLabel];
    
    UILabel *albumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    albumLabel.center = CGPointMake(KScreenWidth/2, kControlBarCenterY-70);
    albumLabel.tag = 20010;
    albumLabel.font = [UIFont systemFontOfSize:12];
    albumLabel.textAlignment = NSTextAlignmentCenter;
    
    albumLabel.text = [self.detailMod.user objectForKey:@"nick"];
    [self.view addSubview:albumLabel];
}

//滑动音乐进度条执行的方法
-(void)handleProgressChangeAction:(UISlider *)sender
{
    [[GYPlayer sharedplayer] seekToTime:sender.value];
}

#pragma -mark创建暂停播放等按钮的
-(void)setControlButton
{
    //*************创建播放按钮***************
    UIButton *playPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    playPauseButton.frame = CGRectMake(0, 0, 30, 30);
    playPauseButton.center = CGPointMake(kControlBarCenterX, kControlBarCenterY);
    
    [playPauseButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    [playPauseButton setImage:[UIImage imageNamed:@"pause_h.png"] forState:UIControlStateHighlighted];
    [playPauseButton addTarget:self action:@selector(handlePlayPauseAction:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:playPauseButton];
    
    //***********创建上一首的按钮****************
    UIButton *rewindButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rewindButton.frame = CGRectMake(0, 0, 30, 30);
    rewindButton.center = CGPointMake(kControlBarCenterX-kButtonOffSetX, kControlBarCenterY);
    [rewindButton setImage:[UIImage imageNamed:@"rewind.png"] forState:UIControlStateNormal];
    [rewindButton setImage:[UIImage imageNamed:@"rewind_h.png"] forState:UIControlStateHighlighted];
    [rewindButton addTarget:self action:@selector(handleRewindAction:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:rewindButton];
    
    //**********创建下一首音乐的按钮****************
    UIButton *forwordButton =[UIButton buttonWithType:UIButtonTypeCustom];
    forwordButton.frame = CGRectMake(0, 0, 30, 30);
    forwordButton.center = CGPointMake(kControlBarCenterX+kButtonOffSetX, kControlBarCenterY);
    [forwordButton setImage:[UIImage imageNamed:@"forward.png"] forState:UIControlStateNormal];
    [forwordButton setImage:[UIImage imageNamed:@"forward_h.png"] forState:UIControlStateHighlighted];
    [forwordButton addTarget:self action:@selector(handleForwordAction:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:forwordButton];
    
}

#pragma -mark播放器的协议方法(0.1s就会调用一次)
-(void)audioPlayer:(GYPlayer *)player didPlayingWithProgress:(float)progress
{
    //让图片进行旋转
    self.albumView.transform = CGAffineTransformRotate(self.albumView.transform, M_PI/360);
}

#pragma -mark点击下一首执行的方法
-(void)handleForwordAction:(UIButton *)sender
{
    self.currentIndex++;
    GYPlayer *player = [GYPlayer sharedplayer];
    [player stop];
    //切换音乐
    [self reloadMusic];
    
}

#pragma -mark点击上一首按钮执行的方法
-(void)handleRewindAction:(UIButton *)sender
{
    self.currentIndex--;
    [self reloadMusic];
}

#pragma -mark每次切换歌曲的时候把页面的元素全部换成该歌曲的内容
-(void)reloadMusic
{
    //改变旋转大图的背景
    [self.albumView sd_setImageWithURL:[NSURL URLWithString:self.detailMod.cover_url]];
    //更新歌名和专辑名字
    [(UILabel *)[self.view viewWithTag:20086] setText:self.detailMod.title];
    [(UILabel*)[self.view viewWithTag:20010] setText:[self.detailMod.user objectForKey:@"nick"]];
    //保证每次切换新歌的时候旋转的图片都从正上方看是旋转
    self.albumView.transform  = CGAffineTransformMakeRotation(0);
    //更换音乐播放器，让音乐播放器，播放当前的音乐
    GYPlayer *player = [GYPlayer sharedplayer];
    player.delegate = self;
    [player pause];
    [player setPlayerWithUrl:self.detailMod.sound_url];
    [player play];
}

#pragma -mark点击播放按钮时执行的方法
-(void)handlePlayPauseAction:(UIButton *)sender
{
    GYPlayer *player = [GYPlayer sharedplayer];
    if ([player isPlaying])
    {
        [player pause];
        [sender setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"play_h.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        [player play];
        [sender setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"pause_h.png"] forState:UIControlStateHighlighted];
    }
}

#pragma mark - Table view 代理方法
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}

@end

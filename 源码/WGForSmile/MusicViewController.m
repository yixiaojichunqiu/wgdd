//
//  MusicViewController.m
//  WGForSmile
//
//  Created by tarena on 15/11/12.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "MusicViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AFNetworking.h"
#import "Masonry.h"

@interface MusicViewController ()
@property (nonatomic,strong) UISlider * slider;
@property (nonatomic,strong) NSTimer * timer;
@property (nonatomic,strong) AVAudioPlayer * player;
@property (nonatomic,strong) UILabel * label;
//@property (nonatomic,strong) NSURL * filePath;
@property (nonatomic,strong) UIButton * downLoadButton;
@property (nonatomic,strong) UIButton * playButton;
@end

@implementation MusicViewController
//-(AVAudioPlayer *)player
//{
//    if (!_player) {
//        NSString* audioPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject] stringByAppendingPathComponent:@"chiyan.mp3"];
//        NSURL* url=[NSURL fileURLWithPath:audioPath];
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//            _player=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
//        });
//    }
//    return _player;
//}


//-(AVAudioPlayer *)player
//{
//    if (!_player) {
//        NSString* audioPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject] stringByAppendingPathComponent:@"麦振鸿 - 长卿-众生平等 - 纯音乐版.mp3"];
//        NSURL* url=[NSURL fileURLWithPath:audioPath];
//        //线程
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//            _player=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
//        });
//    }
//    return _player;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    UIImageView* backgroundImageView=[UIImageView new];
    backgroundImageView.frame=self.view.bounds;
    backgroundImageView.image=[UIImage imageNamed:@"starnight"];
    [self.view addSubview:backgroundImageView];
    
    UIImageView* imageView=[UIImageView new];
    imageView.image=[UIImage animatedImageNamed:@"bomb_" duration:4];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.top.equalTo(self.view).with.offset(70);
        make.height.mas_equalTo(@60);
        make.width.mas_equalTo(@60);
    }];
    
    
    self.slider=[UISlider new];
    self.slider.frame=CGRectMake(20, self.view.frame.size.height-150, self.view.frame.size.width-40, 50);
    //设置轨道背景图
    [self.slider setMaximumTrackImage:[UIImage imageNamed:@"playing_volumn_slide_foreground"] forState:UIControlStateNormal];
    [self.slider setMinimumTrackImage:[UIImage imageNamed:@"playing_volumn_slide_bg"] forState:UIControlStateNormal];
    [self.slider setThumbImage:[UIImage imageNamed:@"playing_volumn_slide_sound_icon"] forState:UIControlStateNormal];
    //设置轨道行进图
    // ...
    [self.slider addTarget:self action:@selector(pan) forControlEvents:UIControlEventTouchDragInside];

    [self.view addSubview:self.slider];
    
    //添加播放按钮
    UIButton *playBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.frame=CGRectMake(self.view.frame.size.width/2-25, self.view.frame.size.height-110, 50, 50);
    self.playButton=playBtn;
    [self.view addSubview:playBtn];
    UIImage *image=[UIImage imageNamed:@"playing_btn_play_n"];
    [playBtn setBackgroundImage:image forState:UIControlStateNormal];
    [playBtn setBackgroundImage:[UIImage imageNamed:@"playing_btn_play_h"] forState:UIControlStateHighlighted];
    [playBtn setBackgroundImage:[UIImage imageNamed:@"playing_btn_pause_n"] forState:UIControlStateSelected];
    [playBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    UILabel* label=[UILabel new];
    label.frame=CGRectMake(20, self.view.frame.size.height-100, 50, 40);
    label.textColor=[UIColor whiteColor];
    [self.view addSubview:label];
    int m=self.slider.value/60;
    int s=(int)(self.slider.value)%60;
    label.text=[NSString stringWithFormat:@"%d:%d",m,s];
    self.label=label;
    
    //添加下载按钮
    UIButton* downLoad=[UIButton buttonWithType:UIButtonTypeCustom];
    //downLoad.frame=CGRectMake(100,100, 100, 100);
    [downLoad setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [downLoad addTarget:self action:@selector(downLoad:) forControlEvents:UIControlEventTouchUpInside];
    self.downLoadButton=downLoad;
    [self.view addSubview:downLoad];
    
    [downLoad mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-20);
        make.bottom.equalTo(self.view).with.offset(-60);
        make.height.mas_equalTo(@40);
        make.width.mas_equalTo(@90);
    }];
}


-(void)viewWillAppear:(BOOL)animated
{
//#warning 有回来后不播放的情况 来回两次后 未解
    [super viewWillAppear:animated];
    [self.downLoadButton setTitle:@"已下载" forState:UIControlStateNormal];
    self.downLoadButton.enabled=NO;
    if (!self.player) {
        NSString* audioPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject] stringByAppendingPathComponent:@"chiyan.mp3"];
        NSURL* url=[NSURL fileURLWithPath:audioPath];
        //static dispatch_once_t onceToken;
        //dispatch_once(&onceToken, ^{
        self.player=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        //});
    }
    if (!self.player) {
        [self.downLoadButton setTitle:@"点击下载" forState:UIControlStateNormal];
        self.downLoadButton.enabled=YES;
    }
    //音乐总时长
    if (self.player) {
        double t=self.player.duration;
        //NSLog(@"%lf",t);
        self.slider.maximumValue=t;//最大值等于音乐的秒数值即可
    }

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.playButton.selected=NO;
    self.slider.value=0;
    [self.timer invalidate];
    self.timer=nil;
    self.player=nil;
    //NSLog(@"离开%@",_player);
}
//-(void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    self.playButton.selected=NO;
//    self.slider.value=0;
//    [self.timer invalidate];
//    self.timer=nil;
//    _player=nil;
//}
-(void)jindutiaogo:(NSTimer*)timer
{
    self.slider.value=self.player.currentTime;
    
    
    int m=self.slider.value/60;
    int s=(int)(self.slider.value)%60;
    self.label.text=[NSString stringWithFormat:@"%d:%d",m,s];
    
    //
    //self.player.currentTime=self.slider.value;
    //
    if (self.slider.value>=self.slider.maximumValue-0.5) {
        [timer invalidate];//销毁定时器
        timer=nil;
        self.playButton.selected=NO;
        self.slider.value=0;
        NSLog(@"定时器关闭");
    }
}

-(void)click:(UIButton*)sender
{
    if (self.player) {
        sender.selected=!sender.selected;
        if (sender.selected) {
            self.timer=[NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(jindutiaogo:) userInfo:nil repeats:YES];
            [self.player play];
        }
        else
        {
            [self.timer invalidate];//销毁定时器
            self.timer=nil;
            NSLog(@"定时器关闭");
            [self.player pause];
            
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//创建一个下载任务
-(void)downLoad:(UIButton*)sender
{
    [self.downLoadButton setTitle:@"正在下载" forState:UIControlStateNormal];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:@"http://game.ailym.com/music/chiyan.mp3"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        //self.filePath=filePath;
        [self.downLoadButton setTitle:@"已下载" forState:UIControlStateNormal];
        self.downLoadButton.enabled=NO;
        NSString* audioPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject] stringByAppendingPathComponent:@"chiyan.mp3"];
        NSURL* url=[NSURL fileURLWithPath:audioPath];
        self.player=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    }];
    [downloadTask resume];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//一旦slider被拖动

-(void)pan
{
    self.player.currentTime=self.slider.value;
}


@end

//
//  WelcomeViewController.m
//  WGForSmile
//
//  Created by tarena on 15/11/19.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "WelcomeViewController.h"
#import "AppDelegate.h"
@interface WelcomeViewController ()
@property(nonatomic,strong)NSArray *allImageNames;
@end

@implementation WelcomeViewController

- (NSArray *)allImageNames{
    if (!_allImageNames) {
        _allImageNames = @[@"welcome1",@"welcome2",@"welcome3",@"welcome4"];
    }
    return _allImageNames;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.frame = self.view.frame;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*self.allImageNames.count, scrollView.frame.size.height);
    //将数组中存储的所有图片名对应的图片
    //放入到imageView中,然后将imageView
    //添加到scrollView中
    for (NSInteger i=0; i<self.allImageNames.count; i++) {
        UIImage *image = [UIImage imageNamed:self.allImageNames[i]];
        // 将图片放入到imageView中
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        //明确的设置imageView的位置及大小信息
        CGRect imageFrame = CGRectZero ;
        imageFrame.size = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height);
        imageFrame.origin = CGPointMake(i*scrollView.frame.size.width, 0);
        imageView.frame = imageFrame;
        //将图片视图添加到scrollView中
        [scrollView addSubview:imageView];
        if (i==self.allImageNames.count-1) {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=imageFrame;
            [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:btn];
        }
        
    }
    //设置边缘不能弹跳
    scrollView.bounces = NO;
    //设置整页滚动
    scrollView.pagingEnabled = YES;
    //设置水平滚动条不可见
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
}


-(void)click:(id)sender
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"notOnce"];
    [defaults synchronize];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //取得当前视图所在window
    self.view.window.rootViewController=tempAppDelegate.leftSliderNaviVC;
}

@end

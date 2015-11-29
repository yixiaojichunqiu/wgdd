//
//  TopRepeatScrollView.m
//  WGForSmile
//
//  Created by tarena on 15/10/16.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "TopRepeatScrollView.h"

@interface TopRepeatScrollView ()<UIScrollViewDelegate>
@property (nonatomic,strong) NSArray* imagenames;//接收图片的属性
@property (nonatomic,strong) UIPageControl* pagecontrol;//本view上的pagecontrol来个属性便于引用
@property (nonatomic,strong) UIScrollView* scrollview;//便于引用
@property (nonatomic) NSInteger index;
@end

@implementation TopRepeatScrollView
-(NSArray*)imagenames
{
    if (!_imagenames) {
        _imagenames=@[@"head4",@"head1",@"head2",@"head3",@"head4",@"head1"];
    }
    return _imagenames;
}
-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.frame=CGRectMake(0, 0, frame.size.width, thisScreenHeight/4.5);
        [self awake];
    }
    return self;
}

-(void)awake
{
    
    //先是添加scrollview里面放imageview
    UIScrollView *scrollview=[[UIScrollView alloc]init];
    scrollview.frame=self.frame;
    scrollview.contentSize=CGSizeMake(self.frame.size.width*self.imagenames.count, 0);
    scrollview.bounces = NO;
    //设置整页滚动
    scrollview.pagingEnabled = YES;
    //设置水平滚动条不可见
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.showsVerticalScrollIndicator =NO;
    //设置代理
    scrollview.delegate=self;
    scrollview.tag=32;
    for (int i=0; i<self.imagenames.count; i++) {
        UIImageView *imageview=[[UIImageView alloc]initWithImage:[UIImage imageNamed:self.imagenames[i]]];
        CGRect rect=self.frame;
        rect.origin.x=i*rect.size.width;
        imageview.frame=rect;
        [scrollview addSubview:imageview];
    }
    self.scrollview=scrollview;
    [self addSubview:scrollview];
    //再在view上加pagecontrol
    UIPageControl* pagecontrol=[[UIPageControl alloc]init];
    pagecontrol.numberOfPages=self.imagenames.count-2;
    pagecontrol.center=CGPointMake(self.center.x, self.frame.size.height-10);
    pagecontrol.pageIndicatorTintColor=[UIColor blueColor];
    pagecontrol.currentPageIndicatorTintColor=[UIColor greenColor];
    self.pagecontrol=pagecontrol;
    [self addSubview:pagecontrol];
    //一开始的时候就滚动到第一张图的位置375 0
    [scrollview setContentOffset:CGPointMake(self.bounds.size.width, 0) animated:NO];
    //最后加上定时器
    self.timer=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(gotonextpage:) userInfo:nil repeats:YES];
}
//每次翻的时候监测
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset=scrollView.contentOffset;
    NSInteger index=round(offset.x/self.frame.size.width);
    self.index=index;
    self.pagecontrol.currentPage=index-1;
    if (index==self.imagenames.count-1) {
        self.pagecontrol.currentPage=0;
    }
    if (index==0) {
        self.pagecontrol.currentPage=self.imagenames.count-3;
    }
}
//每次翻页结束
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset=scrollView.contentOffset;
    NSInteger index=round(offset.x/self.frame.size.width);
    if (index==self.imagenames.count-1) {
        [scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0) animated:NO];
    }
    if (index==0) {
        [scrollView setContentOffset:CGPointMake(self.bounds.size.width*(self.imagenames.count-2), 0) animated:NO];
    }
}

//定时器方法
-(void)gotonextpage:(id)sender
{
    [self.scrollview setContentOffset:CGPointMake(self.frame.size.width*(self.index+1),0) animated:YES];
    if (self.index==self.imagenames.count-1) {
        [self.scrollview setContentOffset:CGPointMake(self.frame.size.width, 0)];
    }
}

@end

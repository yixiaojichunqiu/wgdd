//
//  RecordPageViewController.m
//  WGForSmile
//
//  Created by tarena on 15/11/9.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "RecordPageViewController.h"
#import "AppDelegate.h"
#import "MoodViewController.h"
#import "MyButton.h"
@interface RecordPageViewController ()<UICollisionBehaviorDelegate>
@property (nonatomic,strong) UIDynamicAnimator * animator;
@property (nonatomic,strong) UIGravityBehavior * gravity;
@property (nonatomic,strong) UICollisionBehavior * collision;
@property (nonatomic,strong) UIAttachmentBehavior * attachment;
@property (nonatomic,strong) UIView * animatorView;
@property (nonatomic,strong) UIButton * inbutton;
@property (nonatomic,strong) NSTimer * timer;
@end

@implementation RecordPageViewController
-(UIGravityBehavior *)gravity
{
    if (!_gravity) {
        _gravity=[[UIGravityBehavior alloc]init];
        _gravity.magnitude=0.6;
    }
    return _gravity;
}

-(UICollisionBehavior *)collision
{
    if (!_collision) {
        _collision=[[UICollisionBehavior alloc]init];
        _collision.translatesReferenceBoundsIntoBoundary=YES;
        _collision.collisionDelegate=self;
    }
    return _collision;
}
-(UIAttachmentBehavior *)attachment
{
    if (!_attachment) {
        _attachment=[[UIAttachmentBehavior alloc]initWithItem:self.inbutton attachedToAnchor:CGPointMake(self.inbutton.center.x, self.inbutton.center.y-150)];
        _attachment.damping=0.5;
        _attachment.frequency=0.8;
    }
    return _attachment;
}
-(id)init
{
    self.title=@"记录";
    self.tabBarItem.selectedImage=[UIImage imageNamed:@"tab_heros_selected"];
    //    self.tabBarItem.selectedImage=[[UIImage imageNamed:@"tab_infomation_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.image=[UIImage imageNamed:@"tab_heros_normal"];
    //    self.tabBarController.tabBar.backgroundImage=nil;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *menubtn=[UIButton buttonWithType:UIButtonTypeCustom];
    menubtn.frame=CGRectMake(0, 0, 20, 18);
    [menubtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [menubtn addTarget:self action:@selector(openorcloseleftlist) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:menubtn];
    //背景
    UIImageView* imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"snowing"]];
    imageView.frame=self.view.bounds;
    [self.view addSubview:imageView];
    //动力
    UIView* animatorView=[[UIView alloc]init];
    animatorView.frame=CGRectMake(0, 60, self.view.width, thisScreenHeight-170);
    self.animatorView=animatorView;
    //变成真实的物理世界环境
    self.animator=[[UIDynamicAnimator alloc]initWithReferenceView:self.animatorView];
    //向力学环境添加重力行为
    [self.animator addBehavior:self.gravity];
    self.timer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(createSnow:) userInfo:nil repeats:YES];
    [self.animator addBehavior:self.collision];
    [self.view addSubview:self.animatorView];
    MyButton* inbutton=[MyButton buttonWithType:UIButtonTypeCustom];
    inbutton.layer.cornerRadius=inbutton.frame.size.width/2;
    inbutton.frame=CGRectMake(self.animatorView.centerX, self.animatorView.centerY-50, 80, 80);
    inbutton.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    [inbutton addTarget:self action:@selector(nextPage:) forControlEvents:UIControlEventTouchUpInside];
    [inbutton setBackgroundImage:[UIImage imageNamed:@"elephant"] forState:UIControlStateHighlighted];
    [self.animatorView addSubview:inbutton];
    self.inbutton=inbutton;
    [self.animator addBehavior:self.attachment];
    [self.gravity addItem:self.inbutton];
    [self.collision addItem:self.inbutton];
    UITapGestureRecognizer* tapGR=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.animatorView addGestureRecognizer:tapGR];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.timer setFireDate:[NSDate distantPast]];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.timer setFireDate:[NSDate distantFuture]];//计数器占内存问题
}

-(void)createSnow:(id)timer
{
    CGFloat x=arc4random()%((int)self.view.bounds.size.width-20);
    CGRect frame=CGRectMake(x, 0, 20, 20);
    UIImageView* imageview=[[UIImageView alloc]initWithFrame:frame];
    imageview.image=[UIImage imageNamed:@"snow"];
    [self.animatorView addSubview:imageview];
    [self.gravity addItem:imageview];
    [self.collision addItem:imageview];
}
-(void)openorcloseleftlist
{
    AppDelegate *tempappdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    //两个开关的方法
    if (tempappdelegate.leftsilderVC.closed) {
        [tempappdelegate.leftsilderVC openLeftView];
    }
    else
    {
        [tempappdelegate.leftsilderVC closeLeftView];
    }
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
//移除到底的雪花
-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p
{
    if ([item1 isKindOfClass:[UIImageView class]]) {
        if ([item2 isKindOfClass:[UIImageView class]]) {
            UIImageView *v1=(UIImageView*)item1;
            UIImageView *v2=(UIImageView*)item2;
            [self.collision removeItem:item1];
            [self.collision removeItem:item2];
            [v1 removeFromSuperview];
            [v2 removeFromSuperview];
        }
    }
}

-(void)tap:(UITapGestureRecognizer*)gr
{
    CGPoint point=[gr locationInView:self.animatorView];
    self.attachment.anchorPoint=point;
}
-(void)nextPage:(UIButton*)sender
{
    [self.navigationController pushViewController:[MoodViewController new] animated:YES];
}
@end

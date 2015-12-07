//
//  LeftSlideViewController.m
//  LeftSlideViewController
//
//  Created by huangzhenyu on 15/06/18.
//  Copyright (c) 2015年 huangzhenyu. All rights reserved.

#import "LeftSlideViewController.h"


@interface LeftSlideViewController ()<UIGestureRecognizerDelegate>
//{
//    CGFloat _scalef;  //实时横向位移
//}

@property (nonatomic, assign) CGFloat scalef;
@property (nonatomic,strong) UIView *leftView;
//@property (nonatomic,assign) CGFloat leftViewW;//
@property (nonatomic,strong) UIView *coverView;//
@end


@implementation LeftSlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //隐藏navi
}

/**
 @brief 初始化侧滑控制器
 @param leftVC 左视图控制器
 mainVC 中间视图控制器
 @result instancetype 初始化生成的对象
 */
- (instancetype)initWithLeftView:(UIViewController *)leftVC
                     andMainView:(UIViewController *)mainVC
{
    if(self = [super init]){
        self.speedf = vSpeedFloat;//设置属性
        
        self.leftVC = leftVC;
        self.mainVC = mainVC;
        
        //滑动手势
        self.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        [self.mainVC.view addGestureRecognizer:self.pan];//mainvc加滑动手势
        UISwipeGestureRecognizer* swipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan2:)];
        [self.leftVC.view addGestureRecognizer:swipe];
        swipe.delegate=self;
        swipe.direction=UISwipeGestureRecognizerDirectionLeft;
        
        [self.pan setCancelsTouchesInView:YES];
        self.pan.delegate = self;//设置手势代理
        self.leftVC.view.hidden = YES;
        
        [self.view addSubview:self.leftVC.view];
        
        //蒙版
        UIView *view = [[UIView alloc] init];
        view.frame = self.leftVC.view.bounds;
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.5;
        self.coverView = view;
        [self.leftVC.view addSubview:view];
        
        //获取左侧view （在viewcontroller中找view 遍历 通过判断类型找）
        for (UIView *obj in leftVC.view.subviews) {
            if (([obj isKindOfClass:[UICollectionView class]])||([obj isKindOfClass:[UITableView class]])) {
                self.leftView = obj;
            }
        }
        self.leftView.backgroundColor = [UIColor clearColor];
        self.leftView.frame = CGRectMake(0, 0, kScreenWidth - kMainPageDistance, kScreenHeight);
        //设置左侧view的初始位置和缩放系数
        self.leftView.transform = CGAffineTransformMakeScale(kLeftScale, kLeftScale);
        self.leftView.center = CGPointMake(kLeftCenterX, kScreenHeight * 0.5);//?
        
        [self.view addSubview:self.mainVC.view];
        self.closed = YES;//初始时侧滑窗关闭
        
    }
    return self;
}
#pragma mark===页面即将出现

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.leftVC.view.hidden = NO;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}
#pragma mark - 滑动手势
-(void) handlePan2: (UIPanGestureRecognizer *)rec
{
    [self closeLeftView];
}

//滑动手势 mainvc滑动手势
- (void) handlePan: (UIPanGestureRecognizer *)rec{
    //translation这个属性记录移动的当前点距离之前点的位移
    CGPoint translation = [rec translationInView:self.view];
    _scalef = (translation.x * self.speedf + _scalef);//实时横向位移

    BOOL needMoveWithTap = YES;  //是否还需要跟随手指移动
    if (((self.mainVC.view.x <= 0) && (_scalef <= 0)) || ((self.mainVC.view.x >= (kScreenWidth - kMainPageDistance )) && (_scalef >= 0)))
    {
        //边界值管控
        _scalef = 0;
        needMoveWithTap = NO;
    }
    
    //根据视图位置判断是左滑还是右边滑动
    if (needMoveWithTap && (rec.view.frame.origin.x >= 0) && (rec.view.frame.origin.x <= (kScreenWidth - kMainPageDistance)))
    {
        //rec 中心点横向
        CGFloat recCenterX = rec.view.center.x + translation.x * self.speedf;
        if (recCenterX < kScreenWidth * 0.5 - 2) {
            recCenterX = kScreenWidth * 0.5;
        }
        
        CGFloat recCenterY = rec.view.center.y;//中心点纵向
        
        rec.view.center = CGPointMake(recCenterX,recCenterY);

        //scale 1.0~kMainPageScale //比例
        CGFloat scale = 1 - (1 - kMainPageScale) * (rec.view.frame.origin.x / (kScreenWidth - kMainPageDistance));
    
        rec.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,scale, scale);
        [rec setTranslation:CGPointMake(0, 0) inView:self.view];
        
        CGFloat leftTabCenterX = kLeftCenterX + ((kScreenWidth - kMainPageDistance) * 0.5 - kLeftCenterX) * (rec.view.frame.origin.x / (kScreenWidth - kMainPageDistance));

        //NSLog(@"%f",leftTabCenterX);
        
        
        //leftScale kLeftScale~1.0
        CGFloat leftScale = kLeftScale + (1 - kLeftScale) * (rec.view.frame.origin.x / (kScreenWidth - kMainPageDistance));
        
        self.leftView.center = CGPointMake(leftTabCenterX, kScreenHeight * 0.5);
        self.leftView.transform = CGAffineTransformScale(CGAffineTransformIdentity, leftScale,leftScale);
        
        //tempAlpha kLeftAlpha~0
        CGFloat tempAlpha = kLeftAlpha - kLeftAlpha * (rec.view.frame.origin.x / (kScreenWidth - kMainPageDistance));
        self.coverView.alpha = tempAlpha;

    }
    else
    {
        //超出范围，
        if (self.mainVC.view.x < 0)
        {
            [self closeLeftView];
            _scalef = 0;
        }
        else if (self.mainVC.view.x > (kScreenWidth - kMainPageDistance))
        {
            [self openLeftView];
            _scalef = 0;
        }
    }
    
    //手势结束后修正位置,超过约一半时向多出的一半偏移
    if (rec.state == UIGestureRecognizerStateEnded) {
        if (fabs(_scalef) > vCouldChangeDeckStateDistance)
        {
            if (self.closed)
            {
                [self openLeftView];
            }
            else
            {
                [self closeLeftView];
            }
        }
        else
        {
            if (self.closed)
            {
                [self closeLeftView];
            }
            else
            {
                [self openLeftView];
            }
        }
        _scalef = 0;
    }
}


#pragma mark - 单击手势
-(void)handeTap:(UITapGestureRecognizer *)tap{
    
    if ((!self.closed) && (tap.state == UIGestureRecognizerStateEnded))
    {
        [UIView beginAnimations:nil context:nil];
        tap.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
        tap.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
        self.closed = YES;
        
        self.leftView.center = CGPointMake(kLeftCenterX, kScreenHeight * 0.5);
        self.leftView.transform = CGAffineTransformScale(CGAffineTransformIdentity,kLeftScale,kLeftScale);
        self.coverView.alpha = kLeftAlpha;
        
        [UIView commitAnimations];
        _scalef = 0;
        [self removeSingleTap];
    }
    
}

#pragma mark - 修改视图位置
/**
 @brief 关闭左视图
 */
- (void)closeLeftView
{
    [UIView beginAnimations:nil context:nil];
    self.mainVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    self.mainVC.view.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2);
    self.closed = YES;
    
    self.leftView.center = CGPointMake(kLeftCenterX, kScreenHeight * 0.5);
    self.leftView.transform = CGAffineTransformScale(CGAffineTransformIdentity,kLeftScale,kLeftScale);
    self.coverView.alpha = kLeftAlpha;
    
    [UIView commitAnimations];
    [self removeSingleTap];
}

/**
 @brief 打开左视图
 */
- (void)openLeftView;
{
    [UIView beginAnimations:nil context:nil];
    self.mainVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,kMainPageScale,kMainPageScale);
    self.mainVC.view.center = kMainPageCenter;
    self.closed = NO;
    
    self.leftView.center = CGPointMake((kScreenWidth - kMainPageDistance) * 0.5, kScreenHeight * 0.5);
    self.leftView.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    self.coverView.alpha = 0;
    
    [UIView commitAnimations];
    [self disableTapButton];
}

#pragma mark - 行为收敛控制
- (void)disableTapButton
{
    for (UIButton *tempButton in [_mainVC.view subviews])
    {
        [tempButton setUserInteractionEnabled:NO];
    }
    //单击
    if (!self.sideslipTapGes)
    {
        //单击手势
        self.sideslipTapGes= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handeTap:)];
        [self.sideslipTapGes setNumberOfTapsRequired:1];
        
        [self.mainVC.view addGestureRecognizer:self.sideslipTapGes];
        self.sideslipTapGes.cancelsTouchesInView = YES;  //点击事件盖住其它响应事件,但盖不住Button;
    }
}

//关闭行为收敛
- (void) removeSingleTap
{
    for (UIButton *tempButton in [self.mainVC.view  subviews])
    {
        [tempButton setUserInteractionEnabled:YES];
    }
    [self.mainVC.view removeGestureRecognizer:self.sideslipTapGes];
    self.sideslipTapGes = nil;
}

/**
 *  设置滑动开关是否开启
 *
 *  @param enabled YES:支持滑动手势，NO:不支持滑动手势
 */

- (void)setPanEnabled: (BOOL) enabled
{
    [self.pan setEnabled:enabled];
}

#pragma mark---不响应侧滑设置
//可以设置有的控件不响应侧滑
-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
//
//    NSLog(@"%d",[touch.view isKindOfClass:[UITableViewCell class]]);
//    NSLog(@"%d",[touch.view isKindOfClass:[UITableView class]]);
//    NSLog(@"%d",[touch.view isKindOfClass:[UIScrollView class]]);
//    NSLog(@"%d",[touch.view isMemberOfClass:[UIView class]]);
//    NSLog(@"%@",touch.view);
//    BOOL oneport=[touch.view isKindOfClass:[UITableViewCell class]]||[touch.view isKindOfClass:[UITableView class]]||[touch.view isKindOfClass:[UIScrollView class]];
//    NSLog(@"oneport%d",oneport);
    //目前解决方案比较差
    if(
       touch.view.tag == vDeckCanNotPanViewTag||touch.view.tag ==12||touch.view.tag ==13||touch.view.tag ==14||touch.view.tag ==32)
       //||[touch.view isKindOfClass:[UIView class]])
       //||[touch.view isKindOfClass:[UITableViewCellContentView class]])
//    if(touch.view.tag==999)
    {
//        NSLog(@"不响应侧滑");
        return NO;
    }
    else
    {
//        NSLog(@"响应侧滑");
        return YES;
    }
//    if (touch.view.tag==11) {
//        return YES;
//    }
//    return NO;
}
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}

//判断两个手势能否同时被识别
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    //判断手势 首先属于pan手势
    //如果是 转换 然后算位移 竖直就不支持 多手势返回no 防止tableview竖直滑动时造成左侧抽屉拉出
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *pan=(UIPanGestureRecognizer*)gestureRecognizer;
        if ([pan translationInView:self.view].y!=0) {
            return NO;
        }
        
    }
    return YES;
}
@end

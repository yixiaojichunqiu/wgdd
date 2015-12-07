//
//  AppDelegate.m
//  WGForSmile
//
//  Created by tarena on 15/10/10.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "AppDelegate.h"
#import <BmobSDK/Bmob.h>

#import "NewsPageViewController.h"
#import "AroundPageViewController.h"
#import "RecordPageViewController.h"
#import "DiscoveryPageViewController.h"
#import "MorePageViewController.h"

#import "WelcomeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Bmob registerWithAppKey:@"fa3c76c84a7e4b47341a347da8e03780"];    
    //设置window
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //把主要的五个页面加上导航控制器
    NewsPageViewController* newspageviewcontroller=[[NewsPageViewController alloc]init];
    AroundPageViewController* aroundpageviewcontroller=[[AroundPageViewController alloc]init];
    RecordPageViewController* recordpageviewcontroller=[[RecordPageViewController alloc]init];
    DiscoveryPageViewController* discoverypageviewcontroller=[[DiscoveryPageViewController alloc]init];
    MorePageViewController* morepageviewcontroller=[[MorePageViewController alloc]init];
    UINavigationController* navinewspageviewcontroller=[[UINavigationController alloc]initWithRootViewController:newspageviewcontroller];
    UINavigationController* naviaroundpageviewcontroller=[[UINavigationController alloc]initWithRootViewController:aroundpageviewcontroller];
    UINavigationController* navirecordpageviewcontroller=[[UINavigationController alloc]initWithRootViewController:recordpageviewcontroller];
    UINavigationController* navidiscoverypageviewcontroller=[[UINavigationController alloc]initWithRootViewController:discoverypageviewcontroller];
    UINavigationController* navimorepageviewcontroller=[[UINavigationController alloc]initWithRootViewController:morepageviewcontroller];
    //把导航加到tabbar控制器
    BeginPageViewController* beginpagetabbarviewcontroller=[[BeginPageViewController alloc]init];
    beginpagetabbarviewcontroller.viewControllers=@[navinewspageviewcontroller,naviaroundpageviewcontroller,navirecordpageviewcontroller,navidiscoverypageviewcontroller,navimorepageviewcontroller];
    //建立左侧的个人页面
    self.personpagecollectionviewcontroller=[[PersonalPageViewController alloc]init];
    //属性 左侧抽屉控制器 控制 个人和主tabbar
    self.leftsilderVC=[[LeftSlideViewController alloc]initWithLeftView:self.personpagecollectionviewcontroller andMainView:beginpagetabbarviewcontroller];
    self.leftSliderNaviVC=[[UINavigationController alloc]initWithRootViewController:self.leftsilderVC];
    //美化导航和tabbar
    //[self customNavigationBar];
    //[self customTabbar];
    //判断是否第一次下载应用登录
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    BOOL notOnce=[defaults boolForKey:@"notOnce"];
    if (notOnce) {
        //设置主控制器为 左侧抽屉
        self.window.rootViewController=self.leftSliderNaviVC;
    }
    else{
        WelcomeViewController *welcome = [WelcomeViewController new];
        self.window.rootViewController = welcome;
    }
    return YES;
}

-(void)customNavigationBar{
    //设置导航条的背景图
    //[[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"bg_navigationBar_normal"] forBarMetrics:UIBarMetricsDefault];
    
    //navi背景色
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];//1
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];//1

    //设置左右按钮上的文字颜色
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];//1
    //返回按钮样式
    [[UINavigationBar appearance]setBackIndicatorImage:[UIImage imageNamed:@"back_btn"]];
    [[UINavigationBar appearance]setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back_btn"]];
    //修改中间题目的文字样式 添加阴影 修改字体大小
//    NSShadow *shadow=[NSShadow new];
//    shadow.shadowColor=[UIColor redColor];
//    shadow.shadowOffset=CGSizeMake(0, 1);
    //题目展示的相关属性 其中键只能死记硬背
//    NSDictionary *attrDic=@{NSShadowAttributeName:shadow,NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:[UIColor greenColor]};
//    [[UINavigationBar appearance]setTitleTextAttributes:attrDic];
}
//美化工具栏
-(void)customTabbar{
    //背景图
    [[UITabBar appearance]setBackgroundImage:[UIImage imageNamed:@"appcoda-logo"]];
    //设置每一项被选中时的背景图
    [[UITabBar appearance]setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar_selected_back"]];
    
    //修改文字的位置
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -2)];
    //设置正常状态下，标签栏题目的颜色和字体大小
//    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateNormal];
    //设置被选中状态的标签栏题目颜色和大小
//    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor],NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateSelected];
}

//禁止横屏
-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

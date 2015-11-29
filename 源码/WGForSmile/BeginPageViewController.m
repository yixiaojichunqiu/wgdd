//
//  BeginPageViewController.m
//  WGForSmile
//
//  Created by tarena on 15/10/11.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "BeginPageViewController.h"
#import "AppDelegate.h"
#import <BmobSDK/Bmob.h>

@interface BeginPageViewController ()

@end

@implementation BeginPageViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //NSLog(@"tabbar chuxian");
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    BmobUser* bUser=[BmobUser getCurrentUser];
    if (bUser) {
        tempAppDelegate.personpagecollectionviewcontroller.nickNameLabel.text=[bUser objectForKey:@"nickName"];
        tempAppDelegate.personpagecollectionviewcontroller.headimageview.image=[UIImage imageNamed:@"elephant"];
        tempAppDelegate.personpagecollectionviewcontroller.outButton.hidden=NO;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"加载");
//
//    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    BmobUser* bUser=[BmobUser getCurrentUser];
//    if (bUser) {
//        tempAppDelegate.personpagecollectionviewcontroller.nickNameLabel.text=[bUser objectForKey:@"nickName"];
//        tempAppDelegate.personpagecollectionviewcontroller.headimageview.image=[UIImage imageNamed:@"elephant"];
//        tempAppDelegate.personpagecollectionviewcontroller.outButton.hidden=NO;
//    }
    //
    self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
////页面出现消失 pan手势开关
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    NSLog(@"viewWillDisappear");
//    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [tempAppDelegate.leftsilderVC setPanEnabled:NO];
//    NSLog(@"消失");
//}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    NSLog(@"viewWillAppear");
//    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [tempAppDelegate.leftsilderVC setPanEnabled:YES];
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

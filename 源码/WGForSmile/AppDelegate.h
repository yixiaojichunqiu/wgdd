//
//  AppDelegate.h
//  WGForSmile
//
//  Created by tarena on 15/10/10.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSlideViewController.h"
#import "PersonalPageViewController.h"
#import "BeginPageViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) UINavigationController * leftSliderNaviVC;
@property (strong, nonatomic) LeftSlideViewController* leftsilderVC;
@property (nonatomic,strong) PersonalPageViewController * personpagecollectionviewcontroller;
@end


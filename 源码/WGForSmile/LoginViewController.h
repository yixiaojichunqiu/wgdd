//
//  LoginViewController.h
//  WGForSmile
//
//  Created by tarena on 15/11/7.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewControllerDelegate <NSObject>
-(void)refresh;
@end

@interface LoginViewController : UIViewController

@property (nonatomic) id<LoginViewControllerDelegate> delegate;

@end

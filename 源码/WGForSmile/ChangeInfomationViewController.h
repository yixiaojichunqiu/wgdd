//
//  ChangeInfomationViewController.h
//  WGForSmile
//
//  Created by tarena on 15/11/17.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BlockSet)(NSString*);

@interface ChangeInfomationViewController : UIViewController

@property (nonatomic,strong) BlockSet block;

@end

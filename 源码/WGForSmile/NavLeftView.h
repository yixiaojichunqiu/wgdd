//
//  NavLeftView.h
//  WGForSmile
//
//  Created by tarena on 15/11/15.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavLeftView : UIView
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * subLabel;
@property (nonatomic,strong) UIButton * imageButton;

+(id)customView;

@end

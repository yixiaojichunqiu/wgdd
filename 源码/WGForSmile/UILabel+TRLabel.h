//
//  UILabel+TRLabel.h
//  TRWeather
//
//  Created by tarena on 15/10/23.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (TRLabel)

//给定label的frame 返回一个创建好的uilabel
+(UILabel*)labelWithFrameByCategory:(CGRect)frame;

@end

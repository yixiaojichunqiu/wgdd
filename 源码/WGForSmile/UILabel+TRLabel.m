//
//  UILabel+TRLabel.m
//  TRWeather
//
//  Created by tarena on 15/10/23.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "UILabel+TRLabel.h"

@implementation UILabel (TRLabel)

+(UILabel *)labelWithFrameByCategory:(CGRect)frame
{
    UILabel *label=[[UILabel alloc]initWithFrame:frame];
    label.textColor=[UIColor whiteColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    return label;
}
@end

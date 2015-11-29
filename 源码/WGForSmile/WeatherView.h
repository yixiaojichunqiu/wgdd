//
//  WeatherView.h
//  WGForSmile
//
//  Created by tarena on 15/11/10.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+TRLabel.h"

@interface WeatherView : UIView
//城市lable
@property (nonatomic,strong) UILabel * cityLabel;
//天气图标
@property (nonatomic,strong) UIImageView * iconView;
//描述天气情况
@property (nonatomic,strong) UILabel * conditionsLabel;
//当前的温度值
@property (nonatomic,strong) UILabel * temperatureLabel;
//最高 最低温度
@property (nonatomic,strong) UILabel * hiloLabel;

@end

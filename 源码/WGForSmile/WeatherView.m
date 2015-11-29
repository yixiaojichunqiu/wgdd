//
//  WeatherView.m
//  WGForSmile
//
//  Created by tarena on 15/11/10.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "WeatherView.h"

static CGFloat inset=40;//左右边界
static CGFloat temperatureHeight=110;//当前温度label高度
static CGFloat labelHeight=30;//其他label高度
static CGFloat statusBarHeight=64;//把上面留出来20
@implementation WeatherView

//重写父类的initwithframe方法
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        
        //添加5个控件
        //city label
        CGRect cityFrame=CGRectMake(0, statusBarHeight, frame.size.width, labelHeight);
        self.cityLabel=[UILabel labelWithFrameByCategory:cityFrame];
        self.cityLabel.text=@"Loading";
        //添加到视图上
        [self addSubview:self.cityLabel];
        
        
        //最低最高温label
        CGRect hiloFrame=CGRectMake(inset, frame.size.height-labelHeight, frame.size.width-2*inset, labelHeight);
        self.hiloLabel=[UILabel labelWithFrameByCategory:hiloFrame];
        self.hiloLabel.text=@"10˚/20˚";
        [self addSubview:self.hiloLabel];
        
        
        //当前温度label
        CGRect tempFrame=CGRectMake(inset, frame.size.height-(labelHeight+temperatureHeight), frame.size.width-2*inset, temperatureHeight);
        self.temperatureLabel=[UILabel labelWithFrameByCategory:tempFrame];
        self.temperatureLabel.text=@"18˚";
        self.temperatureLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:60];
        [self addSubview:self.temperatureLabel];
        
        
        //天气图标imageview
        CGRect iconFrame=CGRectMake(inset, tempFrame.origin.y-labelHeight, labelHeight, labelHeight);
        self.iconView=[[UIImageView alloc]initWithFrame:iconFrame];
        self.iconView.image=[UIImage imageNamed:@"placeholder"];
        [self addSubview:self.iconView];
        
        //天气描述label
        CGRect conditionFrame=CGRectMake(inset+labelHeight, tempFrame.origin.y-labelHeight,frame.size.width-2*inset-labelHeight , labelHeight);
        self.conditionsLabel=[UILabel labelWithFrameByCategory:conditionFrame];
        self.conditionsLabel.text=@"111";
        [self addSubview:self.conditionsLabel];
        
        
        NSString* plistPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject]stringByAppendingPathComponent:@"weather.plist"];
        NSArray* weatherArray=[NSArray arrayWithContentsOfFile:plistPath];
        if (weatherArray.count>0) {
            self.cityLabel.text=weatherArray[0];
            self.conditionsLabel.text=weatherArray[1];
            self.temperatureLabel.text=weatherArray[2];
            self.hiloLabel.text=weatherArray[3];
        }
        
        
        
    }
    return self;
}

@end

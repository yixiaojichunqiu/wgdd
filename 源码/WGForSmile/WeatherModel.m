//
//  WeatherModel.m
//  WGForSmile
//
//  Created by tarena on 15/11/10.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "WeatherModel.h"

@implementation WeatherModel

//头部解析
-(id)initWithHeader:(NSDictionary*)headerDic
{
    if (self=[super init]) {
        self.cityName=headerDic[@"request"][0][@"query"];
        NSString* iconStr=headerDic[@"current_condition"][0][@"weatherIconUrl"][0][@"value"];
        self.iconURLStr=[NSURL URLWithString:iconStr];
        self.conditionsStr=headerDic[@"current_condition"][0][@"weatherDesc"][0][@"value"];
        self.tempStr=headerDic[@"current_condition"][0][@"temp_C"];
        self.minTempStr=headerDic[@"weather"][0][@"mintempC"];
        self.maxTempStr=headerDic[@"weather"][0][@"maxtempC"];
        
    }
    return self;
}

+(id)weatherWithHeader:(NSDictionary*)headerDic
{
    return [[self alloc]initWithHeader:headerDic];
}
@end

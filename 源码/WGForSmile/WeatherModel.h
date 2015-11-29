//
//  WeatherModel.h
//  WGForSmile
//
//  Created by tarena on 15/11/10.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherModel : NSObject

//城市名称
@property (nonatomic,strong) NSString* cityName;
//图片的url
@property (nonatomic,strong) NSURL* iconURLStr;
//当前天气的描述
@property (nonatomic,strong) NSString* conditionsStr;
//当前天气的温度
@property (nonatomic,strong) NSString* tempStr;
//当前天气最高温度
@property (nonatomic,strong) NSString * maxTempStr;
//当前天气最低温度
@property (nonatomic,strong) NSString * minTempStr;

+(id)weatherWithHeader:(NSDictionary*)headerDic;
@end

//
//  AroundDataTool.h
//  WGForSmile
//
//  Created by tarena on 15/11/16.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AroundDataTool : NSObject



+(NSArray*)cities;

+(NSArray*)regionsByCity:(NSString*)cityName;

+(NSArray*)cityGroups;


//给定服务器返回的result 返回解析的订单模型对象组成的数组
+(NSArray*)dealsFromResult:(id)result;


@end

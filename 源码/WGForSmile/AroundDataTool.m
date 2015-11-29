//
//  AroundDataTool.m
//  WGForSmile
//
//  Created by tarena on 15/11/16.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "AroundDataTool.h"
#import "City.h"
#import "Region.h"
#import "CityGroup.h"
#import "Deal.h"
@implementation AroundDataTool


//返回一个个城市对象
static NSArray* _citiesArray=nil;
+(NSArray*)cities
{
    if (!_citiesArray) {
        _citiesArray=[[self alloc]getCitiesDataFromPlist:@"cities.plist"];
    }
    return _citiesArray;
}
-(NSArray*)getCitiesDataFromPlist:(NSString*)plistFileName
{
    NSString* plistPath=[[NSBundle mainBundle]pathForResource:plistFileName ofType:nil];
    NSMutableArray* citiesMutableArray=[NSMutableArray new];
    NSArray* citiesArray=[NSArray arrayWithContentsOfFile:plistPath];
    for (NSDictionary* cityDic in citiesArray) {
        City* city=[City new];
        [city setValuesForKeysWithDictionary:cityDic];
        [citiesMutableArray addObject:city];
    }
    return [citiesMutableArray copy];
}


+(NSArray *)regionsByCity:(NSString *)cityName
{
    if (cityName==nil) {
        return nil;
    }
    NSArray* allCities=[self cities];
    NSArray* regions=[NSArray new];
    for (City* findCity in allCities) {
        if ([findCity.name isEqualToString:cityName]) {
            regions=findCity.regions;
            break;
        }
    }
    NSMutableArray* regionsMutableArray=[NSMutableArray new];
    for (NSDictionary* regionDic in regions) {
        Region* region=[Region new];
        [region setValuesForKeysWithDictionary:regionDic];
        [regionsMutableArray addObject:region];
    }
    return [regionsMutableArray copy];
    
}

static NSArray * _cityGroupsArray=nil;
+(NSArray *)cityGroups
{
    if (!_cityGroupsArray) {
        _cityGroupsArray=[[self alloc]getCityGroupsDataFromPlist:@"cityGroups.plist"];
    }
    return _cityGroupsArray;
}
-(NSArray*)getCityGroupsDataFromPlist:(NSString*)plistName
{
    NSString* plistPath=[[NSBundle mainBundle]pathForResource:plistName ofType:nil];
    NSArray* cityGroupsArray=[NSArray arrayWithContentsOfFile:plistPath];
    NSMutableArray* cityGroupsMutableArray=[NSMutableArray new];
    for (NSDictionary* cityGroupDic in cityGroupsArray) {
        CityGroup* cityGroup=[CityGroup new];
        [cityGroup setValuesForKeysWithDictionary:cityGroupDic];
        [cityGroupsMutableArray addObject:cityGroup];
    }
    return [cityGroupsMutableArray copy];
}

//解析订单
+(NSArray *)dealsFromResult:(id)result
{
    NSArray* dealsArray=result[@"deals"];
    NSMutableArray* dealsMutableArray=[NSMutableArray new];
    for (NSDictionary* dealDic in dealsArray) {
        Deal* deal=[Deal new];
        [deal setValuesForKeysWithDictionary:dealDic];
        [dealsMutableArray addObject:deal];
    }
    return [dealsMutableArray copy];
    
}


@end

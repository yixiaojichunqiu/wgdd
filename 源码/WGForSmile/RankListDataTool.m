//
//  RankListDataTool.m
//  WGForSmile
//
//  Created by tarena on 15/11/18.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "RankListDataTool.h"
#import "RankList.h"
@implementation RankListDataTool

+(NSArray *)rankListFromResult:(id)result
{
    //解析result结果
    NSArray* rankListArray=result[@"results"];
    //对newsarray进行解析
    NSMutableArray* rankListMutableArray=[NSMutableArray array];
    for (NSDictionary* rankListDic in rankListArray) {
        RankList* rankList=[RankList new];
        rankList.trackName=rankListDic[@"trackName"];
        rankList.artworkUrl60=rankListDic[@"artworkUrl60"];
        //[rankList setValuesForKeysWithDictionary:rankListDic];
        [rankListMutableArray addObject:rankList];
    }
    return [rankListMutableArray copy];
    
}


@end

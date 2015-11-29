//
//  HomeNews.m
//  WGForSmile
//
//  Created by tarena on 15/11/10.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "HomeNews.h"

@implementation HomeNews

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"description"]) {
        self.descript=value;
    }
}


@end

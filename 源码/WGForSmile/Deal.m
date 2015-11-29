//
//  Deal.m
//  WGForSmile
//
//  Created by tarena on 15/11/18.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "Deal.h"

@implementation Deal

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //手动指定绑定规则
    //key是字典中对应的key
    if ([key isEqualToString:@"description"]) {
        self.descript=value;
    }
}



@end

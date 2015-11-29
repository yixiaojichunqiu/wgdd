//
//  TicklerManager.m
//  WGForSmile
//
//  Created by tarena on 15/11/9.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TicklerManager.h"
#import "Tickler.h"
@implementation TicklerManager



+(NSArray *)contacts
{
    NSString* plistPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject]stringByAppendingPathComponent:@"tickler.plist"];
    NSArray *contactarray=[NSArray arrayWithContentsOfFile:plistPath];
    //建一个可变数组，里面准备放trcontact对象类型的联系人信息
    NSMutableArray *contactreturnarry=[NSMutableArray new];
    //for循环
    for (int i=0; i<contactarray.count; i++) {
        Tickler *c=[Tickler new];
        c.tickler=contactarray[i];
        //把该对象加入数组
        [contactreturnarry addObject:c];
    }
    //把可变数组变为不可变的返回
    return [NSArray arrayWithArray:contactreturnarry];
}

+(void)refreshTickler:(NSMutableArray *)refresharray
{
    NSString* plistPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject]stringByAppendingPathComponent:@"tickler.plist"];
    NSMutableArray* saveArray=[NSMutableArray array];
    for (Tickler* t in refresharray) {
        NSString* tstr=t.tickler;
        [saveArray addObject:tstr];
    }
    [saveArray writeToFile:plistPath atomically:YES];
    
}





@end

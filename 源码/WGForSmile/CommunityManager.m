//
//  CommunityManager.m
//  WGForSmile
//
//  Created by tarena on 15/11/14.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "CommunityManager.h"
#import "Community.h"
@implementation CommunityManager


+(NSArray *)analysisBmobObjects:(NSArray *)BmobObjectsArray
{
    NSMutableArray* mutableArray=[NSMutableArray new];
    for (BmobObject* obj in BmobObjectsArray) {
        Community* community=[Community new];
        community.title=[obj objectForKey:@"title"];
        community.content=[obj objectForKey:@"content"];
        community.imagename=[obj objectForKey:@"backimagename"];
        community.whoSend=[obj objectForKey:@"whoSend"];
        community.support=[obj objectForKey:@"support"];
        community.against=[obj objectForKey:@"against"];
        community.imagefile=[obj objectForKey:@"imagefile"];
        BmobFile* file=[obj objectForKey:@"imagefile"];
        NSString* url=file.url;
        NSString* imageurl=[NSString stringWithFormat:@"%@",url];
        community.imageUrl=imageurl;
        [mutableArray insertObject:community atIndex:0];
    }
    return [mutableArray copy];
}

@end

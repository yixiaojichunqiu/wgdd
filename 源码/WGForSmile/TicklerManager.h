//
//  TicklerManager.h
//  WGForSmile
//
//  Created by tarena on 15/11/9.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TicklerManager : NSObject

@property (nonatomic,copy) NSString* tickler;

+(NSArray*)contacts;
+(void)refreshTickler:(NSMutableArray*)refresharray;

@end

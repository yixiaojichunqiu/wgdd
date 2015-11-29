//
//  Card.h
//  uiday0405
//
//  Created by tarena on 15/9/9.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject
@property (nonatomic,strong) NSString *suit;
@property (nonatomic,getter=isMatched) BOOL matched;
@property (nonatomic,getter=isseleted) BOOL selected;

-(id)initWithSuit:(NSString*)suit ;
+(NSArray*)allSuit;
@end

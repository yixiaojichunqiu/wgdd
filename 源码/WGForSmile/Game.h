//
//  Game.h
//  uiday0405
//
//  Created by tarena on 15/9/9.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
@interface Game : NSObject
@property (nonatomic,strong) NSMutableArray* randomCards;
@property int score;
-(id)initWithCardCount:(NSUInteger)count;
-(void)tapCardAtIndex:(NSUInteger)index;
@end

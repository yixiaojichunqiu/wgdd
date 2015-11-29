//
//  Card.m
//  uiday0405
//
//  Created by tarena on 15/9/9.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "Card.h"

@implementation Card
-(id)initWithSuit:(NSString*)suit //andRank:(NSString*)rank
{
    if (self=[super init]) {
        self.suit=suit;
        self.selected=NO;
        self.matched=NO;
    }
    return self;
}
+(NSArray*)allSuit
{
    return @[@"♥️",@"♠️",@"🐎",@"🐘",@"🐶",@"🐱",@"🐷",@"🐯",@"💩",@"♦️",@"♣️",@"🐂",@"🐑",@"🌞",@"🌹",@"🌲",@"🐭",@"🐰",@"🐲",@"🐍",@"🐔",@"🔋",@"🔧",@"💒",@"✈️",@"⛪️",@"🚄",@"🚗",@"🚚",@"📱",@"⌚️",@"🌍",@"🎢",@"🌛",@"🐟",@"🐒",@"🐦",@"9⃣️",@"🎸",@"🎹",@"🎻"];
}
-(void)setSuit:(NSString *)suit
{
    if ([[Card allSuit]containsObject:suit]) {
        _suit=suit;
    }
}

@end

//
//  Game.m
//  uiday0405
//
//  Created by tarena on 15/9/9.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "Game.h"

@implementation Game
-(NSMutableArray *)randomCards
{
    if (!_randomCards) {
        _randomCards=[NSMutableArray array];
    }
    return _randomCards;
}
-(id)initWithCardCount:(NSUInteger)count
{
    if (self=[super init]) {
        for (int i=0; i<count/2; i++) {
            unsigned int index=arc4random()%[Card allSuit].count;
            Card *card1=[[Card alloc]initWithSuit:[[Card allSuit] objectAtIndex:index]];
            Card *card2=[[Card alloc]initWithSuit:[[Card allSuit] objectAtIndex:index]];
            [self.randomCards addObject:card1];
            [self.randomCards addObject:card2];
        }
        for (int i=0; i<count; i++) {
            int x=rand()%(count-i)+i;
            [self.randomCards exchangeObjectAtIndex:i withObjectAtIndex:x];
            //数组乱序
        }
    }
    return self;
}
-(void)tapCardAtIndex:(NSUInteger)index
{
    Card* chooseCard=self.randomCards[index];
    if (chooseCard.selected) {
        chooseCard.selected=NO;
    }
    else
    {
        chooseCard.selected=YES;
        for (NSUInteger i=0; i<self.randomCards.count; i++) {
            if (i!=index) {
                Card* otherCard=self.randomCards[i];
                if (otherCard.isseleted&&!otherCard.matched) {
                    if ([otherCard.suit isEqualToString:chooseCard.suit]) {
                        chooseCard.matched=YES;
                        otherCard.matched=YES;
                        self.score=self.score+1;
                    }
                    else{
                        otherCard.selected=NO;
                    }
                }
            }
        }
    }
}
@end

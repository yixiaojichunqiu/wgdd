//
//  DiscoveryCollectionViewCell.m
//  WGForSmile
//
//  Created by tarena on 15/11/18.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "DiscoveryCollectionViewCell.h"

@implementation DiscoveryCollectionViewCell


-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        CGRect frame=self.bounds;
        frame.origin.y=frame.size.height-40;
        frame.size.height=40;
        self.label=[[UILabel alloc]init];
        self.label.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        self.label.font=[UIFont systemFontOfSize:12];
        self.label.numberOfLines=2;
        self.label.textAlignment=NSTextAlignmentCenter;
        self.label.frame=frame;
        [self.contentView addSubview:self.label];
        
        self.imageView=[UIImageView new];
        //[imageview sd_setImageWithURL:[NSURL URLWithString:rankList.artworkUrl512] placeholderImage:[UIImage imageNamed:@"elephant"]];
        CGRect rect=self.bounds;
        rect.origin.x=20;
        rect.size.width-=40;
        rect.size.height-=40;
        self.imageView.frame=rect;
        [self.contentView addSubview:self.imageView];
        
        
        
    }
    return self;
}



@end

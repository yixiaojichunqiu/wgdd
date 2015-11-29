//
//  PersonalPageCollectionViewCell.m
//  WGForSmile
//
//  Created by tarena on 15/11/19.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PersonalPageCollectionViewCell.h"

@implementation PersonalPageCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 50, 48, 16)];
        label.font=[UIFont systemFontOfSize:11];
        self.label=label;
        [self.contentView addSubview:label];
        UIImageView *imageview=[[UIImageView alloc]init];
        imageview.frame=CGRectMake(12, 12, 40, 40);
        self.imageView=imageview;
        [self.contentView addSubview:imageview];
        
    }
    return self;
}





@end

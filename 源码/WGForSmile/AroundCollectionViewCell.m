//
//  AroundCollectionViewCell.m
//  WGForSmile
//
//  Created by tarena on 15/11/17.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "AroundCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

@interface AroundCollectionViewCell ()

@property (nonatomic,strong) UIImageView * imageView;
@property (nonatomic,strong) UILabel * label;
@property (nonatomic,strong) UILabel * descriptionLabel;
@property (nonatomic,strong) UILabel * currentPriceLabel;

@end


@implementation AroundCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        //self.backgroundColor=[UIColor whiteColor];
        
        self.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_dealcell"]];
        
        UIImageView* imageView=[UIImageView new];
        self.imageView=imageView;
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(8);
            make.top.equalTo(self).with.offset(8);
            make.right.equalTo(self).with.offset(-8);
            make.height.mas_equalTo(@150);
        }];
        UILabel* label=[UILabel new];
        label.backgroundColor=[UIColor whiteColor];
        self.label=label;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(8);
            make.top.equalTo(imageView.mas_bottom).with.offset(0);
            make.right.equalTo(self).with.offset(-8);
            make.height.mas_equalTo(@20);
        }];
        UILabel* descriptionLabel=[UILabel new];
        descriptionLabel.backgroundColor=[UIColor whiteColor];
        self.descriptionLabel=descriptionLabel;
        descriptionLabel.font=[UIFont systemFontOfSize:11];
        descriptionLabel.numberOfLines=3;
        [self addSubview:descriptionLabel];
        [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(8);
            make.top.equalTo(label.mas_bottom).with.offset(0);
            make.right.equalTo(self).with.offset(-8);
            make.height.mas_equalTo(@40);
        }];
        UILabel* currentPriceLabel=[UILabel new];
        currentPriceLabel.backgroundColor=[UIColor whiteColor];
        self.currentPriceLabel=currentPriceLabel;
        currentPriceLabel.textColor=[UIColor redColor];
        [self addSubview:currentPriceLabel];
        [currentPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(8);
            make.bottom.equalTo(self).with.offset(-8);
            make.top.equalTo(descriptionLabel.mas_bottom).with.offset(0);
            make.width.mas_equalTo(@40);
        }];
        UIView* view=[UIView new];
        view.backgroundColor=[UIColor whiteColor];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(currentPriceLabel.mas_right).with.offset(0);
            make.bottom.equalTo(self).with.offset(-8);
            make.top.equalTo(descriptionLabel.mas_bottom).with.offset(0);
            make.right.equalTo(self).with.offset(-8);
        }];

        
        
        
    }
    return self;
}


//重写deal set方法

-(void)setDeal:(Deal *)deal
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:deal.image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    self.label.text=deal.title;
    self.descriptionLabel.text=deal.descript;
    self.currentPriceLabel.text=[NSString stringWithFormat:@"¥%@",deal.current_price];
}


@end

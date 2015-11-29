//
//  NavLeftView.m
//  WGForSmile
//
//  Created by tarena on 15/11/15.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "NavLeftView.h"
#import "Masonry.h"
@implementation NavLeftView


-(instancetype)init
{
    if (self=[super init]) {
        self.frame=CGRectMake(0, 0, 100, 30);
        [self awake];
    }
    return self;
}

-(void)awake
{
    UIView* lineview=[UIView new];
    lineview.backgroundColor=[UIColor whiteColor];
    [self addSubview:lineview];
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(8);
        make.top.equalTo(self.mas_top).with.offset(3);
        make.bottom.equalTo(self.mas_bottom).with.offset(-3);
        make.width.mas_equalTo(@1);
    }];
    self.titleLabel=[UILabel new];
    self.titleLabel.text=@"城市";
    self.titleLabel.font=[UIFont systemFontOfSize:10];
    self.titleLabel.textColor=[UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineview.mas_right).with.offset(10);
        make.top.equalTo(self.mas_top).with.offset(3);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(@15);
    }];
    
    self.subLabel=[UILabel new];
    self.subLabel.text=@"子区";
    self.subLabel.font=[UIFont systemFontOfSize:8];
    self.subLabel.textColor=[UIColor whiteColor];
    [self addSubview:self.subLabel];
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineview.mas_right).with.offset(10);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(3);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(@10);
    }];
    
    self.imageButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //[self.imageButton setImage:[UIImage imageNamed:@"head4"] forState:UIControlStateHighlighted];
    [self addSubview:self.imageButton];
    [self.imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
}

+(id)customView
{
    return [[NavLeftView alloc]init];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

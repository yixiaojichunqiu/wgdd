//
//  CommunityTableViewCell.m
//  WGForSmile
//
//  Created by tarena on 15/11/14.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "CommunityTableViewCell.h"
#import "Masonry.h"

@interface CommunityTableViewCell ()


@end


@implementation CommunityTableViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
    }
    return self;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel* label=[UILabel new];
        label.text=@"标题";
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(20);
            make.top.equalTo(self).with.offset(10);
            make.width.mas_equalTo(@50);
            make.height.mas_equalTo(@30);
        }];
        
        self.imageview=[UIImageView new];
        [self.contentView addSubview:self.imageview];
        [self.imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-5);
            make.top.equalTo(self).with.offset(10);
            make.width.mas_equalTo(@(thisScreenWidth/2.5));
            make.height.mas_equalTo(@(thisScreenWidth/2.5));
        }];
        
        
        
        self.label=[UILabel new];
        [self.contentView addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.mas_right).with.offset(0);
            make.top.equalTo(self).with.offset(10);
            make.right.equalTo(self.imageview.mas_left).with.offset(-5);
            make.height.mas_equalTo(@30);
        }];
        
        
        UILabel* label2=[UILabel new];
        label2.text=@"内容";
        [self.contentView addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(20);
            make.top.equalTo(label.mas_bottom).with.offset(0);
            make.width.mas_equalTo(@50);
            make.height.mas_equalTo(@30);
        }];
        
        self.content=[UITextView new];
        self.content.multipleTouchEnabled=NO;
        self.content.editable=NO;
        self.content.scrollEnabled=NO;
        self.content.font=[UIFont systemFontOfSize:23];
        //self.content.allowsEditingTextAttributes=NO;
        //self.content.backgroundColor=[UIColor lightGrayColor];
        [self.contentView addSubview:self.content];
        [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(20);
            make.top.equalTo(label2.mas_bottom).with.offset(0);
            make.right.equalTo(self.imageview.mas_left).with.offset(-5);
            make.bottom.equalTo(self).with.offset(-5);
        }];
        
        self.whoSend=[UILabel new];
        self.whoSend.text=@"xiaoming";
        [self.contentView addSubview:self.whoSend];
        [self.whoSend mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(0);
            make.bottom.equalTo(self).with.offset(0);
            make.width.mas_equalTo(@80);
            make.height.mas_equalTo(@40);
        }];
        
    }
    return self;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

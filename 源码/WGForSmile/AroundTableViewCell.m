//
//  AroundTableViewCell.m
//  WGForSmile
//
//  Created by tarena on 15/11/16.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "AroundTableViewCell.h"

@implementation AroundTableViewCell



+(id)cellWithTableView:(UITableView *)tableView withImageName:(NSString *)imageName withHighlightedImageName :(NSString *)hlImageName
{
    //cell重用机制
    //cell的设置
    static NSString* identifier=@"cell";
    AroundTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[AroundTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    cell.selectedBackgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:hlImageName]];
    return cell;
    
}















- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

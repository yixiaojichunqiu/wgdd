//
//  AroundTableViewCell.h
//  WGForSmile
//
//  Created by tarena on 15/11/16.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AroundTableViewCell : UITableViewCell
//给定两个图片的名字和tableview 返回一个已经创建好的tableviewcell

+(id)cellWithTableView:(UITableView*)tableView withImageName:(NSString*)imageName withHighlightedImageName:(NSString*)hlImageName;


@end

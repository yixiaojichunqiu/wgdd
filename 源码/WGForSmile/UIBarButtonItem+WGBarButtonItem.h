//
//  UIBarButtonItem+WGBarButtonItem.h
//  WGForSmile
//
//  Created by tarena on 15/11/16.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (WGBarButtonItem)

//给定四个参数，返回一个已经创建好的uibarbuttonitem

+(UIBarButtonItem* )itemWithImage:(NSString*)imageName withHighlightedImage:(NSString*)hlImageName withTarget:(id)target withAction:(SEL)action;

@end

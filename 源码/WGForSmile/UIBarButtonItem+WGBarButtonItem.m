//
//  UIBarButtonItem+WGBarButtonItem.m
//  WGForSmile
//
//  Created by tarena on 15/11/16.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "UIBarButtonItem+WGBarButtonItem.h"

@implementation UIBarButtonItem (WGBarButtonItem)


+(UIBarButtonItem *)itemWithImage:(NSString *)imageName withHighlightedImage:(NSString *)hlImageName withTarget:(id)target withAction:(SEL)action
{
    UIButton *button=[UIButton new];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:hlImageName] forState:UIControlStateHighlighted];
    button.frame=CGRectMake(0, 0, 25, 25);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}


@end

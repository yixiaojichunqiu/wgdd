//
//  MyButton.m
//  WGForSmile
//
//  Created by tarena on 15/11/10.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    UIBezierPath *path=[UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(40, 0)];
    [path addCurveToPoint:CGPointMake(40, 80) controlPoint1:CGPointMake(0, 20) controlPoint2:CGPointMake(80, 60)];
    path.lineWidth=2;
    [[UIColor redColor]setStroke];
    [path stroke];
    NSString* str=@"进";
    NSDictionary *dict=@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor blackColor]};
    [str drawInRect:CGRectMake(13, 34, 15, 15) withAttributes:dict];
    NSString* str2=@"入";
    NSDictionary *dict2=@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor blackColor]};
    [str2 drawInRect:CGRectMake(55, 34, 15, 15) withAttributes:dict2];
}


@end

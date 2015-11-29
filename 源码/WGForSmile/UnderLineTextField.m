//
//  UnderLineTextField.m
//  textfield
//
//  Created by tarena on 15/11/18.
//  Copyright © 2015年 weiguang. All rights reserved.
//

#import "UnderLineTextField.h"

@implementation UnderLineTextField


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5));
}


@end

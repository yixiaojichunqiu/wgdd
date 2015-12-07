//
//  UIView+extra.m
//  weiguang
//
//  Created by tiankey on 15/12/4.
//  Copyright © 2015年 tiankey. All rights reserved.
//

#import "UIView+extra.h"

@implementation UIView (extra)

#pragma mark --------Setters--------
-(void)setX:(CGFloat)x
{
    CGRect r = self.frame;
    r.origin.x = x;
    self.frame = r;
}

-(void)setY:(CGFloat)y
{
    CGRect r = self.frame;
    r.origin.y = y;
    self.frame = r;
}

-(void)setWidth:(CGFloat)width
{
    CGRect r = self.frame;
    r.size.width = width;
    self.frame = r;
}

-(void)setHeight:(CGFloat)height
{
    CGRect r = self.frame;
    r.size.height = height;
    self.frame = r;
}

-(void)setOrigin:(CGPoint)origin
{
    self.x = origin.x;
    self.y = origin.y;
}

-(void)setSize:(CGSize)size
{
    self.width = size.width;
    self.height = size.height;
}

-(void)setRight:(CGFloat)right
{
    CGRect r = self.frame;
    r.origin.x = right - r.size.width;
    self.frame = r;
}

-(void)setBottom:(CGFloat)bottom
{
    CGRect r = self.frame;
    r.origin.y = bottom - r.size.height;
    self.frame = r;
}

-(void)setCenterX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}

-(void)setCenterY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}

#pragma mark --------Getters--------
-(CGFloat)x
{
    return self.frame.origin.x;
}

-(CGFloat)y
{
    return self.frame.origin.y;
}

-(CGFloat)width
{
    return self.frame.size.width;
}

-(CGFloat)height
{
    return self.frame.size.height;
}

-(CGPoint)origin
{
    return CGPointMake(self.x, self.y);
}

-(CGSize)size
{
    return CGSizeMake(self.width, self.height);
}

-(CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

-(CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

-(CGFloat)centerX
{
    return self.center.x;
}

-(CGFloat)centerY
{
    return self.center.y;
}

@end

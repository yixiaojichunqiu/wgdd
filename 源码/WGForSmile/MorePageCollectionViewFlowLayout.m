//
//  MorePageCollectionViewFlowLayout.m
//  WGForSmile
//
//  Created by tarena on 15/11/12.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "MorePageCollectionViewFlowLayout.h"

@implementation MorePageCollectionViewFlowLayout

- (id)init{
    self = [super init];
    if (self) {
        //配置项的大小
        self.itemSize = CGSizeMake(thisScreenHeight/7.1, thisScreenHeight/7.1);
        //配置滚动方向
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        //配置行间距
        self.minimumLineSpacing = 25;
        //配置项间距
        self.minimumInteritemSpacing = 20;
        //配置分区的外边距 把下边上边的头尾顶开
        self.sectionInset = UIEdgeInsetsMake(30, 5, 30, 5);
        //配置顶距离
        self.headerReferenceSize=CGSizeMake(thisScreenHeight/2.25, thisScreenHeight/2.25);
        //底边
        self.footerReferenceSize=CGSizeMake(50, 50);
    }
    return self;
}

@end

//
//  AroundPageCollectionViewFlowLayout.m
//  WGForSmile
//
//  Created by tarena on 15/11/18.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "AroundPageCollectionViewFlowLayout.h"

@implementation AroundPageCollectionViewFlowLayout

- (id)init{
    self = [super init];
    if (self) {
        //配置项的大小
        self.itemSize = CGSizeMake(255, 255);
        //配置滚动方向
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        //配置行间距
        self.minimumLineSpacing = 25;
        //配置项间距
        self.minimumInteritemSpacing = 20;
        //配置分区的外边距 把下边上边的头尾顶开
        self.sectionInset = UIEdgeInsetsMake(50, 10, 60, 10);
        //配置顶距离
        self.headerReferenceSize=CGSizeMake(50, 50);
        //底边
        self.footerReferenceSize=CGSizeMake(300, 300);
    }
    return self;
}

@end

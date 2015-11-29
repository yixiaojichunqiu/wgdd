//
//  PersonalPageCollectionViewFlowLayout.m
//  WGForSmile
//
//  Created by tarena on 15/10/11.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "PersonalPageCollectionViewFlowLayout.h"

@implementation PersonalPageCollectionViewFlowLayout
- (id)init{
    self = [super init];
    if (self) {
        //配置项的大小
        self.itemSize = CGSizeMake(65, 65);
        //配置滚动方向
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        //配置行间距
        self.minimumLineSpacing = 25;
        //配置项间距
        self.minimumInteritemSpacing = 20;
        //配置分区的外边距 把下边上边的头尾顶开
        self.sectionInset = UIEdgeInsetsMake(50, 10, 92, 10);
        //配置顶距离
        self.headerReferenceSize=CGSizeMake(150, 150);
        //底边
        self.footerReferenceSize=CGSizeMake(300, 300);
    }
    return self;
}

@end

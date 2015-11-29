//
//  NewsMetaDataTool.m
//  WGForSmile
//
//  Created by tarena on 15/11/10.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "NewsMetaDataTool.h"
#import "HomeNews.h"
#import "BooksChapters.h"
@implementation NewsMetaDataTool

+(NSArray *)newsFromResult:(id)result
{
    //解析result结果
    NSArray* newsArray=result[@"newslist"];
    //对newsarray进行解析
    NSMutableArray* newsMutableArray=[NSMutableArray array];
    for (NSDictionary* newsDic in newsArray) {
        HomeNews* news=[HomeNews new];
        [news setValuesForKeysWithDictionary:newsDic];
        [newsMutableArray addObject:news];
    }
    return [newsMutableArray copy];

}

+(NSArray *)booksChapter:(id)result
{
    NSArray* booksChapterArray=result[@"result"];
    NSMutableArray* booksChapterMutableArray=[NSMutableArray array];
    for (NSDictionary* booksChapterDic in booksChapterArray) {
        BooksChapters* booksChapter=[BooksChapters new];
        [booksChapter setValuesForKeysWithDictionary:booksChapterDic];
        [booksChapterMutableArray addObject:booksChapter];
    }
    return [booksChapterMutableArray copy];
}

@end

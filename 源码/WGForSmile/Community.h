//
//  Community.h
//  WGForSmile
//
//  Created by tarena on 15/11/14.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>
@interface Community : NSObject

@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * content;
@property (nonatomic,strong) NSString * imagename;
@property (nonatomic,strong) NSString * whoSend;
@property (nonatomic,strong) NSNumber * support;
@property (nonatomic,strong) NSNumber * against;
@property (nonatomic,strong) BmobFile * imagefile;
@property (nonatomic,strong) NSString * imageUrl;

@end

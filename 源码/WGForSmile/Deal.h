//
//  Deal.h
//  WGForSmile
//
//  Created by tarena on 15/11/18.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Deal : NSObject

//规则1 模型类中声明的对象 和字典类型中key一摸一样
//2关键字 问题

@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * descript;
//规则3 如果有关键字 必须重写方法setvalue 手动指定绑定规则
@property (nonatomic,strong) NSNumber * list_price;
@property (nonatomic,strong) NSNumber * current_price;//优惠后
@property (nonatomic,strong) NSArray * categories;//分类
@property (nonatomic,strong) NSNumber * purchase_count;//购买个数
@property (nonatomic,strong) NSString * image_url;//图片url
@property (nonatomic,strong) NSString * s_image_url;//小图片url
@property (nonatomic,strong) NSString * deal_h5_url;
@property (nonatomic,strong) NSArray * businesses;

@end

//
//  MyFavoriteItem.m
//  PEM
//
//  Created by tianj on 14-9-11.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "MyFavoriteItem.h"

@implementation MyFavoriteItem

- (id)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        _uid = [dic objectForKey:@"id"];
        _title = [dic objectForKey:@"title"];
        _info_id = [dic objectForKey:@"info_id"];
        _img = [dic objectForKey:@"img"];
        _price = [dic objectForKey:@"price"];
        _collectTimes = [dic objectForKey:@"collectTimes"];
    }
    return self;
}

@end

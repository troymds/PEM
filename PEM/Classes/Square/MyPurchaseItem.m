//
//  MyPurchaseItem.m
//  PEM
//
//  Created by tianj on 14-9-10.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "MyPurchaseItem.h"

@implementation MyPurchaseItem

- (id)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        _date = [dic objectForKey:@"date"];
        int uid = [[dic objectForKey:@"id"] intValue];
        _uid = [NSString stringWithFormat:@"%d",uid];
        _introduction = [dic objectForKey:@"introduction"];
        _name = [dic objectForKey:@"name"];
        _read_num = [dic objectForKey:@"read_num"];
        _verify_result = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"verify_result"] intValue]];
    }
    return self;
}

@end

//
//  HotTagItem.m
//  PEM
//
//  Created by tianj on 14-9-4.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "HotTagItem.h"

@implementation HotTagItem

- (id)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        _uid = [dic objectForKey:@"id"];
        _name = [dic objectForKey:@"name"];
    }
    return self;
}


@end

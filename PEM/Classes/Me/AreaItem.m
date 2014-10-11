//
//  AreaItem.m
//  PEM
//
//  Created by tianj on 14-9-24.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "AreaItem.h"

@implementation AreaItem

- (id)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        _uid = [dic objectForKey:@"id"];
        _father_id = [dic objectForKey:@"father_id"];
        _name = [dic objectForKey:@"name"];
    }
    return self;
}

@end

//
//  TagItem.m
//  PEM
//
//  Created by tianj on 14-9-16.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "TagItem.h"

@implementation TagItem

- (id)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        _uid = [dic objectForKey:@"id"];
        _name = [dic objectForKey:@"name"];
        int no_read = [[dic objectForKey:@"no_read"] intValue];
        _no_read = [NSString stringWithFormat:@"%d",no_read];
    }
    return self;
}

@end

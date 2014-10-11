//
//  TagInfoItem.m
//  PEM
//
//  Created by tianj on 14-9-16.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "TagInfoItem.h"

@implementation TagInfoItem

- (id)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        _uid = [dic objectForKey:@"id"];
        _title = [dic objectForKey:@"title"];
        _create_time = [dic objectForKey:@"create_time"];
        int is_read = [[dic objectForKey:@"is_read"] intValue];
        _is_read = [NSString stringWithFormat:@"%d",is_read];
    }
    return self;
}

@end

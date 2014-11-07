//
//  CategoryItem.m
//  PEM
//
//  Created by tianj on 14-9-1.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "CategoryItem.h"

@implementation CategoryItem


- (id)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        _uid = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"id"] intValue]];
        _image = [dic objectForKey:@"image"];
        _name = [dic objectForKey:@"name"];
        _parent_id = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"parent_id"] intValue]];
    }
    return self;
}

@end





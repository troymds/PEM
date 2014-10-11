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
        _uid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        _image = [dic objectForKey:@"image"];
        _name = [dic objectForKey:@"name"];
    }
    return self;
}

@end





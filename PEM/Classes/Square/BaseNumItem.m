//
//  BaseNumItem.m
//  PEM
//
//  Created by tianj on 14-9-11.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "BaseNumItem.h"

@implementation BaseNumItem

- (id)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        _demand = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"demand"] intValue]];
        _supply = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"supply"] intValue]];
        _wishlist = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"wishlist"] intValue]];
        _news = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"news"] intValue]];
    }
    return self;
}

@end

//
//  SupplyItem.m
//  PEM
//
//  Created by tianj on 14-8-25.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "SupplyItem.h"

@implementation SupplyItem


@synthesize description = _description;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"UndefinedKey:%@",key);
}

@end

//
//  SupplyDetailItem.m
//  PEM
//
//  Created by tianj on 14-9-29.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "SupplyDetailItem.h"

@implementation SupplyDetailItem

@synthesize description = _description;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"UndefinedKey:%@",key);
}

@end

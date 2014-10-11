//
//  DemandDetailItem.m
//  PEM
//
//  Created by tianj on 14-9-29.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "DemandDetailItem.h"

@implementation DemandDetailItem

@synthesize description = _description;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"UndefinedKey:%@",key);
}

@end

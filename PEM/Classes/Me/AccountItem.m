//
//  AccountItem.m
//  PEM
//
//  Created by tianj on 14-9-1.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "AccountItem.h"

@implementation AccountItem

- (id)initWithDictionary:(NSDictionary *)dic{
    
    if (self = [super init]) {
        _company_name = [dic objectForKey:@"company_name"];
        _company_id = [dic objectForKey:@"company_id"];
        _viptype = [dic objectForKey:@"viptype"];
        _is_lock = [dic objectForKey:@"is_lock"];
        _website = [dic objectForKey:@"website"];
        _region = [dic objectForKey:@"region"];
        _image = [dic objectForKey:@"image"];
    }
    return self;
}

@end

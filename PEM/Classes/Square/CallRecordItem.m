//
//  CallRecordItem.m
//  PEM
//
//  Created by tianj on 14-9-11.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "CallRecordItem.h"

@implementation CallRecordItem

- (id)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        _call_time = [dic objectForKey:@"call_time"];
        _uid =[NSString stringWithFormat:@"%d",[[dic objectForKey:@"id"] intValue]];
        _info_id = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"info_id"] intValue]];
        _name = [dic objectForKey:@"name"];
        _phone_num = [dic objectForKey:@"phone_num"];
        _type = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"type"] intValue]];
        _contacts = [dic objectForKey:@"contacts"];
    }
    return self;
}

@end

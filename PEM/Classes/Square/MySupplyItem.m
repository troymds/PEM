//
//  MySupplyItem.m
//  PEM
//
//  Created by tianj on 14-9-9.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "MySupplyItem.h"

@implementation MySupplyItem

- (id)initWithDictonary:(NSDictionary *)dic{
    if (self = [super init]) {
        _company = [dic objectForKey:@"company"];
        _company_rank = [dic objectForKey:@"company_rank"];
        _date = [dic objectForKey:@"date"];
        int uid = [[dic objectForKey:@"id"] intValue];
        _uid = [NSString stringWithFormat:@"%d",uid];
        _image = [dic objectForKey:@"image"];
        int min_supply_num = [[dic objectForKey:@"min_supply_num"] intValue];
        _min_supply_num = [NSString stringWithFormat:@"%d",min_supply_num];
        _name = [dic objectForKey:@"name"];
        if (isNull(dic, @"price")) {
            _price = @"0";
        }else{
            _price = [dic objectForKey:@"price"];
        }
        _read_num = [dic objectForKey:@"read_num"];
        _region = [dic objectForKey:@"region"];
        _unit = [dic objectForKey:@"unit"];
        _verify_result = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"verify_result"] intValue]];
    }
    return self;
}

@end

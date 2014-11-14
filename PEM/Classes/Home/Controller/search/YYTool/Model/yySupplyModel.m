//
//  yySupplyModel.m
//  PEM
//
//  Created by YY on 14-9-4.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "yySupplyModel.h"

@implementation yySupplyModel
@synthesize supplyId,company,name,image,read_num,price,min_supply_num;

- (instancetype)initWithDictionaryForSupply:(NSDictionary *)dict
{
    if ([super self])
    {
        if (!isNull(dict, @"id")) {
            self.supplyId = dict[@"id"];
        }else{
            self.supplyId = @"-1";
        }
        if (!isNull(dict, @"image")) {
            self.image = dict[@"image"];
        }else{
            self.image = @"";
        }
        if (!isNull(dict, @"company")) {
            self.company = dict[@"company"];
        }else{
            self.company = @"";
        }
        if (!isNull(dict, @"min_supply_num")) {
            self.min_supply_num=dict[@"min_supply_num"];
        }else{
            self.min_supply_num = @"0";
        }
        if (!isNull(dict, @"read_num")) {
            self.read_num=dict[@"read_num"];
        }else{
            self.read_num = @"0";
        }
        if (!isNull(dict, @"price")) {
            self.price=dict[@"price"];
        }else{
            self.price = @"0";
        }
        if (!isNull(dict, @"name")) {
            self.name=dict[@"name"];
        }else{
            self.name = @"";
        }

        
    }
    
    return self;
}

@end

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

        self.supplyId = dict[@"id"];
        self.image = dict[@"image"];
        self.company = dict[@"company"];
        self.min_supply_num=dict[@"min_supply_num"];
        self.read_num=dict[@"read_num"];
        self.price=dict[@"price"];

        self.name=dict[@"name"];

        
    }
    
    return self;
}

@end

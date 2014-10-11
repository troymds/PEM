//
//  TodayNumModel.m
//  PEM
//
//  Created by house365 on 14-9-4.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "TodayNumModel.h"

@implementation TodayNumModel
@synthesize demandNum,callNum,supplyNum;

- (instancetype)initWithTodayNumDictionary:(NSDictionary *)dict
{
    if ([super self])
    {
        self.callNum = dict[@"call_num"];
        self.demandNum = dict[@"demand_num"];
        self.supplyNum = dict[@"supply_num"];
    }

    return self;
}

@end

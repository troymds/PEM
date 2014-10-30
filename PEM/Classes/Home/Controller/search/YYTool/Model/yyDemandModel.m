//
//  yyDemandModel.m
//  PEM
//
//  Created by YY on 14-9-4.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "yyDemandModel.h"

@implementation yyDemandModel
@synthesize demandid,name,read_num,Introduction,demandDate,buy_num;

- (instancetype)initWithDictionaryFordemand:(NSDictionary *)dict
{
    if ([super self])
    {
        self.demandid = dict[@"id"];
        self.demandDate = dict[@"date"];
        self.read_num=dict[@"read_num"];
        NSLog(@"self.read_num----%@",self.read_num);
        self.buy_num=dict[@"buy_num"];
        self.Introduction=dict[@"introduction"];
        
        self.name=dict[@"name"];
        
    }
    
    return self;
}

@end

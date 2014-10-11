//
//  demandCOM.m
//  PEM
//
//  Created by YY on 14-9-20.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "demandCOM.h"

@implementation demandCOM
@synthesize date,companyID,name,read_num,introduction,buy_num;
- (id)initWithDictonary:(NSDictionary *)dic{
    if (self = [super init]) {
        self.companyID =dic[@"id"];
        self. date = [dic objectForKey:@"date"];
        self. name = [dic objectForKey:@"name"];
        self.read_num = [dic objectForKey:@"read_num"];
        self. introduction = [dic objectForKey:@"introduction"];
        self.buy_num =dic [@"buy_num"];
    }
    return self;
}

@end

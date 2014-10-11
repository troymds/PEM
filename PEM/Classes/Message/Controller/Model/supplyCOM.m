//
//  supplyCOM.m
//  PEM
//
//  Created by YY on 14-9-20.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "supplyCOM.h"

@implementation supplyCOM
@synthesize company,company_rank,date,uid,image,min_supply_num,name,price,read_num,region;
- (id)initWithDictonary:(NSDictionary *)dic{
    if (self = [super init]) {
        self.uid =dic[@"id"];
       self. company = [dic objectForKey:@"company"];
       self. company_rank = [dic objectForKey:@"company_rank"];
       self. date = [dic objectForKey:@"date"];
       self. min_supply_num =dic[@"min_supply_num"];
      self.  image = [dic objectForKey:@"image"];
       self. name = [dic objectForKey:@"name"];
       self. price = [dic objectForKey:@"price"];
        self.read_num = [dic objectForKey:@"read_num"];
       self. region = [dic objectForKey:@"region"];
    }
    return self;
}

@end

//
//  yyCompanyModel.m
//  PEM
//
//  Created by YY on 14-9-4.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "yyCompanyModel.h"

@implementation yyCompanyModel
@synthesize companyid,name,image,business,rank,region;

- (instancetype)initWithDictionaryForCompany:(NSDictionary *)dict
{
    if ([super self])
    {
        self.companyid = dict[@"id"];
        self.image = dict[@"image"];
        self.region = dict[@"region"];
        self.business=dict[@"business"];
        self.rank=dict[@"rank"];
        
        self.name=dict[@"name"];
        
        
    }
    
    return self;
}

@end

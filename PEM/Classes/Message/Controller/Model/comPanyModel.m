//
//  comPanyModel.m
//  PEM
//
//  Created by YY on 14-9-19.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "comPanyModel.h"

@implementation comPanyModel
@synthesize comid,name,time,type;
- (instancetype)initWithDictionaryForComapnyBtn:(NSDictionary *)dic{
    if ([super self])
    {
        
        
        self.name = dic[@"name"];
        self.comid = dic[@"id"];
        self.time = dic[@"time"];
        
        self.type = dic[@"type"];
        
        
        
    }
    
    return self;

}

@end

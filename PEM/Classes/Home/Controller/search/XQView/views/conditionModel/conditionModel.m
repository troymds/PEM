//
//  conditionModel.m
//  PEM
//
//  Created by YY on 14-9-11.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "conditionModel.h"

@implementation conditionModel
@synthesize typeId,viptype,comdionId,company,name,image,introduction,region,website,time,tel,type ;

- (instancetype)initWithDictionaryForCondition:(NSDictionary *)dict
{
    if ([super self])
    {
       
        self.image = dict[@"image"];
        self.company = dict[@"company"];
        self.region=dict[@"region"];
        self.viptype=dict[@"viptype"];
        self.website=dict[@"website"];
        self.tel = dict[@"tel"];
        self.introduction = dict[@"introduction"];
        self.type=dict[@"type"];
        self.name=dict[@"name"];
        self.typeId=dict[@"id"];
        self.time=dict[@"time"];

        
        
    }
    
    return self;
}


@end

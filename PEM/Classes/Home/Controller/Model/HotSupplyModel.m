//
//  HotSupplyModel.m
//  PEM
//
//  Created by YY on 14-9-4.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "HotSupplyModel.h"

@implementation HotSupplyModel
@synthesize supplyhotID,image,title,sub_title,supplytype;

- (instancetype)initWithDictionaryForHotSupply:(NSDictionary *)dict
{
    if ([super self])
    {
        self.supplyhotID = dict[@"id"];
        self.image = dict[@"image"];
        self.title = dict[@"title"];

        self.sub_title=dict[@"sub_title"];
        self.supplytype=dict[@"type"];

    }
    
    return self;
}
@end

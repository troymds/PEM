//
//  HotDemandModel.m
//  PEM
//
//  Created by YY on 14-9-4.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "HotDemandModel.h"

@implementation HotDemandModel
@synthesize demandHotid,image,title,sub_title;

- (instancetype)initWithDictionaryForHotDeman:(NSDictionary *)dict
{
    if ([super self])
    {
        self.demandHotid = dict[@"id"];
        self.image = dict[@"image"];
        self.title = dict[@"title"];
        self.sub_title=dict[@"sub_title"];
    }
    
    return self;
}

@end

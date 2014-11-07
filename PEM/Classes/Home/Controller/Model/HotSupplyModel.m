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

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.supplyhotID forKey:@"id"];
    [coder encodeObject:self.image forKey:@"image"];
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.sub_title forKey:@"sub_title"];
    [coder encodeObject:self.supplytype forKey:@"supplytype"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.supplyhotID =  [coder decodeObjectForKey:@"id"];
        self.image =  [coder decodeObjectForKey:@"image"];
        self.title =  [coder decodeObjectForKey:@"title"];
        self.sub_title =  [coder decodeObjectForKey:@"sub_title"];
        self.supplytype =  [coder decodeObjectForKey:@"supplytype"];
    }
    return self;
}

@end

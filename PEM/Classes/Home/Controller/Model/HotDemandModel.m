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

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.demandHotid forKey:@"id"];
    [coder encodeObject:self.image forKey:@"image"];
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.sub_title forKey:@"sub_title"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.demandHotid =  [coder decodeObjectForKey:@"id"];
        self.image =  [coder decodeObjectForKey:@"image"];
        self.title =  [coder decodeObjectForKey:@"title"];
        self.sub_title =  [coder decodeObjectForKey:@"sub_title"];
    }
    return self;
}


@end

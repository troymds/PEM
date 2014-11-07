//
//  HotCategoryModel.m
//  PEM
//
//  Created by house365 on 14-9-3.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "HotCategoryModel.h"

@implementation HotCategoryModel
@synthesize cateid,image,name;

- (instancetype)initWithDictionaryForHotCate:(NSDictionary *)dict
{
    if ([super self])
    {
        self.cateid = dict[@"id"];
        self.image = dict[@"image"];
        self.name = dict[@"name"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.cateid forKey:@"id"];
    [coder encodeObject:self.image forKey:@"image"];
    [coder encodeObject:self.name forKey:@"name"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.cateid =  [coder decodeObjectForKey:@"id"];
        self.image =  [coder decodeObjectForKey:@"image"];
        self.name =  [coder decodeObjectForKey:@"name"];
    }
    return self;
}


@end

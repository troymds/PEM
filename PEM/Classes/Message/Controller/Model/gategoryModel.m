//
//  gategoryModel.m
//  PEM
//
//  Created by YY on 14-9-12.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "gategoryModel.h"

@implementation gategoryModel
@synthesize nameGategory,imageGategpry,idType;
- (instancetype)initWithDictionaryForGategory:(NSDictionary *)dict{
    if ([super self])
    {

        self.idType = dict[@"id"];
        self.imageGategpry = dict[@"image"];
        self.nameGategory = dict[@"name"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.idType forKey:@"_idType"];
    [coder encodeObject:self.imageGategpry forKey:@"_imageGategpry"];
    [coder encodeObject:self.nameGategory forKey:@"_nameGategory"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.idType =  [coder decodeObjectForKey:@"_idType"];
        self.imageGategpry =  [coder decodeObjectForKey:@"_imageGategpry"];
        self.nameGategory =  [coder decodeObjectForKey:@"_nameGategory"];
    }
    return self;
}


@end

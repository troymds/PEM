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

        self.idType = [NSString stringWithFormat:@"%d",[dict[@"id"] intValue]];
        self.imageGategpry = dict[@"image"];
        self.nameGategory = dict[@"name"];
        self.parent_id = [NSString stringWithFormat:@"%d",[dict[@"parent_id" ] intValue]];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.idType forKey:@"_idType"];
    [coder encodeObject:self.imageGategpry forKey:@"_imageGategpry"];
    [coder encodeObject:self.nameGategory forKey:@"_nameGategory"];
    [coder encodeObject:self.parent_id forKey:@"_parent_id"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.idType =  [coder decodeObjectForKey:@"_idType"];
        self.imageGategpry =  [coder decodeObjectForKey:@"_imageGategpry"];
        self.nameGategory =  [coder decodeObjectForKey:@"_nameGategory"];
        self.parent_id = [coder decodeObjectForKey:@"_parent_id"];
    }
    return self;
}


@end

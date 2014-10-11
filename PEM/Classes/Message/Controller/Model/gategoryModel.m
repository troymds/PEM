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

@end

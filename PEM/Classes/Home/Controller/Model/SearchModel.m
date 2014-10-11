//
//  SearchResultModel.m
//  PEM
//
//  Created by house365 on 14-9-22.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "SearchModel.h"

@implementation SearchModel
@synthesize resultId = _resultId,name = _name;

- (id)initDictionary:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.resultId = dict[@"id"];
        self.name = dict[@"name"];
    }
    return self;
}

@end

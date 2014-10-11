//
//  SearchResultModel.m
//  PEM
//
//  Created by house365 on 14-8-30.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "SearchResultModel.h"

@implementation SearchResultModel

@synthesize searchKeyword = _searchKeyword;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.searchKeyword forKey:@"keyword"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [aDecoder decodeObjectForKey:@"keyword"];
}


@end

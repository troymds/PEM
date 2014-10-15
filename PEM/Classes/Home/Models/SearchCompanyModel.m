//
//  SearchCompanyModel.m
//  PEM
//
//  Created by YY on 14-10-15.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "SearchCompanyModel.h"

@implementation SearchCompanyModel
@synthesize searchKeyword=_searchKeyword ;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.searchKeyword forKey:@"keyword"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [aDecoder decodeObjectForKey:@"keyword"];
}

@end

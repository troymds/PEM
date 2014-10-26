//
//  supplyWishlistidModel.m
//  PEM
//
//  Created by YY on 14-9-30.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "supplyWishlistidModel.h"

@implementation supplyWishlistidModel
@synthesize code;
- (id)initWithDictonary:(NSDictionary *)dic{
    if (self = [super init]) {
        
        self.code =[NSString stringWithFormat:@"%d",[dic[@"code"] intValue]];
        
        if ([dic objectForKey:@"data"]) {
            if (!isNull([dic objectForKey:@"data"], @"wishlistid")) {
                _wishlistId = [[dic objectForKey:@"data"] objectForKey:@"wishlistid"];
            }
        }
    }
    return self;
}

@end

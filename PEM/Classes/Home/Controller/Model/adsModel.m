//
//  adsModel.m
//  PEM
//
//  Created by YY on 14-9-4.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "adsModel.h"

@implementation adsModel
@synthesize idType,srcImage,adsid;
-(instancetype)initWithDictionaryForAds:(NSDictionary *)dict{
    if ([super self]) {
        self.idType =dict[@"type"];
        self.srcImage =dict[@"src"];
        self.adsid =dict[@"content"];

    }
    return self;
}

@end

//
//  comHomeModel.m
//  PEM
//
//  Created by YY on 14-9-20.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "comHomeModel.h"

@implementation comHomeModel
@synthesize addr,image,infoarray,introduction,mainRun,name,tel,website,viptype,e_url;

- (instancetype)initWithDictionaryForComapny:(NSDictionary *)dic{
    
    if ([super self])
    {
        
        self.addr = dic[@"addr"];
        
        self.image = dic[@"image"];
        self.introduction = dic[@"introduction"];
        
        self.mainRun = dic[@"mainRun"];
        
        self.name = dic[@"name"];
        self.name = [self.name stringByReplacingOccurrencesOfString:@" " withString:@""];
        self.tel = dic[@"tel"];
        self.viptype = dic[@"vip_type"];
        
        self.website = dic[@"website"];
        self.infoarray = dic[@"infoarray"];
        self.e_url = dic[@"e_url"];

        
        
        
    }
    
    return self;
    
    
}

@end



//
//  comContent.m
//  PEM
//
//  Created by YY on 14-9-19.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "comContent.h"

@implementation comContent

@synthesize comid,title,create_time,description;

- (instancetype)initWithDictionaryForComapny:(NSDictionary *)dic{
    
    if ([super self])
    {
        
              self.title = dic[@"title"];
               self.comid = dic[@"id"];
                self.create_time = dic[@"create_time"];
        
               self.description = dic[@"description"];
  
        
    }
    
    return self;
    
    
}



@end

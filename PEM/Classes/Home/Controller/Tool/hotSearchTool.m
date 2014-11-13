//
//  hotSearchTool.m
//  PEM
//
//  Created by YY on 14-11-12.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "hotSearchTool.h"
#import "HttpTool.h"

@implementation hotSearchTool
+ (void)statusesWithSuccess:(StatusSuccessBlock)success  failure:(StatusFailureBlock)failure{
    
    [HttpTool postWithPath:@"getHotSearchKeywords" params:nil success:^(id JSON) {
        NSDictionary *d =[NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        
        NSMutableArray *statuses =[NSMutableArray array];
        NSDictionary *array =d[@"response"];
        if (![array isKindOfClass:[NSNull class]]) {
            [statuses addObject:[array objectForKey:@"data"]];
        }
        else{
            
        }
        success(statuses);
    } failure:^(NSError *error) {
        
    }];
}

@end

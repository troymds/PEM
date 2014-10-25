//
//  gategoryListTool.m
//  PEM
//
//  Created by YY on 14-9-12.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "gategoryListTool.h"
#import "HttpTool.h"
#import "gategoryModel.h"
@implementation gategoryListTool
+ (void)statusesWithSuccess:(StatusSuccessBlock)success failure:(StatusFailureBlock)failure
{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"15",@"pagesize",@"0",@"lastid", nil];
    [HttpTool postWithPath:@"getCategoryList" params:dic success:^(id JSON) {
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        
        NSMutableArray *statuses =[NSMutableArray array];
        
        NSDictionary *array =d[@"response"];
        if (array) {
            for (NSDictionary *dict in array) {
                gategoryModel *s =[[gategoryModel alloc] initWithDictionaryForGategory:dict];
                
                [statuses addObject:s];
                
            }
            success(statuses);
        }
       
    } failure:^(NSError *error) {
        if (failure==nil)return ; {
            failure(error);
        }
    }];
    
    
}

@end

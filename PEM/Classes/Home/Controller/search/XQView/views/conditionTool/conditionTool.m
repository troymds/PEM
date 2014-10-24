//
//  conditionTool.m
//  PEM
//
//  Created by YY on 14-9-11.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "conditionTool.h"
#import "HttpTool.h"
#import "conditionModel.h"
@implementation conditionTool
+ (void)statusesWithSuccess:(StatusSuccessBlock)success failure:(StatusFailureBlock)failure
{
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"15",@"pagesize",0,@"company_id", nil];
    [HttpTool postWithPath:@"getCompanyDetail" params:dic success:^(id JSON) {
//        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
//        NSMutableArray *statuses =[NSMutableArray array];
//        
//        NSDictionary *array =d[@"response"];
//        for (NSDictionary *dict in array) {
//            conditionModel *s =[[conditionModel alloc] initWithDictionaryForSupply:dict];
//            
//            [statuses addObject:s];
//        }
//        success(statuses);
        
    } failure:^(NSError *error) {
        if (failure==nil)return ; {
            failure(error);
        }
    }];
}

@end

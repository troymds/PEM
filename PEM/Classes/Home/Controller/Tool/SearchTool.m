//
//  SearchTool.m
//  PEM
//
//  Created by house365 on 14-9-22.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "SearchTool.h"
#import "HttpTool.h"
#import "yyDemandModel.h"
#import "yySupplyModel.h"
#import "yyCompanyModel.h"

@implementation SearchTool

+ (void)searchWithSuccessBlock:(SearchSuccessBlock)success  withKeywords:(NSString *)keywords lastID:(NSString *)lastid failureBlock:(SearchFailureBlock)failure
{
    
    
    NSDictionary *dicid = [NSDictionary dictionaryWithObjectsAndKeys:keywords,@"keywords", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicid options:NSJSONWritingPrettyPrinted error:nil];
    NSString *condition = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"10",@"pagesize",lastid,@"lastid",condition,@"condition", nil];
    
    [HttpTool postWithPath:@"getCompanyList" params:dic success:^(id JSON) {
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        
        NSMutableArray *statuses =[NSMutableArray array];
        
        NSDictionary *array =d[@"response"];
        if ([array isKindOfClass:[NSNull class]])
        {
        }else{
        for (NSDictionary *dict in array) {
            yyCompanyModel *s =[[yyCompanyModel alloc] initWithDictionaryForCompany:dict];
            
            [statuses addObject:s];
        }
        }
        success(statuses);

    } failure:^(NSError *error) {
        if (failure==nil)return ; {
            failure(error);
        }
    }];
}
+ (void)searchWithSupplySuccessBlock:(SearchSuccessBlock)success SupplywithKeywords:(NSString *)keywords lastID:(NSString *)lastid SupplyfailureBlock:(SearchFailureBlock)failure{
    
    NSDictionary *dicid = [NSDictionary dictionaryWithObjectsAndKeys:keywords,@"keywords", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicid options:NSJSONWritingPrettyPrinted error:nil];
    NSString *condition = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"10",@"pagesize",lastid,@"lastid",condition,@"condition",@"read_num",@"sort", nil];
    
    [HttpTool postWithPath:@"getSupplyInfoList" params:dic success:^(id JSON) {
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        NSDictionary *array =d[@"response"];
        NSLog(@"-------%@",array);
        if ([array isKindOfClass:[NSNull class]]) {
        }else{
            for (NSDictionary *dict in array) {
                yySupplyModel *s =[[yySupplyModel alloc] initWithDictionaryForSupply:dict];
                [statuses addObject:s];
            }
        }
        success(statuses);
        
    } failure:^(NSError *error) {
        if (failure==nil)return ; {
            failure(error);
        }
    }];

    
}

+ (void)searchWithDemandSuccessBlock:(SearchSuccessBlock)success DemandwithKeywords:(NSString *)keywords lastID:(NSString *)lastid DemandfailureBlock:(SearchFailureBlock)failure{
    NSDictionary *dicid = [NSDictionary dictionaryWithObjectsAndKeys:keywords,@"keywords", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicid options:NSJSONWritingPrettyPrinted error:nil];
    NSString *condition = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"10",@"pagesize",lastid,@"lastid",condition,@"condition",@"time",@"sort", nil];
    [HttpTool postWithPath:@"getDemandInfoList" params:dic success:^(id JSON) {
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        NSDictionary *array =d[@"response"];
        if ([array isKindOfClass:[NSNull class]]){
            
        }else{
            for (NSDictionary *dict in array) {
                yyDemandModel *s =[[yyDemandModel alloc] initWithDictionaryFordemand:dict];
                [statuses addObject:s];
            }
        }
        success(statuses);
    } failure:^(NSError *error) {
        if (failure==nil)return ; {
            failure(error);
        }
    }];


}



@end

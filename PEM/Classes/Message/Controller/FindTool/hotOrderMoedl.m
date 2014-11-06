//
//  hotOrderMoedl.m
//  PEM
//
//  Created by YY on 14-9-23.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "hotOrderMoedl.h"
#import "HttpTool.h"
#import "yySupplyModel.h"
#import "yyDemandModel.h"
@implementation hotOrderMoedl
+(void)CategoryStatusesWithSuccesscategory:(StatusSuccessBlock)success cateId:(NSString *)cateid supplyHot:(NSString *)supply lastID:(NSString *)lastid  CategoryFailure:(StatusFailureBlock)failure{
    NSDictionary *dicid = [NSDictionary dictionaryWithObjectsAndKeys:supply,@"sort",cateid,@"category_id",nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicid options:NSJSONWritingPrettyPrinted error:nil];
    NSString *condition = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"10",@"pagesize",lastid,@"lastid",condition,@"condition", nil];
    [HttpTool postWithPath:@"getSupplyInfoList" params:dic success:^(id JSON) {
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        NSDictionary *array =d[@"response"];
        
        if (array) {
            if (![array isKindOfClass:[NSNull class]]){
                for (NSDictionary *dict in array) {
                    yySupplyModel *s =[[yySupplyModel alloc] initWithDictionaryForSupply:dict];
                    
                    [statuses addObject:s];
                }
            }
        }
        success(statuses);

    } failure:^(NSError *error) {
        if (failure==nil)return ; {
            failure(error);
        }
    }];
    
    
}
+(void)CategoryStatusesWithSuccesscategory:(StatusSuccessBlock)success cateId:(NSString *)cateid demandHot:(NSString *)demand lastID:(NSString *)lastid CategoryFailure:(StatusFailureBlock)failure {
    NSDictionary *dicid = [NSDictionary dictionaryWithObjectsAndKeys:demand,@"sort",cateid,@"category_id",nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicid options:NSJSONWritingPrettyPrinted error:nil];
    NSString *condition = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"10",@"pagesize",lastid,@"lastid",condition,@"condition", nil];
    [HttpTool postWithPath:@"getDemandInfoList" params:dic success:^(id JSON) {
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        NSDictionary *array =d[@"response"];
        if (array) {
            if (![array isKindOfClass:[NSNull class]]){
                for (NSDictionary *dict in array) {
                    yyDemandModel *s =[[yyDemandModel alloc] initWithDictionaryFordemand:dict];
                    
                    [statuses addObject:s];
                }
                
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

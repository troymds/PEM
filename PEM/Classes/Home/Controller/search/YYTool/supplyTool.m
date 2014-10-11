//
//  supplyTool.m
//  PEM
//
//  Created by YY on 14-9-4.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "supplyTool.h"
#import "HttpTool.h"
#import "yySupplyModel.h"
#import "SystemConfig.h"
#import "supplyCOM.h"
@implementation supplyTool
+ (void)statusesWithSuccess:(StatusSuccessBlock)success lastID:(NSString * )lastid failure:(StatusFailureBlock)failure
{

    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"15",@"pagesize",lastid,@"lastid", nil];
    [HttpTool postWithPath:@"getSupplyInfoList" params:dic success:^(id JSON) {
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        NSDictionary *array =d[@"response"];

         for (NSDictionary *dict in array) {
        yySupplyModel *s =[[yySupplyModel alloc] initWithDictionaryForSupply:dict];
        [statuses addObject:s];
         }
               success(statuses);
        
    } failure:^(NSError *error) {
        if (failure==nil)return ; {
            failure(error);
        }
    }];
}
+(void)CategoryStatusesWithSuccesscategory:(StatusSuccessBlock)success CategoryId:(NSString *)cateid lastID:(NSString *)lastid CategoryFailure:(StatusFailureBlock)failure
{
    
    NSDictionary *dicid = [NSDictionary dictionaryWithObjectsAndKeys:cateid,@"category_id", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicid options:NSJSONWritingPrettyPrinted error:nil];
    NSString *condition = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"15",@"pagesize",lastid,@"lastid",condition,@"condition", nil];

    [HttpTool postWithPath:@"getSupplyInfoList" params:dic success:^(id JSON) {
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        NSDictionary *array =d[@"response"];

        if (![array isKindOfClass:[NSNull class]]){
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
+(void)CompanyStatusesWithSuccesscategory:(StatusSuccessBlock)success CompanyId:(NSString *)cateid CompanyFailure:(StatusFailureBlock)failure  {
    
    NSDictionary *dicid = [NSDictionary dictionaryWithObjectsAndKeys:cateid,@"company_id", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicid options:NSJSONWritingPrettyPrinted error:nil];
    NSString *condition = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"15",@"pagesize",@"0",@"lastid",condition,@"condition", nil];
    [HttpTool postWithPath:@"getSupplyInfoList" params:dic success:^(id JSON) {
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        NSDictionary *array =d[@"response"];
        if (![array isKindOfClass:[NSNull class]]){
            for (NSDictionary *dict in array) {
                supplyCOM *s =[[supplyCOM alloc] initWithDictonary:dict];
                
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

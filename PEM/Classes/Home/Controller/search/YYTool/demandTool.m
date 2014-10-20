//
//  demandTool.m
//  PEM
//
//  Created by YY on 14-9-4.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "demandTool.h"
#import "HttpTool.h"
#import "yyDemandModel.h"
#import "demandCOM.h"
#import "RemindView.h"
@implementation demandTool
+ (void)statusesWithSuccess:(StatusSuccessBlock)success lastID:(NSString *)lastid failure:(StatusFailureBlock)failure
{
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"15",@"pagesize",lastid,@"lastid", nil];
    [HttpTool postWithPath:@"getDemandInfoList" params:dic success:^(id JSON) {
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        NSDictionary *array =d[@"response"];
        if (![array isKindOfClass:[NSNull class]])
        { for (NSDictionary *dict in array) {
            yyDemandModel *s =[[yyDemandModel alloc] initWithDictionaryFordemand:dict];
            
            [statuses addObject:s];
            
        }
            success(statuses);

        }
            else{

            [RemindView showViewWithTitle:@"没有数据！" location:BELLOW];


        }
    

    } failure:^(NSError *error) {
        if (failure==nil)return ; {
            failure(error);
        }
    }];
}
+(void)DemandStatusesWithSuccess:(StatusSuccessBlock)success DemandId:(NSString *)demandid lastID:(NSString *)lastid DemandFailure:(StatusFailureBlock)failure
{
    
    NSDictionary *dicid = [NSDictionary dictionaryWithObjectsAndKeys:demandid,@"category_id", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicid options:NSJSONWritingPrettyPrinted error:nil];
    NSString *condition = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"15",@"pagesize",lastid,@"lastid",condition,@"condition", nil];
    [HttpTool postWithPath:@"getDemandInfoList" params:dic success:^(id JSON) {
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        NSDictionary *array =d[@"response"];
        if (![array isKindOfClass:[NSNull class]]) {
            for (NSDictionary *dict in array) {
                yyDemandModel *s =[[yyDemandModel alloc] initWithDictionaryFordemand:dict];
                
                [statuses addObject:s];
            }
            success(statuses);
        }else{
            [RemindView showViewWithTitle:@"没有数据！" location:BELLOW];
        }
        
    } failure:^(NSError *error) {
        if (failure==nil)return ; {
            failure(error);
        }
    }];
}

+(void)DemandCompanyStatusesWithSuccess:(StatusSuccessBlock)success DemandCompanyFailure:(StatusFailureBlock)failure DemandCompanyId:(NSString *)cateid ;

{
    
    NSDictionary *dicid = [NSDictionary dictionaryWithObjectsAndKeys:cateid,@"company_id", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicid options:NSJSONWritingPrettyPrinted error:nil];
    NSString *condition = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"15",@"pagesize",@"0",@"lastid",condition,@"condition", nil];
    [HttpTool postWithPath:@"getDemandInfoList" params:dic success:^(id JSON) {
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        NSDictionary *array =d[@"response"];
        if (![array isKindOfClass:[NSNull class]]){
            for (NSDictionary *dict in array) {
                demandCOM *s =[[demandCOM alloc] initWithDictonary:dict];

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

//
//  XQgetInfoTool.m
//  PEM
//
//  Created by YY on 14-9-15.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "XQgetInfoTool.h"

#import "HttpTool.h"
#import "XQgetInfoDetailModel.h"
#import "comHomeModel.h"
#import "SystemConfig.h"
@implementation XQgetInfoTool
+ (void)statusesWithSuccess:(StatusSuccessBlock)success failure:(StatusFailureBlock)failure infoID:(NSString *)infoid
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:infoid,@"info_id", nil];
    if ([SystemConfig sharedInstance].isUserLogin) {
        [dic setObject:[SystemConfig sharedInstance].company_id forKey:@"company_id"];
    }
    [HttpTool postWithPath:@"getInfoDetail" params:dic success:^(id JSON) {
    NSDictionary *d = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];        
        NSMutableArray *statuses =[NSMutableArray array];

        NSDictionary *array =[d[@"response"]objectForKey:@"data"];
        XQgetInfoDetailModel *s =[[XQgetInfoDetailModel alloc] initWithDictionaryForGategory:array];
            [statuses addObject:s];
         success(statuses);


        }
    
   

        failure:^(NSError *error) {
        if (failure==nil)return ; {
            failure(error);
        }
    }];
    
    
}
+ (void)statusesWithSuccessNew:(StatusSuccessBlock)success newFailure:(StatusFailureBlock)failure NewCompanyid:(NSString *)companyid
{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:companyid,@"company_id", nil];
    [HttpTool postWithPath:@"getCompanyDetail" params:dic success:^(id JSON) {
        
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];

        NSDictionary *comPanyArray =d[@"response"];
        if (![comPanyArray isKindOfClass:[NSNull class]]){

        comHomeModel *s =[[comHomeModel alloc]initWithDictionaryForComapny:comPanyArray];
        
        [statuses addObject:s];
        success(statuses);

        }
    }
        failure:^(NSError *error) {
        if (failure==nil)return ; {
        failure(error);

}
        }];

    
}

@end

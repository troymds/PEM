//
//  comPanyNEWTool.m
//  PEM
//
//  Created by YY on 14-9-19.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "comPanyNEWTool.h"
#import "HttpTool.h"
#import "comContent.h"
#import "RemindView.h"
@implementation comPanyNEWTool
+ (void)statusesWithSuccessNew:(StatusSuccessBlock)success NewFailure:(StatusFailureBlock)failure CompanyID:(NSString *)comid{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:comid,@"company_id" ,@"15",@"pagesize",@"0",@"last_id",nil];
    [HttpTool postWithPath:@"getCompanyNewsList" params:dic success:^(id JSON) {
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        NSDictionary *array =d[@"response"];
        if ([array isKindOfClass:[NSNull class]]){
            [RemindView showViewWithTitle:@"没有数据！" location:BELLOW];
        }
        else{
            for (NSDictionary *dict in array) {

                  comContent   *s =[[comContent alloc] initWithDictionaryForComapny:dict];
                
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
+ (void)NEWstatusesWithSuccessNew:(StatusSuccessBlock)success NewFailure:(StatusFailureBlock)failure NEWCompanyID:(NSString *)comid{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:comid,@"newsid" ,nil];
    [HttpTool postWithPath:@"getNewsWapUrl" params:dic success:^(id JSON) {
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        
        NSDictionary *array =d[@"response"];
        if (![array isKindOfClass:[NSNull class]]){
            for (NSDictionary *dict in array) {
                
                comContent   *s =[[comContent alloc] initWithDictionaryForComapny:dict];
                
                [statuses addObject:s];
            }
            
        }
    } failure:^(NSError *error) {
        
    }];
}


@end

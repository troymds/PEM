//
//  companyTool.m
//  PEM
//
//  Created by YY on 14-9-4.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "companyTool.h"
#import "HttpTool.h"
#import "yyCompanyModel.h"
@implementation companyTool
+ (void)statusesWithSuccess:(StatusSuccessBlock)success lasiID:(NSString *)lastid failure:(StatusFailureBlock)failure
{
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"10",@"pagesize",lastid,@"lastid", nil];
    [HttpTool postWithPath:@"getCompanyList" params:dic success:^(id JSON) {
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];

        NSMutableArray *statuses =[NSMutableArray array];
        
        NSDictionary *array =d[@"response"];
        if (array) {
            if ([array isKindOfClass:[NSNull class]]) {
            }{
                for (NSDictionary *dict in array) {
                    yyCompanyModel *s =[[yyCompanyModel alloc] initWithDictionaryForCompany:dict];
                    
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

//
//  collocetAddToWishlistTool.m
//  PEM
//
//  Created by YY on 14-9-23.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "collocetAddToWishlistTool.h"
#import "HttpTool.h"
#import "supplyWishlistidModel.h"
@implementation collocetAddToWishlistTool
+(void)CategoryStatusesWithSuccesscategory:(StatusSuccessBlock)success companyID:(NSString *)companyid infoID:(NSString *)infoid CategoryFailure:(StatusFailureBlock)failure{
        
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:companyid,@"company_id",infoid, @"info_id" , nil];
    [HttpTool postWithPath:@"addToWishlist" params:dic success:^(id JSON) {
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];

        NSDictionary *array =d[@"response"];
        if (d[@"response"]) {
            supplyWishlistidModel *s =[[supplyWishlistidModel alloc] initWithDictonary:array];
            [statuses addObject:s];
            success(statuses);
        }
    } failure:^(NSError *error) {
        if (failure==nil)return ; {
            failure(error);
        }
    }];

    
    
}
+(void)cancleWishlistStatusesWithSuccesscategory:(StatusSuccessBlock)success companyID:(NSString *)companyid  wishlistidID:(NSString *)wishlistid wishlistFailure:(StatusFailureBlock)failure
{
    
    
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:wishlistid, @"wishlistid",companyid,@"company_id", nil];
    [HttpTool postWithPath:@"cancleWishlist" params:dic success:^(id JSON) {
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];

        NSDictionary *array =d[@"response"];
        if (d[@"response"]) {
            NSMutableArray *statuses =[NSMutableArray array];
            supplyWishlistidModel *s =[[supplyWishlistidModel alloc] initWithDictonary:array];
            
            [statuses addObject:s];
            success(statuses);
        }
    } failure:^(NSError *error) {
        if (failure==nil)return ; {
            failure(error);
        }
    }];

    
}

@end

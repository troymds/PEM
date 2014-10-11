//
//  supplyTool.h
//  PEM
//
//  Created by YY on 14-9-4.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^StatusSuccessBlock)(NSArray *statues);
typedef void (^StatusFailureBlock)(NSError *error);

@interface supplyTool : NSObject
@property(nonatomic,strong)NSMutableArray *supparr;
+ (void)statusesWithSuccess:(StatusSuccessBlock)success lastID:(NSString * )lastid failure:(StatusFailureBlock)failure;

+(void)CategoryStatusesWithSuccesscategory:(StatusSuccessBlock)success CategoryId:(NSString *)cateid lastID:(NSString *)lastid CategoryFailure:(StatusFailureBlock)failure;

+(void)CompanyStatusesWithSuccesscategory:(StatusSuccessBlock)success  CompanyId:(NSString *)cateid CompanyFailure:(StatusFailureBlock)failure ;


@end

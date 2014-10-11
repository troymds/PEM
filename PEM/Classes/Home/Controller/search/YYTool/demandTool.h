//
//  demandTool.h
//  PEM
//
//  Created by YY on 14-9-4.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^StatusSuccessBlock)(NSArray *statues);
typedef void (^StatusFailureBlock)(NSError *error);

@interface demandTool : NSObject

@property(nonatomic,strong)NSMutableArray *supparr;
+ (void)statusesWithSuccess:(StatusSuccessBlock)success  lastID:(NSString *)lastid failure:(StatusFailureBlock)failure;
+ (void)DemandStatusesWithSuccess:(StatusSuccessBlock)success DemandId:(NSString *)demandid lastID:(NSString *)lastid DemandFailure:(StatusFailureBlock)failure;

+(void)DemandCompanyStatusesWithSuccess:(StatusSuccessBlock)success DemandCompanyFailure:(StatusFailureBlock)failure DemandCompanyId:(NSString *)cateid ;

@end

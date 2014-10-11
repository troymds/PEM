//
//  comPanyNEWTool.h
//  PEM
//
//  Created by YY on 14-9-19.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^StatusSuccessBlock)(NSArray *statues);
typedef void (^StatusFailureBlock)(NSError *error);

@interface comPanyNEWTool : NSObject
+ (void)statusesWithSuccessNew:(StatusSuccessBlock)success NewFailure:(StatusFailureBlock)failure CompanyID:(NSString *)comid;
+ (void)NEWstatusesWithSuccessNew:(StatusSuccessBlock)success NewFailure:(StatusFailureBlock)failure NEWCompanyID:(NSString *)comid;

@end

//
//  XQgetInfoTool.h
//  PEM
//
//  Created by YY on 14-9-15.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^StatusSuccessBlock)(NSArray *statues);
typedef void (^StatusFailureBlock)(NSError *error);
@interface XQgetInfoTool : NSObject

+ (void)statusesWithSuccess:(StatusSuccessBlock)success failure:(StatusFailureBlock)failure infoID:(NSString *)infoid;
+ (void)statusesWithSuccessNew:(StatusSuccessBlock)success newFailure:(StatusFailureBlock)failure NewCompanyid:(NSString *)companyid;

@end

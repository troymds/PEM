//
//  hotOrderMoedl.h
//  PEM
//
//  Created by YY on 14-9-23.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^StatusSuccessBlock)(NSArray *statues);
typedef void (^StatusFailureBlock)(NSError *error);
@interface hotOrderMoedl : NSObject


+(void)CategoryStatusesWithSuccesscategory:(StatusSuccessBlock)success cateId:(NSString *)cateid supplyHot:(NSString *)supply lastID:(NSString *)lastid CategoryFailure:(StatusFailureBlock)failure;

+(void)CategoryStatusesWithSuccesscategory:(StatusSuccessBlock)success cateId:(NSString *)cateid demandHot:(NSString *)demand lastID:(NSString *)lastid CategoryFailure:(StatusFailureBlock)failure;

@end

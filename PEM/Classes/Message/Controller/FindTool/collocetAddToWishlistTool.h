//
//  collocetAddToWishlistTool.h
//  PEM
//
//  Created by YY on 14-9-23.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^StatusSuccessBlock)(NSArray *statues);
typedef void (^StatusFailureBlock)(NSError *error);
@interface collocetAddToWishlistTool : NSObject


+(void)CategoryStatusesWithSuccesscategory:(StatusSuccessBlock)success companyID:(NSString *)companyid infoID:(NSString *)infoid CategoryFailure:(StatusFailureBlock)failure;

+(void)cancleWishlistStatusesWithSuccesscategory:(StatusSuccessBlock)success companyID:(NSString *)companyid  wishlistidID:(NSString *)wishlistid wishlistFailure:(StatusFailureBlock)failure;

@end

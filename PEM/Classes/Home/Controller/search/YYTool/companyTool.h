//
//  companyTool.h
//  PEM
//
//  Created by YY on 14-9-4.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^StatusSuccessBlock)(NSArray *statues);
typedef void (^StatusFailureBlock)(NSError *error);

@interface companyTool : NSObject

@property(nonatomic,strong)NSMutableArray *supparr;
+ (void)statusesWithSuccess:(StatusSuccessBlock)success lasiID:(NSString *)lastid failure:(StatusFailureBlock)failure;

@end

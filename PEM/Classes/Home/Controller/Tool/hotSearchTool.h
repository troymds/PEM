//
//  hotSearchTool.h
//  PEM
//
//  Created by YY on 14-11-12.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^StatusSuccessBlock)(NSArray *statues);
typedef void (^StatusFailureBlock)(NSError *error);
@interface hotSearchTool : NSObject



@property(nonatomic,strong)NSMutableArray *supparr;
+ (void)statusesWithSuccess:(StatusSuccessBlock)success failure:(StatusFailureBlock)failure;
@end

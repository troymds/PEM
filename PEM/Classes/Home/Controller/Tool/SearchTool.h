//
//  SearchTool.h
//  PEM
//
//  Created by house365 on 14-9-22.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchTool : NSObject

typedef void (^SearchSuccessBlock)(NSArray *search);
typedef void (^SearchFailureBlock)(NSError *error);


+ (void)searchWithSuccessBlock:(SearchSuccessBlock)success withKeywords:(NSString *)keywords lastID:(NSString *)lastid failureBlock:(SearchFailureBlock)failure;
+ (void)searchWithSupplySuccessBlock:(SearchSuccessBlock)success SupplywithKeywords:(NSString *)keywords lastID:(NSString *)lastid SupplyfailureBlock:(SearchFailureBlock)failure;

+ (void)searchWithDemandSuccessBlock:(SearchSuccessBlock)success DemandwithKeywords:(NSString *)keywords lastID:(NSString *)lastid DemandfailureBlock:(SearchFailureBlock)failure;

@end

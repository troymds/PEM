//
//  Loading.h
//  Teddybear
//
//  Created by apple on 14-9-23.
//  Copyright (c) 2014年 chunxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Loading : NSObject
+(void)loadingBefore;
+(void)loadingSuccess;
+(void)loadingFailure;
@end

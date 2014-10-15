//
//  SaveDemandDataTool.h
//  PEM
//
//  Created by YY on 14-10-15.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveDemandDataTool : NSObject
+(NSString *)getFilePath;

+(void)archiveClass:(NSMutableArray *)array;
+ (NSMutableArray *)unarchiveClass;


@end

//
//  SaveTempDataTool.h
//  PEM
//
//  Created by house365 on 14-8-30.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveTempDataTool : NSObject
+(NSString *)getFilePath;

+(void)archiveClass:(NSMutableArray *)array;
+ (NSMutableArray *)unarchiveClass;

@end

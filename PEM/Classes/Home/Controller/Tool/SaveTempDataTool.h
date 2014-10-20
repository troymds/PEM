//
//  SaveTempDataTool.h
//  PEM
//
//  Created by house365 on 14-8-30.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveTempDataTool : NSObject

+ (NSString *)getFilePathWithTag:(int)tag;
+(void)archiveClass:(NSMutableArray *)array withArrayTag:(int)tag;
+ (NSMutableArray *)unarchiveClassWithArrayTag:(int)tag;

@end

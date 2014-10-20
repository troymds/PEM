//
//  SaveTempDataTool.m
//  PEM
//
//  Created by house365 on 14-8-30.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "SaveTempDataTool.h"
static SaveTempDataTool *shareInstance = nil;
@implementation SaveTempDataTool
+(SaveTempDataTool *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[SaveTempDataTool alloc] init];
    });
    return shareInstance;
}
+(id)allocWithZone:(struct _NSZone *)zone
{
    if (shareInstance)
    {
        return shareInstance;
    }
    return [super allocWithZone:zone];
}

+ (NSString *)getFilePathWithTag:(int)tag
{
    return [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/searchWord%d.plist",tag]];
}

+(void)archiveClass:(NSMutableArray *)array withArrayTag:(int)tag
{
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:0];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:array];
    [archiver finishEncoding];
    [data writeToFile:[self getFilePathWithTag:tag] atomically:YES];
}

+ (NSMutableArray *)unarchiveClassWithArrayTag:(int)tag
{
    NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:[self getFilePathWithTag:tag]];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSMutableArray *array = [unarchiver decodeObject];
    [unarchiver finishDecoding];
    
    return array;
}

@end

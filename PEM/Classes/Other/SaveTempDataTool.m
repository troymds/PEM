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

+ (NSString *)getFilePath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/searchWord.plist"];
}

+(void)archiveClass:(NSMutableArray *)array
{
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:0];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:array];
    [archiver finishEncoding];
    [data writeToFile:[self getFilePath] atomically:YES];
}

+ (NSMutableArray *)unarchiveClass
{
    NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:[self getFilePath]];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSMutableArray *array = [unarchiver decodeObject];
    [unarchiver finishDecoding];
    
    return array;
}

@end

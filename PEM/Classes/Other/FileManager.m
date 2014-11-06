//
//  FileManager.m
//  PEM
//
//  Created by tianj on 14-9-12.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager



+ (NSString *)getPathForDocuments{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [path objectAtIndex:0];
}

+(NSString *)getPathForChche{
    NSArray *path =NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [path objectAtIndex:0];
}


+ (void)writeDictionary:(NSDictionary *)data toFile:(NSString *)fileName{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *plistPath = [[self getPathForDocuments] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    if (![fm fileExistsAtPath:plistPath]) {
        [fm createFileAtPath:plistPath contents:nil attributes:nil];
    }
    [data writeToFile:plistPath atomically:YES];
}

+(void)writeArray:(NSArray *)data toFile:(NSString *)fileName{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *plistPath = [[self getPathForDocuments] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    if (![fm fileExistsAtPath:plistPath]) {
        [fm createFileAtPath:plistPath contents:nil attributes:nil];
    }
    [data writeToFile:plistPath atomically:YES];
}

+ (NSArray *)readArrayFromFileName:(NSString *)fileName{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *plistPath = [[self getPathForDocuments] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    if (![fm fileExistsAtPath:plistPath]){
        return nil;
    }
    return [NSArray arrayWithContentsOfFile:plistPath];
}

+ (NSDictionary *)readDictionaryFromFileName:(NSString *)fileName{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *plistPath = [[self getPathForDocuments] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    if (![fm fileExistsAtPath:plistPath]){
        return nil;
    }
    return [NSDictionary dictionaryWithContentsOfFile:plistPath];
}

+ (BOOL)fileExistName:(NSString *)fileName
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *plistPath = [[self getPathForDocuments] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    if ([fm fileExistsAtPath:plistPath]) {
        return YES;
    }
    return NO;
}







@end

//
//  FileManager.h
//  PEM
//
//  Created by tianj on 14-9-12.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef  enum
{
    DocumentType,
    CacheType
}directoryType;

@interface FileManager : NSObject

+ (void)writeDictionary:(NSDictionary *)data toFile:(NSString *)fileName withType:(directoryType)type;

+(void)writeArray:(NSArray *)data toFile:(NSString *)fileName withType:(directoryType)type;

+ (NSArray *)readArrayFromFileName:(NSString *)fileName withType:(directoryType)type;

+ (NSDictionary *)readDictionaryFromFileName:(NSString *)fileName withType:(directoryType)type;

+ (BOOL)fileExistName:(NSString *)fileName withType:(directoryType)type;


@end

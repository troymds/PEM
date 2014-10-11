//
//  FileManager.h
//  PEM
//
//  Created by tianj on 14-9-12.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

+ (void)writeDictionary:(NSDictionary *)data toFile:(NSString *)fileName;

+(void)writeArray:(NSMutableArray *)data toFile:(NSString *)fileName;

+ (NSArray *)readArrayFromFileName:(NSString *)fileName;

+ (NSDictionary *)readDictionaryFromFileName:(NSString *)fileName;

+ (BOOL)fileExistName:(NSString *)fileName;

@end

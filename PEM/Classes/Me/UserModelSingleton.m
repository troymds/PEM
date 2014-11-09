//
//  UserModelSingleton.m
//  PEM
//
//  Created by Tianj on 14/11/9.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "UserModelSingleton.h"

static NSString *ebgFileBaseDir = @"httd";
static NSString *ebgFileName = @"ebgIhpone.dat";
@implementation UserModelSingleton



- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.infoItem forKey:@"companyInfo"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.infoItem = [aDecoder decodeObjectForKey:@"companyInfo"];
    }
    return self;
}

- (BOOL)archive
{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *path = [array objectAtIndex:0];
    [path stringByAppendingPathComponent:ebgFileBaseDir];
    BOOL isDir = YES;
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path isDirectory:&isDir]) {
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    [path stringByAppendingPathComponent:ebgFileName];
    return [NSKeyedArchiver archiveRootObject:self toFile:path];
}

+ (UserModelSingleton *)shareInstance
{
    static UserModelSingleton *_instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        NSArray *array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        NSString *path = [array objectAtIndex:0];
        [path stringByAppendingPathComponent:ebgFileBaseDir];
        BOOL isDir = YES;
        NSFileManager *fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:path isDirectory:&isDir]) {
            [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
        [path stringByAppendingPathComponent:ebgFileName];
        _instance = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    });
    return _instance;
}

@end

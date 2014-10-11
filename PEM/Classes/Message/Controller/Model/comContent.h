//
//  comContent.h
//  PEM
//
//  Created by YY on 14-9-19.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface comContent : NSObject
#pragma mark-----company


@property (nonatomic, copy) NSString *comid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *create_time ;
@property (nonatomic, copy) NSString *description;

- (instancetype)initWithDictionaryForComapny:(NSDictionary *)dic;



@end

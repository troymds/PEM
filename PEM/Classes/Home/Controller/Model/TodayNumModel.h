//
//  TodayNumModel.h
//  PEM
//
//  Created by house365 on 14-9-4.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodayNumModel : NSObject

@property (nonatomic, copy) NSString *callNum;
@property (nonatomic, copy) NSString *demandNum;
@property (nonatomic, copy) NSString *supplyNum;

- (instancetype)initWithTodayNumDictionary:(NSDictionary *)dict;

@end

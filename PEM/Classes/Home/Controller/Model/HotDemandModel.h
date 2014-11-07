//
//  HotDemandModel.h
//  PEM
//
//  Created by YY on 14-9-4.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotDemandModel : NSObject<NSCoding>
@property (nonatomic, copy) NSString *demandHotid;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *sub_title;

@property (nonatomic, copy) NSString *title;

- (instancetype)initWithDictionaryForHotDeman:(NSDictionary *)dict;

@end

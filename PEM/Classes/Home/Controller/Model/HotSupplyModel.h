//
//  HotSupplyModel.h
//  PEM
//
//  Created by YY on 14-9-4.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotSupplyModel : NSObject<NSCoding>
@property (nonatomic, copy) NSString *supplyhotID;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *sub_title;
@property (nonatomic, copy) NSString *title;
@property(nonatomic,copy)NSString *supplytype;


- (instancetype)initWithDictionaryForHotSupply:(NSDictionary *)dict;

@end

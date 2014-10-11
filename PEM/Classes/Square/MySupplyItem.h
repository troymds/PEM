//
//  MySupplyItem.h
//  PEM
//
//  Created by tianj on 14-9-9.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySupplyItem : NSObject

@property (nonatomic,copy) NSString *company;
@property (nonatomic,copy) NSString *company_rank;
@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *image;
@property (nonatomic,copy) NSString *min_supply_num;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *read_num;
@property (nonatomic,copy) NSString *region;
@property (nonatomic,copy) NSString *unit;
@property (nonatomic,copy) NSString *verify_result;


- (id)initWithDictonary:(NSDictionary *)dic;

@end

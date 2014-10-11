//
//  supplyCOM.h
//  PEM
//
//  Created by YY on 14-9-20.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface supplyCOM : NSObject
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


- (id)initWithDictonary:(NSDictionary *)dic;

@end

//
//  SupplyDetailItem.h
//  PEM
//
//  Created by tianj on 14-9-29.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupplyDetailItem : NSObject

@property (nonatomic,copy) NSString *buy_num;
@property (nonatomic,copy) NSString *category_id;
@property (nonatomic,copy) NSString *category_name;
@property (nonatomic,copy) NSString *company_id;
@property (nonatomic,copy) NSString *company_name;
@property (nonatomic,copy) NSString *contacts;
@property (nonatomic,copy) NSString *create_time;
@property (nonatomic,copy) NSString *description;
@property (nonatomic,copy) NSString *from;
@property (nonatomic,copy) NSString *image;
@property (nonatomic,copy) NSString *info_id;
@property (nonatomic,copy) NSString *inwishlist;
@property (nonatomic,copy) NSString *min_sell_num;
@property (nonatomic,copy) NSString *need_num;
@property (nonatomic,copy) NSString *phone_num;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *read_num;
@property (nonatomic,copy) NSString *region;
@property (nonatomic,copy) NSString *sell_limit;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *unit;
@property (nonatomic,copy) NSString *verify_admin;
@property (nonatomic,copy) NSString *verify_reason;
@property (nonatomic,copy) NSString *verify_result;
@property (nonatomic,copy) NSString *verify_time;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end











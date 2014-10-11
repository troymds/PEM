//
//  CompanyInfoItem.h
//  PEM
//
//  Created by tianj on 14-9-11.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyInfoItem : NSObject

@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *city_id;
@property (nonatomic,copy) NSString *city_name;
@property (nonatomic,copy) NSString *company_id;
@property (nonatomic,copy) NSString *company_name;
@property (nonatomic,copy) NSString *company_tel;
@property (nonatomic,copy) NSString *email;
@property (nonatomic,copy) NSString *image;
@property (nonatomic,copy) NSString *is_lock;
@property (nonatomic,copy) NSString *province_id;
@property (nonatomic,copy) NSString *province_name;
@property (nonatomic,copy) NSString *viptype;
@property (nonatomic,copy) NSString *website;


- (id)initWithDictionary:(NSDictionary *)dic;

@end

//
//  AccountItem.h
//  PEM
//
//  Created by tianj on 14-9-1.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountItem : NSObject

@property (nonatomic,copy) NSString *company_name;
@property (nonatomic,copy) NSString *company_id;
@property (nonatomic,copy) NSString *viptype;
@property (nonatomic,copy) NSString *is_lock;
@property (nonatomic,copy) NSString *website;
@property (nonatomic,copy) NSString *region;
@property (nonatomic,copy) NSString *image;


- (id)initWithDictionary:(NSDictionary *)dic;

@end

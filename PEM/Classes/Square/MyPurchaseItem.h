//
//  MyPurchaseItem.h
//  PEM
//
//  Created by tianj on 14-9-10.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyPurchaseItem : NSObject

@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *introduction;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *read_num;
@property (nonatomic,copy) NSString *verify_result;

- (id)initWithDictionary:(NSDictionary *)dic;

@end

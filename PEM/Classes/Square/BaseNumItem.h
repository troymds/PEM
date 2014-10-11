//
//  BaseNumItem.h
//  PEM
//
//  Created by tianj on 14-9-11.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseNumItem : NSObject

@property (nonatomic,copy) NSString *demand;
@property (nonatomic,copy) NSString *supply;
@property (nonatomic,copy) NSString *wishlist;
@property (nonatomic,copy) NSString *news;

- (id)initWithDictionary:(NSDictionary *)dic;

@end

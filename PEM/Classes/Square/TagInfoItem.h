//
//  TagInfoItem.h
//  PEM
//
//  Created by tianj on 14-9-16.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagInfoItem : NSObject

@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *create_time;
@property (nonatomic,copy) NSString *is_read;

- (id)initWithDictionary:(NSDictionary *)dic;

@end

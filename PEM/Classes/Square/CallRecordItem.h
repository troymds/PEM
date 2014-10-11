//
//  CallRecordItem.h
//  PEM
//
//  Created by tianj on 14-9-11.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CallRecordItem : NSObject

@property (nonatomic,copy) NSString *call_time;
@property (nonatomic,copy) NSString *contacts;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *info_id;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *phone_num;
@property (nonatomic,copy) NSString *to_id;
@property (nonatomic,copy) NSString *type;

- (id)initWithDictionary:(NSDictionary *)dic;

@end

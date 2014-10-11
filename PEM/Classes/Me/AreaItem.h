//
//  AreaItem.h
//  PEM
//
//  Created by tianj on 14-9-24.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaItem : NSObject
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *father_id;
@property (nonatomic,copy) NSString *name;

- (id)initWithDictionary:(NSDictionary *)dic;
@end

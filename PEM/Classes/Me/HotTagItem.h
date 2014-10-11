//
//  HotTagItem.h
//  PEM
//
//  Created by tianj on 14-9-4.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotTagItem : NSObject

@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *name;

- (id)initWithDictionary:(NSDictionary *)dic;


@end

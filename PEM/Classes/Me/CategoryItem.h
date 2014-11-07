//
//  CategoryItem.h
//  PEM
//
//  Created by tianj on 14-9-1.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryItem : NSObject

@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *parent_id;
@property (nonatomic,copy) NSString *image;
@property (nonatomic,copy) NSString *name;

- (id)initWithDic:(NSDictionary *)dic;

@end

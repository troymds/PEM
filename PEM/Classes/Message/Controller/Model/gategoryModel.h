//
//  gategoryModel.h
//  PEM
//
//  Created by YY on 14-9-12.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface gategoryModel : NSObject<NSCoding>
@property (nonatomic, copy) NSString *idType;
@property (nonatomic, copy) NSString *imageGategpry;
@property (nonatomic, copy) NSString *nameGategory;
@property (nonatomic,copy) NSString *parent_id;

- (instancetype)initWithDictionaryForGategory:(NSDictionary *)dict;

@end

//
//  HotCategoryModel.h
//  PEM
//
//  Created by house365 on 14-9-3.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotCategoryModel : NSObject

@property (nonatomic, copy) NSString *cateid;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *name;

- (instancetype)initWithDictionaryForHotCate:(NSDictionary *)dict;

@end

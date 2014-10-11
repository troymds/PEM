//
//  comPanyModel.h
//  PEM
//
//  Created by YY on 14-9-19.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface comPanyModel : NSObject
@property (nonatomic, copy) NSString *comid;   //图片
@property (nonatomic, copy) NSString *name;//
@property (nonatomic, copy) NSString *time ;//主要运营
@property (nonatomic, copy) NSString *type;//名字
- (instancetype)initWithDictionaryForComapnyBtn:(NSDictionary *)dic;

@end

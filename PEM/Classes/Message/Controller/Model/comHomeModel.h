//
//  comHomeModel.h
//  PEM
//
//  Created by YY on 14-9-20.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface comHomeModel : NSObject
#pragma mark-----company

@property (nonatomic, copy) NSString *addr;   //地址

@property (nonatomic, copy) NSString *image;   //图片
@property (nonatomic, copy) NSString *introduction;//
@property (nonatomic, copy) NSString *mainRun ;//主要运营
@property (nonatomic, copy) NSString *name;//名字
@property (nonatomic, copy) NSString *tel ;//电话
@property (nonatomic, copy) NSArray *infoarray;
@property (nonatomic, copy) NSString *website ;//网址
@property (nonatomic, copy) NSString *viptype;


- (instancetype)initWithDictionaryForComapny:(NSDictionary *)dic;


@end

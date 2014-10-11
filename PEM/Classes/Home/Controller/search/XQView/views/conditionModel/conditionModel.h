//
//  conditionModel.h
//  PEM
//
//  Created by YY on 14-9-11.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface conditionModel : NSObject
@property (nonatomic, copy) NSString *typeId;
@property (nonatomic, copy) NSString *comdionId;

@property (nonatomic, copy) NSString *time;//时间

@property (nonatomic, strong)NSString *image;//图片
@property (nonatomic, strong)NSString *viptype;//Vip类型
@property (nonatomic, strong)NSString *company;//公司公司名称
@property (nonatomic, strong)NSString *region;//地址
@property (nonatomic, strong)NSString *website;//网址
@property (nonatomic, strong)NSString *introduction;//简介
@property (nonatomic, strong)NSString *type;//类型
@property (nonatomic, strong)NSString *name;//信息名称
@property (nonatomic, strong)NSString *tel ;//电话

- (instancetype)initWithDictionaryForCondition:(NSDictionary *)dict;

@end

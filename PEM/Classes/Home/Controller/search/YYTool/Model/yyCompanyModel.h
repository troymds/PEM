//
//  yyCompanyModel.h
//  PEM
//
//  Created by YY on 14-9-4.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface yyCompanyModel : NSObject
@property (nonatomic, copy) NSString *companyid;
@property (nonatomic, strong)NSString *image;//图片
@property (nonatomic, strong)NSString *region;//地区
@property (nonatomic, strong)NSString *name;//公司名称

@property (nonatomic, strong)NSString *rank;//企业等级
@property (nonatomic, strong)NSString *business;//主营业务

- (instancetype)initWithDictionaryForCompany:(NSDictionary *)dict;

@end

//
//  yySupplyModel.h
//  PEM
//
//  Created by YY on 14-9-4.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface yySupplyModel : NSObject
@property (nonatomic, copy) NSString *supplyId;
@property (nonatomic, strong)NSString *image;//图片
@property (nonatomic, strong)NSString *name;//产品名称
@property (nonatomic, strong)NSString *company;//公司名称
@property (nonatomic, strong)NSString *read_num;//查看次数

@property (nonatomic, strong)NSString *price;//价格
@property (nonatomic, strong)NSString *min_supply_num;//起购标准
- (instancetype)initWithDictionaryForSupply:(NSDictionary *)dict;

@end

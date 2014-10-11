//
//  yyDemandModel.h
//  PEM
//
//  Created by YY on 14-9-4.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface yyDemandModel : NSObject
@property (nonatomic, copy) NSString *demandid;
@property (nonatomic, strong)NSString *name;//产品名称
@property (nonatomic, strong)NSString *demandDate;//时间
@property (nonatomic, strong)NSString *read_num;//查看次数
@property(nonatomic,strong)NSString *buy_num;
@property (nonatomic, strong)NSString *Introduction;//内容
- (instancetype)initWithDictionaryFordemand:(NSDictionary *)dict;

@end

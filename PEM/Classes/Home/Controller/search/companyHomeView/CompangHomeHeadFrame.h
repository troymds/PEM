//
//  CompangHomeHeadFrame.h
//  PEM
//
//  Created by promo on 14-10-23.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>
@class comHomeModel;


typedef enum {
    kIconTypeSmall,
    kIconTypeDefault,
    kIconTypeBig
} IconType;

@interface CompangHomeHeadFrame : NSObject
@property(nonatomic, strong) comHomeModel * data;
@property (nonatomic, readonly) CGFloat cellHeight; // Cell的高度

@property (nonatomic, readonly) CGRect imageFrame; // 图标

@property (nonatomic, readonly) CGRect companyNameFrame; // 公司名称
@property (nonatomic, readonly) CGRect vipIconFrame; // vip图标的
@property (nonatomic, readonly) CGRect ePlatformFrame; // E平台图标
@property (nonatomic, readonly) CGRect telFrame; // 电话号码
@property (nonatomic, readonly) CGRect webUrlFrame; // 网址

@property (nonatomic, readonly) CGRect addressFrame; // 地址
@property (nonatomic, readonly) CGRect mainBusinessFrame; // 主营范围
@property (nonatomic, readonly) CGRect companyIntrudctionFrame; // 公司简介
@property (nonatomic, readonly) CGRect firstLineFrame; // 第一条线
@property (nonatomic, readonly) CGRect secLineFrame; // 第二条线
@property (nonatomic, readonly) CGRect thirdLineFrame; // 第三条线
@property (nonatomic, readonly) CGRect fourthLineFrame; // 第四条线
@property (nonatomic, readonly) CGRect mainFrame; // 主营范围const

@end

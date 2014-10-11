//
//  SystemConfig.h
//  PEM
//
//  Created by tianj on 14-8-29.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CompanyInfoItem.h"
#import "MySupplyItem.h"
#import "MyPurchaseItem.h"

@interface SystemConfig : NSObject

@property (nonatomic,copy) NSString *uuidStr;        //设备uuid
@property (nonatomic,assign) BOOL isUserLogin;       //是否登录
@property (nonatomic,copy) NSString *viptype;       //会员类型
@property (nonatomic,copy) NSString *company_id;    //登录后的公司ID
@property (nonatomic,retain) CompanyInfoItem *companyInfo;

+ (SystemConfig *)sharedInstance;

@end

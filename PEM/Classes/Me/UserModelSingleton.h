//
//  UserModelSingleton.h
//  PEM
//
//  Created by Tianj on 14/11/9.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CompanyInfoItem.h"

@interface UserModelSingleton : NSObject<NSCoding>

@property (nonatomic,strong) CompanyInfoItem *infoItem;


+ (UserModelSingleton*)shareInstance;

- (BOOL)archive;
@end

//
//  ProvinceController.h
//  PEM
//
//  Created by tianj on 14-9-24.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "BaseController.h"

@protocol ProvinceDelegate <NSObject>

@optional

- (void)selectedWith:(NSString *)province uid:(NSString *)uid;

@end

@interface ProvinceController : BaseController

@property (nonatomic,weak) id <ProvinceDelegate> delegate;

@end

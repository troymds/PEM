//
//  CityController.h
//  PEM
//
//  Created by tianj on 14-9-24.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "BaseController.h"
@protocol CityDelegate <NSObject>

@optional

- (void)selectCity:(NSString *)province withId:(NSString *)uid;

@end

@interface CityController : BaseController

@property (nonatomic,copy) NSString *uid;


@property (nonatomic,weak) id<CityDelegate> delegate;

@end

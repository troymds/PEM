//
//  CategoryController.h
//  PEM
//
//  Created by tianj on 14-8-21.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendValueDelegate.h"

@interface CategoryController : UIViewController
@property (nonatomic,assign) BOOL isSupply;
@property (nonatomic,weak) id<SendValueDelegate> delegate;
@end

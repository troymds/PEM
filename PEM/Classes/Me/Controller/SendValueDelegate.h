//
//  SendValueDelegate.h
//  PEM
//
//  Created by tianj on 14-9-29.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SendValueDelegate <NSObject>

- (void)sendValueFromViewController:(UIViewController *)controller value:(id)value isDemand:(BOOL)isDemand;

@end

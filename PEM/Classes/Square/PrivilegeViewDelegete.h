//
//  PrivilegeViewDelegete.h
//  PEM
//
//  Created by tianj on 14-9-9.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VISITOR_TYPE 2000
#define NOMAL_TYPE 2001
#define VIP_TYPE 2002
#define VVIP_TYPE 2003

@protocol PrivilegeViewDelegete <NSObject>

@optional

- (void)privilegeBtnDown:(UIButton*)btn;

@end

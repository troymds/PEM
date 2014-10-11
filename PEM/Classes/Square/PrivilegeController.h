//
//  PrivilegeController.h
//  PEM
//
//  Created by tianj on 14-8-29.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PriHeadView.h"
#import "PriImageView.h"
#import "PrivilegeViewDelegete.h"
#import "VisitorView.h"
#import "NomalVipView.h"
#import "VipView.h"
#import "VVipView.h"

@interface PrivilegeController : UIViewController<ProImageViewDelegate,PrivilegeViewDelegete>
{
    PriHeadView *_headView;
    UIScrollView *_scrollView;
    VisitorView *_visitorView;
    NomalVipView *_nomalVipView;
    VipView *_vipView;
    VVipView *_vvipView;
}
@end

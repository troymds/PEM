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

@interface PrivilegeController : UIViewController<ProImageViewDelegate>
{
    PriHeadView *_headView;
    UIScrollView *_scrollView;
    UIImageView *rightImg;
    UIButton *upPowerBtn;
    
    NSString *updateType;    //升级会员类型
}
@end

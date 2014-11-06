//
//  SettingController.h
//  PEM
//
//  Created by tianj on 14-8-26.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetImageView.h"
#import "ProAlertView.h"


@interface SettingController : UIViewController<ProImageViewDelegate,UIAlertViewDelegate,ProAlertViewDelegate>
{
    UIScrollView *_scrollview;
    NSString *_url;
}

@end

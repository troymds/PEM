//
//  SettingController.h
//  PEM
//
//  Created by tianj on 14-8-26.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetImageView.h"
#import "VersionUpdateView.h"

@interface SettingController : UIViewController<ProImageViewDelegate,versionViewDelegate>
{
    UIScrollView *_scrollview;
    NSString *_url;
}

@end

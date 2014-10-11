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

@class SettingController;

@protocol settingDelegate <NSObject>

@optional

- (void)exitLogin:(SettingController *)settingController;

@end

@interface SettingController : UIViewController<ProImageViewDelegate,versionViewDelegate>
{
    UIScrollView *_scrollview;
    NSString *_url;
}


@property (nonatomic,weak) id<settingDelegate> delegate;

@end

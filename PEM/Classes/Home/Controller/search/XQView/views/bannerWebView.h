//
//  bannerWebView.h
//  PEM
//
//  Created by YY on 14-10-24.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewJavascriptBridge.h"

@interface bannerWebView : UIViewController
{
    WebViewJavascriptBridge *_bridge;
}
@property(nonatomic ,strong)NSString *bannerWebid;
@end

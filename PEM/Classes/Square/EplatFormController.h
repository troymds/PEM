//
//  EplatFormController.h
//  PEM
//
//  Created by tianj on 14-10-28.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EplatFormController : UIViewController<UIWebViewDelegate>
{
    UIWebView *_webView;
}
@property (nonatomic,copy) NSString *e_url;
@end

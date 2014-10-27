//
//  bannerWebView.h
//  PEM
//
//  Created by YY on 14-10-24.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bannerWebView : UIViewController
@property(nonatomic ,strong)NSString *bannerWebid;
@property(nonatomic ,assign)int currentTag;
@property(nonatomic , strong)NSString *dataStr;

@end

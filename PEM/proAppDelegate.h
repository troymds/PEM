//
//  proAppDelegate.h
//  PEM
//
//  Created by jch on 14-8-13.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>

#define QQAPPID @"1103300585"
#define QQAPPKEY @"0utta5zCiZfvGdDX"
#define shareAppKey @"35fea059bde0"
#define SinaAppKey @"531851719"
#define SinaAppSecret @"a3498ee96939375894170b4746f6d79b"
#define TencentAppKey @"1103300585"
#define TencentAppSecret @"0utta5zCiZfvGdDX"
#define RenrenAppId @"272485"
#define RenrenAppKey @"6789fb614d8941a1a64add0dbb8b70ae"
#define RenrenAppSecret @"3d2a59b71ad145e8b7a5f14256a3be55"
#define WXAppId @"wx0c00b06c27d5ac8b"
#define WXAppSecret @"b18295032d38ad3da43acad2539b56a7"


@class ViewController;
@interface proAppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)ViewController *viewController;
@property (nonatomic,strong) NSString *updateUrl;
@end

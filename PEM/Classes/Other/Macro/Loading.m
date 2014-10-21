//
//  Loading.m
//  Teddybear
//
//  Created by apple on 14-9-23.
//  Copyright (c) 2014年 chunxi. All rights reserved.
//

#import "Loading.h"
#import "proAppDelegate.h"
#import "MBProgressHUD.h"
@implementation Loading
+(void)loadingBefore{
    proAppDelegate *app =(proAppDelegate *)[UIApplication sharedApplication].delegate;
//    UIView *window =app.window;
//    MBProgressHUD *bd=[[MBProgressHUD alloc]initWithView:window];
//    [window addSubview:bd];
//    bd.tag=123456;
//    bd.dimBackground=YES;
//    bd.detailsLabelText=@"loading...";
//    [bd show:YES];
    
    [MBProgressHUD showHUDAddedTo:app.window animated:YES];
}
+(void)loadingSuccess{
    proAppDelegate *app =(proAppDelegate *)[UIApplication sharedApplication].delegate;
//    UIView *window =app.window;
//    MBProgressHUD *bd=(MBProgressHUD *)[window viewWithTag:123456];
//    [bd removeFromSuperview];
//    bd=nil;
    [MBProgressHUD hideHUDForView:app.window animated:YES];
}

+(void)loadingFailure{
    proAppDelegate *app =(proAppDelegate *)[UIApplication sharedApplication].delegate;
//    UIView *window =app.window;
//    MBProgressHUD *bd=(MBProgressHUD *)[window viewWithTag:123456];
//    [bd removeFromSuperview];
//    bd=nil;
     [MBProgressHUD hideHUDForView:app.window animated:YES];
    
    MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:app.window];
    [app.window addSubview:HUD];
    HUD.labelText = @"抱歉";
    HUD.detailsLabelText = @"请检查网络连接";
    HUD.mode = MBProgressHUDModeText;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1.0);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}
@end

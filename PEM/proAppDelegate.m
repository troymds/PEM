//
//  proAppDelegate.m
//  PEM
//
//  Created by jch on 14-8-13.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "proAppDelegate.h"
#import "MainController.h"
#import "NewfeatureController.h"
#import "SSKeychain.h"
#import "SystemConfig.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "HttpTool.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
#import "WXApi.h"

@implementation proAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    
    //获取用户uuid
    NSString *retrieveuuid = [SSKeychain passwordForService:@"cn.chinapromo.userinfo" account:@"uuid"];
    if (retrieveuuid == nil || [retrieveuuid isEqualToString:@""]) {
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        assert(uuid!=NULL);
        CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
        retrieveuuid = [NSString stringWithFormat:@"%@",uuidStr];
        [SSKeychain setPassword:retrieveuuid forService:@"cn.chinapromo.userinfo" account:@"uuid"];
    }
    [SystemConfig sharedInstance].uuidStr = retrieveuuid;

    
    NSString *key = (NSString *)kCFBundleVersionKey;
    
    // 1.从Info.plist中取出版本号
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    // 2.从沙盒中取出上次存储的版本号
    NSString *saveVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (saveVersion) {
        [self checkVersion];
    }
    
    if ([version isEqualToString:saveVersion]) { // 不是第一次使用这个版本
        // 显示状态栏
        application.statusBarHidden = NO;
        
        self.window.rootViewController = [[MainController alloc] init];
    } else { // 版本号不一样：第一次使用新版本
        // 将新版本号写入沙盒
        [[NSUserDefaults standardUserDefaults] setObject:version forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 显示版本新特性界面
        self.window.rootViewController = [[NewfeatureController alloc] init];
    }
    
    //自动登录
    [self autoLogin];
    
    
    //分享
    [ShareSDK registerApp:shareAppKey];

    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                             redirectUri:@"http://www.sharesdk.cn"];
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:@"568898243"
                                appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                              redirectUri:@"http://www.sharesdk.cn"
                              weiboSDKCls:[WeiboSDK class]];
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:@"100371282"
                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //添加QQ应用  注册网址  http://open.qq.com/
    [ShareSDK connectQQWithQZoneAppKey:@"100371282"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //添加微信应用 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:WXAppId
                           wechatCls:[WXApi class]];
    
    //短信分享
    [ShareSDK connectSMS];
    
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)checkVersion
{
    __weak proAppDelegate *weakSelf = self;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"ios",@"os", nil];
    [HttpTool postWithPath:@"getNewestVersion" params:param success:^(id JSON) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic = [result objectForKey:@"response"];
        if (dic) {
            NSString *key = (NSString *)kCFBundleVersionKey;
            NSString *version = [NSBundle mainBundle].infoDictionary[key];
            NSString *current = [dic objectForKey:@"version"];
            if (![current isEqualToString:version]) {
                weakSelf.updateUrl = [dic objectForKey:@"url"];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"检测到新版本" message:nil delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"立即升级", nil];
                [alertView show];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


//自动登录
- (void)autoLogin
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"secret"]) {
            NSString *passWord = [[NSUserDefaults standardUserDefaults] objectForKey:@"secret"];
            
            NSDictionary *parms = [NSDictionary dictionaryWithObjectsAndKeys:userName,@"phonenum",passWord,@"password", nil];
            [HttpTool postWithPath:@"login" params:parms success:^(id JSON){
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
                NSDictionary *dic = [result objectForKey:@"response"];
                if (dic) {
                    NSString *code = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"code"] intValue]];
                    if ([code isEqualToString:@"100"]){
                        NSDictionary *data = [dic objectForKey:@"data"];
                        int company_id = [[data objectForKey:@"company_id"] intValue];
                        [self getVipInfo:[NSString stringWithFormat:@"%d",company_id] withData:data];
                    }
                }
            }failure:^(NSError *error){
                NSLog(@"%@",error);
            }];
        }
    }
}


//获取用户VIP信息
- (void)getVipInfo:(NSString *)company_id withData:(NSDictionary *)userData
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:company_id,@"company_id",nil];
    [HttpTool postWithPath:@"getCompanyVipInfo" params:params success:^(id JSON) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",result);
        NSDictionary *dic = [result objectForKey:@"response"];
        if (dic) {
            if (!isNull(result, @"response")) {
                if ([[dic objectForKey:@"code"] intValue] ==100) {
                    [SystemConfig sharedInstance].isUserLogin = YES;
                    if (isNull(userData, @"company_id")){
                        [SystemConfig sharedInstance].company_id = @"-1";
                    }else{
                        int company_id = [[userData objectForKey:@"company_id"] intValue];
                        [SystemConfig sharedInstance].company_id = [NSString stringWithFormat:@"%d",company_id];
                    }
                    if (isNull(userData, @"viptype")) {
                        [SystemConfig sharedInstance].viptype = @"-3";
                    }else{
                        NSInteger vipType = [[userData objectForKey:@"viptype"] intValue];
                        [SystemConfig sharedInstance].viptype = [NSString stringWithFormat:@"%ld",(long)vipType];
                    }
                    CompanyInfoItem *item = [[CompanyInfoItem alloc] initWithDictionary:userData];
                    [SystemConfig sharedInstance].companyInfo = item;

                    
                    NSDictionary *data = [dic objectForKey:@"data"];
                    VipInfoItem *vipInfo = [[VipInfoItem alloc] initWithDictionary:data];
                    [SystemConfig sharedInstance].vipInfo = vipInfo;
                }
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (self.updateUrl&&self.updateUrl.length!=0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateUrl]];
        }
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

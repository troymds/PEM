//
//  SettingController.m
//  PEM
//
//  Created by tianj on 14-8-26.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "SettingController.h"
#import "CompanySetController.h"
#import "AboutController.h"
#import "HttpTool.h"
#import "AdviceController.h"
#import "SystemConfig.h"
#import "LoginController.h"
#import "RemindView.h"

#define SET_TYPE 1000
#define ABOUT_TYPE 1001
#define UPPDATE_TYPE 1002
#define DELEDATE_TYPE 1003
#define FEEDBACK_TYPE 1004
#define LOGINBACK_TYPE 1005

@interface SettingController ()

@end

@implementation SettingController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = HexRGB(0xe6e6e6);
    self.title = @"设置";
    // Do any additional setup after loading the view.
    [self addView];
}

- (void)addView{
    
    UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 78)];
    bgView1.backgroundColor = HexRGB(0xffffff);
    [self.view addSubview:bgView1];
    for (int i = 1 ; i < 3; i++) {
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 39*i,kWidth, 0.5)];
        [bgView1 addSubview:lineView1];
        if (i == 1) {
            lineView1.backgroundColor = HexRGB(0xefeded);
        }else {
            lineView1.backgroundColor = HexRGB(0xcccccc);
            lineView1.frame = CGRectMake(0, 39*i, kWidth, 0.5);
        }
    }
    
    SetImageView *setView = [[SetImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 39)];
    setView.titleLabel.text = @"企业设置";
    setView.tag = SET_TYPE;
    setView.delegate = self;
    [bgView1 addSubview:setView];
    
    UIImageView *soreView1 = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth-36-7, 13, 7, 13)];
    soreView1.image =[UIImage imageNamed:@"next.png"];
    [setView addSubview:soreView1];
    
    
    SetImageView *aboutView = [[SetImageView alloc] initWithFrame:CGRectMake(0, 39, kWidth, 39)];
    aboutView.titleLabel.text = @"关于我们";
    aboutView.tag = ABOUT_TYPE;
    aboutView.delegate = self;
    [bgView1 addSubview:aboutView];
    
    UIImageView *soreView2 = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth-36-7, 13, 7, 13)];
    soreView2.image =[UIImage imageNamed:@"next.png"];
    [aboutView addSubview:soreView2];

    
    
    SetImageView *uppdateView = [[SetImageView alloc] initWithFrame:CGRectMake(0, 93, kWidth, 39)];
    uppdateView.titleLabel.text = @"检查更新";
    uppdateView.tag = UPPDATE_TYPE;
    uppdateView.delegate = self;
    uppdateView.backgroundColor = HexRGB(0xffffff);
    [self.view addSubview:uppdateView];
    for (int i = 0; i < 2; i++) {
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 39*i,kWidth, 0.5)];
        [bgView1 addSubview:lineView1];
        lineView1.backgroundColor = HexRGB(0xcccccc);
        [uppdateView addSubview:lineView1];
    }
    
    UIView *bgView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 147, kWidth, 78)];
    bgView2.backgroundColor = HexRGB(0xffffff);
    [self.view addSubview:bgView2];
    
    for (int i = 0 ; i < 3; i++){
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 39*i,kWidth, 0.5)];
        [bgView2 addSubview:lineView1];
        if (i == 1) {
            lineView1.backgroundColor = HexRGB(0xefeded);
        }else {
            lineView1.backgroundColor = HexRGB(0xcccccc);
            lineView1.frame = CGRectMake(0, 39*i, kWidth, 0.5);
        }
    }

    
    SetImageView *delView = [[SetImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 39)];
    delView.titleLabel.text = @"清除缓存";
    delView.tag = DELEDATE_TYPE;
    delView.delegate = self;
    [bgView2 addSubview:delView];
    
    
    SetImageView *feedbackView = [[SetImageView alloc] initWithFrame:CGRectMake(0, 39, kWidth, 39)];
    feedbackView.titleLabel.text = @"意见反馈";
    feedbackView.tag = FEEDBACK_TYPE;
    feedbackView.delegate = self;
    [bgView2 addSubview:feedbackView];
    
    UIImageView *soreView3 = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth-36-7, 13, 7, 13)];
    soreView3.image =[UIImage imageNamed:@"next.png"];
    [feedbackView addSubview:soreView3];

    
    SetImageView *loginbackView = [[SetImageView alloc] initWithFrame:CGRectMake(0, 240, kWidth, 39)];
    loginbackView.titleLabel.text = @"退出登录";
    loginbackView.backgroundColor = HexRGB(0xffffff);
    loginbackView.tag = LOGINBACK_TYPE;
    loginbackView.delegate = self;
    [self.view addSubview:loginbackView];
    
    for (int i = 0; i < 2; i++) {
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 39*i,kWidth, 0.5)];
        [bgView1 addSubview:lineView1];
        lineView1.backgroundColor = HexRGB(0xcccccc);
        [loginbackView addSubview:lineView1];
    }

    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adviceMessage) name:@"advice" object:nil];
}


- (void)adviceMessage{
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"感谢您的反馈";
        CGPoint center = CGPointMake(kWidth/2, kHeight/2);
        label.textColor = [UIColor blackColor];
        label.center = center;
        [[UIApplication sharedApplication].keyWindow addSubview:label];
        [UIView animateWithDuration:3.0 animations:^{
            label.alpha = 0;
        }];

}

- (void)imageClicked:(SetImageView *)imageView
{
    switch (imageView.tag) {
        case SET_TYPE:
        {
            CompanySetController *csc = [[CompanySetController alloc] init];
            csc.pushType = DERECT_SET_TYPE;
            [self.navigationController pushViewController:csc animated:YES];
        }
            break;
        case ABOUT_TYPE:
        {
            AboutController *aVC = [[AboutController alloc] init];
            [self.navigationController pushViewController:aVC animated:YES];
        }
            break;
        case UPPDATE_TYPE:
        {
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"ios",@"os", nil];
            [HttpTool postWithPath:@"getNewestVersion" params:param success:^(id JSON) {
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
                NSDictionary *dic = [result objectForKey:@"response"];
                if (dic) {
                    NSString *key = (NSString *)kCFBundleVersionKey;
                    NSString *version = [NSBundle mainBundle].infoDictionary[key];
                    NSString *current = [dic objectForKey:@"version_code"];
                    if ([current isEqualToString:version]) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"版本更新" message:@"您当前已是最新版本" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                        alertView.tag = 1000;
                        [alertView show];
                    }else{
                        _url = [dic objectForKey:@"url"];
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"检测到新版本" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即升级", nil];
                        alertView.tag = 1001;
                        [alertView show];
                    }
                }
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
            }];
        }
            break;
        case DELEDATE_TYPE:
        {
            dispatch_async(
                           dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                           , ^{
                               NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                               
                               NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                               NSLog(@"files :%lu",(unsigned long)[files count]);
                               for (NSString *p in files) {
                                   NSError *error;
                                   NSString *path = [cachPath stringByAppendingPathComponent:p];
                                   if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                                       [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                                   }
                               }
                               [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
                            }
                           );

        }
            break;
        case FEEDBACK_TYPE:
        {
            AdviceController *advice = [[AdviceController alloc] init];
            [self.navigationController pushViewController:advice animated:YES];
        }
            break;
        case LOGINBACK_TYPE:
        {
            MyActionSheetView *actionSheet = [[MyActionSheetView alloc] initWithTitle:@"温馨提示" withMessage:@"确定退出登录?" delegate:self cancleButton:@"取消" otherButton:@"确定"];
            [actionSheet showView];
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认退出当前账号?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认退出", nil];
//            alertView.tag = 1002;
//            [alertView show];
            
        }
            break;
        default:
            break;
    }
}

#pragma mark -MyActionSheet_delegate
- (void)actionSheetButtonClicked:(MyActionSheetView *)actionSheetView
{
    [SystemConfig sharedInstance].isUserLogin = NO;
    [SystemConfig sharedInstance].company_id = nil;
    [SystemConfig sharedInstance].viptype = nil;
    [SystemConfig sharedInstance].companyInfo = nil;
    [SystemConfig sharedInstance].vipInfo = nil;
    
    LoginController *login = [[LoginController alloc] init];
    NSArray *arr = self.navigationController.viewControllers;
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:arr];
    [array insertObject:login atIndex:1];
    self.navigationController.viewControllers = array;
    [self.navigationController popViewControllerAnimated:YES];

}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //版本更新
    openURL(_url);
}

-(void)clearCacheSuccess
{
    [RemindView showViewWithTitle:@"缓存已清空" location:MIDDLE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

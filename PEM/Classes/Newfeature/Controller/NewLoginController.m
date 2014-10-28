//
//  NewLoginController.m
//  PEM
//
//  Created by tianj on 14-10-28.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "NewLoginController.h"
#import "HttpTool.h"
#import "SystemConfig.h"
#import "PrivilegeController.h"
#import "RemindView.h"
#import "NewRegisterController.h"
#import "FindSecretController.h"
#import "CompanyInfoItem.h"
#import "VipInfoItem.h"
#import "UIBarButtonItem+MJ.h"
#import "MainController.h"


#define LOGIN_TYPE 3000
#define FIND_TYPE 3001
#define REGISTER_TYPE 3002


@interface NewLoginController ()

@end

@implementation NewLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    if (IsIos7) {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }
    self.title = @"登 录";
    self.view.backgroundColor = HexRGB(0xffffff);
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"nav_return.png" highlightedIcon:@"nav_return_pre.png" target:self action:@selector(backItem)];

    [self addView];

}

- (void)backItem
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)addView
{
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    [self.view addSubview:_bgView];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 211, 46)];
    image.center = CGPointMake(kWidth/2, 45);
    image.image = [UIImage imageNamed:@"logo.png"];
    [_bgView addSubview:image];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(25, 91, kWidth-25*2, 86)];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 6.0;
    bgView.layer.borderColor = HexRGB(0xced2d8).CGColor;
    bgView.layer.borderWidth = 1.0f;
    [_bgView addSubview:bgView];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, bgView.frame.size.width, 1)];
    lineView.backgroundColor = HexRGB(0xced2d8);
    [bgView addSubview:lineView];
    [self.view addSubview:bgView];
    
    UIImageView *userView = [[UIImageView alloc] initWithFrame:CGRectMake(13,10, 14, 23)];
    userView.image = [UIImage imageNamed:@"phone.png"];
    [bgView addSubview:userView];
    
    _userNameField = [[UITextField alloc] initWithFrame:CGRectMake(40, 0, kWidth-25*2-30, 43)];
    _userNameField.placeholder = @"请输入您的手机号";
    _userNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _userNameField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _userNameField.delegate = self;
    [bgView addSubview:_userNameField];
    
    UIImageView *passwordView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 53.5,17, 22)];
    passwordView.image = [UIImage imageNamed:@"regsiter_Password_btn.png"];
    [bgView addSubview:passwordView];
    
    
    _secretField = [[UITextField alloc] initWithFrame:CGRectMake(40, 43, kWidth-25*2-40, 43)];
    _secretField.placeholder = @"请输入密码";
    _secretField.secureTextEntry = YES;
    _secretField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _secretField.delegate = self;
    [bgView addSubview:_secretField];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
        _userNameField.text = userName;
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"secret"]) {
            NSString *secret = [[NSUserDefaults standardUserDefaults] objectForKey:@"secret"];
            _secretField.text = secret;
        }
    }
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame = CGRectMake(25, 200, kWidth-25*2, 35);
    [_loginBtn setBackgroundImage:[UIImage imageNamed:@"finish.png"] forState:UIControlStateNormal];
    [_loginBtn setBackgroundImage:[UIImage imageNamed:@"finish_pre.png"] forState:UIControlStateHighlighted];
    _loginBtn.tag = LOGIN_TYPE;
    [_loginBtn addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchUpInside];
    [_loginBtn setTitle:@"登  录" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:HexRGB(0xffffff) forState:UIControlStateNormal];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:PxFont(30)];
    
    [self.view addSubview:_loginBtn];
    
    UIButton *findBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    findBtn.frame = CGRectMake(25, 250, 80, 20);
    [findBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    [findBtn setTitleColor:HexRGB(0x666666) forState:UIControlStateNormal];
    findBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    findBtn.tag = FIND_TYPE;
    [findBtn addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:findBtn];
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(kWidth-80-25, 250, 80, 20);
    registerBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [registerBtn setTitle:@"免费注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:HexRGB(0x666666) forState:UIControlStateNormal];
    registerBtn.tag = REGISTER_TYPE;
    [registerBtn addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            [subView resignFirstResponder];
        }else{
            for (UIView  *view in subView.subviews) {
                if ([view isKindOfClass:[UITextField class]]) {
                    [view resignFirstResponder];
                }
            }
        }
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



- (void)buttonDown:(UIButton *)btn{
    if (btn.tag == LOGIN_TYPE) {
        if ([self checkOut]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"登录中...";
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:_userNameField.text,@"phonenum",_secretField.text,@"password", nil];
            [HttpTool postWithPath:@"login" params:params success:^(id JSON) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
                NSDictionary *dic = [result objectForKey:@"response"];
                if (dic) {
                    NSString *code = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"code"] intValue]];
                    if ([code isEqualToString:@"100"]){
                        
                        [[NSUserDefaults standardUserDefaults] setObject:_userNameField.text forKey:@"userName"];
                        [[NSUserDefaults standardUserDefaults] setObject:_secretField.text forKey:@"secret"];
                        
                        NSDictionary *data = [dic objectForKey:@"data"];
                        
                        [SystemConfig sharedInstance].isUserLogin = YES;
                        if (isNull(data, @"company_id")){
                            [SystemConfig sharedInstance].company_id = @"-1";
                        }else{
                            int company_id = [[data objectForKey:@"company_id"] intValue];
                            [SystemConfig sharedInstance].company_id = [NSString stringWithFormat:@"%d",company_id];
                        }
                        if (isNull(data, @"viptype")) {
                            [SystemConfig sharedInstance].viptype = @"-3";
                        }else{
                            NSInteger vipType = [[data objectForKey:@"viptype"] intValue];
                            [SystemConfig sharedInstance].viptype = [NSString stringWithFormat:@"%ld",(long)vipType];
                        }
                        
                        CompanyInfoItem *item = [[CompanyInfoItem alloc] initWithDictionary:data];
                        [SystemConfig sharedInstance].companyInfo = item;
                        
                        NSString *companyId = [NSString stringWithFormat:@"%d",[[data objectForKey:@"company_id"] intValue]];
                        
                        [self getVipInfo:companyId];
                        
                    }else{
                        [RemindView showViewWithTitle:@"用户名或密码错误" location:BELLOW];
                    }
                }
                
            } failure:^(NSError *error) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
                NSLog(@"%@",error);
            }];
            
        }
    }else if(btn.tag == FIND_TYPE){
        FindSecretController *findVC = [[FindSecretController alloc] init];
        [self.navigationController pushViewController:findVC animated:YES];
    }else{
        NewRegisterController *rc = [[NewRegisterController alloc] init];
        [self.navigationController pushViewController:rc animated:YES];
    }
}


- (void)getVipInfo:(NSString *)company_id
{
    //获取用户VIP信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"登录中...";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:company_id,@"company_id",nil];
    [HttpTool postWithPath:@"getCompanyVipInfo" params:params success:^(id JSON) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic = [result objectForKey:@"response"];
        if (dic) {
            if (!isNull(result, @"response")) {
                if ([[dic objectForKey:@"code"] intValue] ==100) {
                    NSDictionary *data = [dic objectForKey:@"data"];
                    VipInfoItem *vipInfo = [[VipInfoItem alloc] initWithDictionary:data];
                    [SystemConfig sharedInstance].vipInfo = vipInfo;
                    [UIApplication sharedApplication].statusBarHidden =NO;
                    self.view.window.rootViewController =[[MainController alloc]init];
                }else{
                    [UIApplication sharedApplication].statusBarHidden =NO;
                    self.view.window.rootViewController =[[MainController alloc]init];
                }
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
    }];
    
}

- (BOOL)checkOut{
    if (_userNameField.text.length==0){
        [RemindView showViewWithTitle:@"请输入手机号" location:BELLOW];
        return NO;
    }
    if (_secretField.text.length==0){
        [RemindView showViewWithTitle:@"请输入密码" location:BELLOW];
        
        return NO;
    }
    return YES;
}

- (void)loginBtnClicked:(UIViewController *)viewController
{
    [viewController.navigationController popToViewController:self animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

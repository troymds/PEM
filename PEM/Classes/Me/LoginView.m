//
//  loginView.m
//  PEM
//
//  Created by tianj on 14-8-29.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "loginView.h"
#import "RegisterContrller.h"
#import "FindSecretController.h"
#import "RemindView.h"
#import "HttpTool.h"


@implementation LoginView

- (id)init
{
    if (self = [super init]) {
        CGRect frame = [UIScreen mainScreen].bounds;
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        UIView *view = [[UIView alloc] initWithFrame:frame];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.5;
        [self addSubview:view];
        
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDown)];
        [view addGestureRecognizer:tap];
        
        bgView =[[UIImageView alloc] initWithFrame:CGRectMake((kWidth-275)/2,kHeight, 275, 250)];
        bgView.backgroundColor = HexRGB(0xffffff);
        bgView.userInteractionEnabled = YES;
        [self addSubview:bgView];
        tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [bgView addGestureRecognizer:tap1];
        
        UIImageView *userImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 27.5, 25, 23)];
        userImg.image = [UIImage imageNamed:@"regsiter_user_btn.png"];
        [bgView addSubview:userImg];
        
        _userField = [[UITextField alloc] initWithFrame:CGRectMake(60,27.5, 150, 23)];
        _userField.tag = USERNAME_TYPE;
        _userField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _userField.delegate = self;
        _userField.placeholder = @"请输入您的手机号";
        _userField.keyboardType = UIKeyboardTypePhonePad;
        [bgView addSubview:_userField];
        
        line1 = [[UIView alloc] initWithFrame:CGRectMake(10,64.5,bgView.frame.size.width-10*2, 0.5)];
        line1.backgroundColor = HexRGB(0x666666);
        [bgView addSubview:line1];
        
        UIImageView *secretImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 77.5, 25, 23)];
        secretImg.image = [UIImage imageNamed:@"regsiter_Password_btn.png"];
        [bgView addSubview:secretImg];
        
        _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(60,77.5, 150, 23)];
        _passwordField.placeholder = @"请输入您的密码";
        _passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _passwordField.tag = SECRET_TYPE;
        _passwordField.delegate =self;
        _passwordField.secureTextEntry = YES;
        [bgView addSubview:_passwordField];
        
        line2 = [[UIView alloc] initWithFrame:CGRectMake(10,114.5,bgView.frame.size.width-10*2, 0.5)];
        line2.backgroundColor = HexRGB(0x666666);
        [bgView addSubview:line2];
        
        
        loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        loginBtn.frame = CGRectMake(10, 145.5, 275-20, 35);
        loginBtn.tag = LOGIN_TYPE;
        [loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
        [loginBtn addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchUpInside];
        [loginBtn setBackgroundImage:[UIImage imageNamed:@"finish.png"] forState:UIControlStateNormal];
        [loginBtn setBackgroundImage:[UIImage imageNamed:@"finish_pre.png"] forState:UIControlStateHighlighted];
        [bgView addSubview:loginBtn];
        
        findBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        findBtn.frame = CGRectMake(bgView.frame.size.width/2-20-60, 210.5,60,20);
        findBtn.tag = FIND_TYPE;
        [findBtn addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchUpInside];
        [findBtn setTitle:@"寻找密码" forState:UIControlStateNormal];
        findBtn.titleLabel.font = [UIFont systemFontOfSize:PxFont(20)];
        [findBtn setTitleColor:HexRGB(0x666666) forState:UIControlStateNormal];
        [bgView addSubview:findBtn];
        
        registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        registerBtn.frame = CGRectMake(bgView.frame.size.width/2+20, 210.5, 60, 20);
        registerBtn.tag = REGIST_TYPE;
        
        UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 20)];
        line3.backgroundColor = HexRGB(0x666666);
        CGPoint center = CGPointMake(bgView.frame.size.width/2, 210.5+10);
        line3.center = center;
        [bgView addSubview:line3];
        
        [registerBtn addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchUpInside];
        [registerBtn setTitle:@"免费注册" forState:UIControlStateNormal];
        registerBtn.titleLabel.font = [UIFont systemFontOfSize:PxFont(20)];
        [registerBtn setTitleColor:HexRGB(0x666666) forState:UIControlStateNormal];
        [bgView addSubview:registerBtn];
        [self addSubview:bgView];
        
        [UIView animateWithDuration:0.3 animations:^{
            bgView.frame = CGRectMake((kWidth-275)/2,95, 275, 250);
        }];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        if ([user valueForKey:@"userName"]) {
            _userField.text = [user valueForKey:@"userName"];
            if ([user valueForKey:@"secret"]) {
                _passwordField.text = [user valueForKey:@"secret"];
            }
        }
        
    }
    return self;
}

-(void)tapDown
{
    if ([self.delegate respondsToSelector:@selector(tapDown)]) {
        [self.delegate tapDown];
    }
    [self dismissView];
}

- (void)tapClick
{
    for (UIView *subView in bgView.subviews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            [subView  resignFirstResponder];
            CGRect frame = bgView.frame;
            [UIView animateWithDuration:0.3 animations:^{
                bgView.frame = CGRectMake(frame.origin.x,95, frame.size.width, frame.size.height);
            }];
        }
    }
}


- (void)showView{
    if (bgView.frame.origin.y == kHeight) {
        [UIView animateWithDuration:0.3 animations:^{
            bgView.frame = CGRectMake((kWidth-275)/2,95, 275, 250);
        }];
    }
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
}

- (void)dismissView{
    [UIView animateWithDuration:0.3 animations:^{
        bgView.frame = CGRectMake((kWidth-275)/2,kHeight, 275, 250);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)buttonDown:(UIButton *)btn{
    if (self.delegate) {
        UIViewController *viewController = (UIViewController *)self.delegate;
        if (btn.tag==FIND_TYPE) {
            [self dismissView];
            FindSecretController *find = [[FindSecretController alloc] init];
            [viewController.navigationController pushViewController:find animated:YES];
        }
        if (btn.tag == REGIST_TYPE) {
            [self dismissView];
            RegisterContrller *regist = [[RegisterContrller alloc] init];
            [viewController.navigationController pushViewController:regist animated:YES];
        }
        if (btn.tag == LOGIN_TYPE) {
            [_userField resignFirstResponder];
            [_passwordField resignFirstResponder];
            if ([self checkData]) {
                [self login];
            }
        }
    }
}

- (void)login
{
    NSDictionary *parms = [NSDictionary dictionaryWithObjectsAndKeys:self.userField.text,@"phonenum",self.passwordField.text,@"password", nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.labelText = @"登录中...";
    [HttpTool postWithPath:@"login" params:parms success:^(id JSON){
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic = [result objectForKey:@"response"];
        if (dic) {
            NSString *code = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"code"] intValue]];
            if ([code isEqualToString:@"100"]){
                
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
                [self getVipInfo:[SystemConfig sharedInstance].company_id];
                
                [[NSUserDefaults standardUserDefaults] setObject:_userField.text forKey:@"userName"];
                [[NSUserDefaults standardUserDefaults] setObject:_passwordField.text forKey:@"secret"];
                
            }else{
                [RemindView showViewWithTitle:@"用户名或密码错误" location:MIDDLE];
                if (self.failBlock!=nil) {
                    self.failBlock();
                }
            }
        }
    }failure:^(NSError *error){
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
        if (self.failBlock!=nil) {
            self.failBlock();
        }
    }];
    
}

//获取用户VIP信息
- (void)getVipInfo:(NSString *)company_id
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.dimBackground = NO;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:company_id,@"company_id",nil];
    [HttpTool postWithPath:@"getCompanyVipInfo" params:params success:^(id JSON) {
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic = [result objectForKey:@"response"];
        if (dic) {
            if (!isNull(result, @"response")) {
                if ([[dic objectForKey:@"code"] intValue] ==100) {
                    NSDictionary *data = [dic objectForKey:@"data"];
                    VipInfoItem *vipInfo = [[VipInfoItem alloc] initWithDictionary:data];
                    [SystemConfig sharedInstance].vipInfo = vipInfo;
                    [self dismissView];
                }else{
                    [self dismissView];
                }
            }
        }
        if (self.sucessBlock!=nil) {
            self.sucessBlock();
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        NSLog(@"%@",error);
        if (self.sucessBlock!=nil) {
            self.sucessBlock();
        }
    }];
    
}

- (void)loginWithSuccess:(LoginSucessBlock)sucess fail:(LoginFailBlock)fail
{
    self.sucessBlock = sucess;
    self.failBlock = fail;
}


- (BOOL)checkData
{
    if (_userField.text.length==0) {
        [RemindView showViewWithTitle:@"请输入用户名" location:MIDDLE];
        return NO;
    }
    if (_passwordField.text.length == 0) {
        [RemindView showViewWithTitle:@"请输入密码" location:MIDDLE];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        bgView.frame = CGRectMake((kWidth-275)/2,95, 275, 250);
    }]; 
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (_iPhone4) {
        CGRect frame = bgView.frame;
        [UIView animateWithDuration:0.3 animations:^{
            bgView.frame = CGRectMake(frame.origin.x,55, frame.size.width, frame.size.height);
        }];
    }
    if (textField.tag == USERNAME_TYPE) {
        line1.backgroundColor = HexRGB(0x069dd4);
    }else{
        line2.backgroundColor = HexRGB(0x069dd4);
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == USERNAME_TYPE) {
        line1.backgroundColor = HexRGB(0x666666);
    }else{
        line2.backgroundColor = HexRGB(0x666666);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

//
//  loginView.m
//  PEM
//
//  Created by tianj on 14-8-29.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "loginView.h"


@implementation LoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        UIView *view = [[UIView alloc] initWithFrame:frame];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.5;
        [self addSubview:view];
        
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDown)];
        [view addGestureRecognizer:tap];
        
        bgView =[[UIImageView alloc] initWithFrame:CGRectMake((kWidth-275)/2,95, 275, 250)];
        bgView.backgroundColor = HexRGB(0xffffff);
        bgView.userInteractionEnabled = YES;
        [self addSubview:bgView];
        
        UIImageView *userImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 27.5, 25, 23)];
        userImg.image = [UIImage imageNamed:@"regsiter_user_btn.png"];
        [bgView addSubview:userImg];
        
        _userField = [[UITextField alloc] initWithFrame:CGRectMake(60,27.5, 150, 23)];
        _userField.tag = USERNAME_TYPE;

        _userField.delegate = self;
        _userField.placeholder = @"请输入您的手机号";
        [bgView addSubview:_userField];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(10,64.5,bgView.frame.size.width-10*2, 0.5)];
        line1.backgroundColor = HexRGB(0x666666);
        [bgView addSubview:line1];
        
        UIImageView *secretImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 77.5, 25, 23)];
        secretImg.image = [UIImage imageNamed:@"regsiter_Password_btn.png"];
        [bgView addSubview:secretImg];

        _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(60,77.5, 150, 23)];
        _passwordField.placeholder = @"请输入您的密码";
        _passwordField.tag = SECRET_TYPE;
        _passwordField.delegate =self;
        _passwordField.secureTextEntry = YES;
        [bgView addSubview:_passwordField];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(10,114.5,bgView.frame.size.width-10*2, 0.5)];
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


- (void)showView{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
}

- (void)dismissView{
    [self removeFromSuperview];
}

- (void)buttonDown:(UIButton *)btn{
    if (btn.tag == FIND_TYPE||btn.tag == REGIST_TYPE) {
        [self dismissView];
    }
    if ([self.delegate respondsToSelector:@selector(btnDown:)]) {
        [self.delegate btnDown:btn];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{

}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
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
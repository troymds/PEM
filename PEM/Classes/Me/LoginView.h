//
//  loginView.h
//  PEM
//
//  Created by tianj on 14-8-29.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LOGIN_TYPE 2000
#define FIND_TYPE 2001
#define REGIST_TYPE 2002
#define USERNAME_TYPE 5000
#define SECRET_TYPE 5001


@protocol LoginViewDelegate <NSObject>

@optional

- (void)btnDown:(UIButton *)btn;

- (void)tapDown;

@end

@interface LoginView : UIView<UITextFieldDelegate>
{
    UIImageView *bgView;
    UIButton *loginBtn;
    UIButton *findBtn;
    UIButton *registerBtn;
    UITapGestureRecognizer *tap;
    UITapGestureRecognizer *tap1;
    UIView *line1;
    UIView *line2;
}

typedef void(^LoginSucessBlock)(void);
typedef void(^LoginFailBlock)(void);


@property (nonatomic,strong) UITextField *userField;
@property (nonatomic,strong) UITextField *passwordField;

@property (nonatomic,weak) id<LoginViewDelegate> delegate;
@property (nonatomic,strong) LoginSucessBlock sucessBlock;
@property (nonatomic,strong) LoginFailBlock failBlock;

- (void)showView;

- (void)dismissView;

- (void)loginWithSuccess:(LoginSucessBlock)sucess fail:(LoginFailBlock)fail;

@end

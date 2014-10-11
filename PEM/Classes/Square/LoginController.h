//
//  LoginController.h
//  PEM
//
//  Created by tianj on 14-8-26.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginController : UIViewController<UITextFieldDelegate>
{
    UITextField *_userNameField;
    UITextField *_secretField;
    UIButton *_loginBtn;
    UIView *_bgView;
}

@property (nonatomic,copy) NSString *pushType;    //判断从哪里进入的登录页面
@end

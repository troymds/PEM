//
//  NewLoginController.h
//  PEM
//
//  Created by tianj on 14-10-28.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewLoginController : UIViewController<UITextFieldDelegate>
{
    UITextField *_userNameField;
    UITextField *_secretField;
    UIButton *_loginBtn;
    UIView *_bgView;
}

@end

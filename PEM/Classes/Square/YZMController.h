//
//  YZMController.h
//  PEM
//
//  Created by tianj on 14-9-1.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZMController : UIViewController<UITextFieldDelegate>
{
    UITextField *yzmField;
    UITextField *secretField;
    UIButton *getBtn;
    UIButton *playBtn;
    BOOL isPlay;
    UIButton *yzmBtn;
    NSString *yzmResult;
}

@property (nonatomic,copy) NSString *phoneNum;
@property (nonatomic,copy) NSString *pushType;

@end

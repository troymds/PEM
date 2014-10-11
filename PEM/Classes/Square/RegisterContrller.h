//
//  RegisterContrller.h
//  PEM
//
//  Created by tianj on 14-8-27.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterContrller : UIViewController<UITextFieldDelegate>
{
    UITextField *_phoneNumField;
}

@property (nonatomic,copy) NSString *pushType;

@end

//
//  PublishViewDelegate.h
//  PEM
//
//  Created by tianj on 14-8-25.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PublishViewDelegate <NSObject>
@optional

- (void)buttonDown:(UIButton *)btn;

- (void)textFieldBeganEditting:(UITextField *)textField;

- (void)textFieldEndEditting:(UITextField *)textField;

@end

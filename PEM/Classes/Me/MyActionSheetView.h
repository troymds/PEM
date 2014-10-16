//
//  MyActionSheetView.h
//  PEM
//
//  Created by tianj on 14-9-30.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyActionSheetView;
@protocol MyActionSheetViewDelegate <NSObject>

@optional

- (void)actionSheetButtonClicked:(MyActionSheetView *)actionSheetView;

@end

@interface MyActionSheetView : UIView
{
    UILabel *_titleLabel;
    UILabel *_messageLabel;
    UIButton *_cancelButton;
    UIButton *_otherButton;
//    UIView *bgView;
}

@property (nonatomic,weak) id <MyActionSheetViewDelegate> delegate;

- (id)initWithTitle:(NSString *)title withMessage:(NSString *)message delegate:(id)delegate cancleButton:(NSString *)cancelButton otherButton:(NSString *)otherButton;


- (void)showView;

@end

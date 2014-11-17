//
//  MyActionSheetView.h
//  PEM
//
//  Created by tianj on 14-9-30.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProAlertView;
@protocol ProAlertViewDelegate <NSObject>

@optional

- (void)proAclertView:(ProAlertView *)alertView clickButtonAtIndex:(NSInteger)index;

@end

@interface ProAlertView : UIView

@property (nonatomic,weak) id <ProAlertViewDelegate> delegate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *message;

- (id)initWithTitle:(NSString *)title withMessage:(NSString *)message delegate:(id)delegate cancleButton:(NSString *)cancelButtonTitle otherButton:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;


//- (id)initWithTitle:(NSString *)title withMessage:(NSString *)message delegate:(id)delegate cancleButton:(NSString *)cancelButton otherButton:(NSString *)otherButton;

- (void)show;

@end

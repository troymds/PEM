//
//  DescriptionController.h
//  PEM
//
//  Created by tianj on 14-8-21.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProImageView.h"
#import "SendValueDelegate.h"

@interface DescriptionController : UIViewController<UITextViewDelegate,ProImageViewDelegate>
{
    UITextView *_textView;
    UIButton *_button;
    ProImageView *_bgView;
    BOOL isEidt;
}

@property (nonatomic,assign) BOOL isSupply;
@property (nonatomic,strong) NSString *text;

@property (nonatomic,weak) id<SendValueDelegate> delegate;

@end

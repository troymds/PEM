//
//  MyActionSheetView.m
//  PEM
//
//  Created by tianj on 14-9-30.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "MyActionSheetView.h"
#import "AdaptationSize.h"

@implementation MyActionSheetView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTitle:(NSString *)title withMessage:(NSString *)message delegate:(id)delegate cancleButton:(NSString *)cancelButton otherButton:(NSString *)otherButton
{
    
    if (self = [super init]) {
        CGRect frame = [UIScreen mainScreen].bounds;
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        view = [[UIView alloc] initWithFrame:frame];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.0;
        [self addSubview:view];
        
        CGSize size = [AdaptationSize getSizeFromString:message Font:[UIFont systemFontOfSize:14] withHight:CGFLOAT_MAX withWidth:233];

        
        bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth-40,56+40+size.height+35)];
        bgView.backgroundColor = HexRGB(0xffffff);
        bgView.center = self.center;
        [self addSubview:bgView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 56,kWidth-40, 2)];
        lineView.backgroundColor = HexRGB(0x33b5e5);
        [bgView addSubview:lineView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 22,kWidth-40-40, 20)];
        _titleLabel.textColor = HexRGB(0x33b5e5);
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.text = title;
        [bgView addSubview:_titleLabel];

        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,76,kWidth-40-40,size.height)];
        _messageLabel.numberOfLines = 0;
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.font = [UIFont systemFontOfSize:14];
        _messageLabel.text = message;
        _messageLabel.textColor = HexRGB(0x565656);
        [bgView addSubview:_messageLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,bgView.frame.size.height-35,kWidth-40, 1)];
        line.backgroundColor = HexRGB(0xefeded);
        [bgView addSubview:line];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake((kWidth-40)/2,bgView.frame.size.height-35, 1, 35)];
        line1.backgroundColor = HexRGB(0xefeded);
        [bgView addSubview:line1];
        
        
        _otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_otherButton setTitle:otherButton forState:UIControlStateNormal];
        [_otherButton setTitleColor:HexRGB(0x000000) forState:UIControlStateNormal];
        _otherButton.tag = 0;
        [_otherButton addTarget:self action:@selector(actionButtonDown:) forControlEvents:UIControlEventTouchUpInside];
        _otherButton.frame = CGRectMake(0, bgView.frame.size.height-35,(kWidth-40)/2, 35);
        [bgView addSubview:_otherButton];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.tag = 1;
        [_cancelButton setTitle:cancelButton forState:UIControlStateNormal];
        [_cancelButton setTitleColor:HexRGB(0x000000) forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(actionButtonDown:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.frame = CGRectMake(273/2, bgView.frame.size.height-35,(kWidth-40)/2, 35);
        [bgView addSubview:_cancelButton];
        
        self.delegate = delegate;
        
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.1];
        [UIView setAnimationDelegate:self];
        view.alpha = 0.25;
        bgView.transform = CGAffineTransformScale([self transformForOrientation],0.7,0.7);;
        [UIView commitAnimations];
        [self performSelector:@selector(changeUI) withObject:nil afterDelay:0.1];
        
    }
    return self;
}

- (void)changeUI
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    view.alpha = 0.5;
    [UIView setAnimationDelegate:self];
    bgView.transform = CGAffineTransformScale([self transformForOrientation], 1.05, 1.05);;
    [UIView commitAnimations];
    [self performSelector:@selector(changeUI2) withObject:nil afterDelay:0.1];

}

- (void)changeUI2
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelegate:self];
    bgView.transform = CGAffineTransformScale([self transformForOrientation], 1.0, 1.0);;
    [UIView commitAnimations];
}


- (CGAffineTransform)transformForOrientation
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationLandscapeLeft == orientation)
    {
        return CGAffineTransformMakeRotation(M_PI*1.5);
    } else if (UIInterfaceOrientationLandscapeRight == orientation)
    {
        return CGAffineTransformMakeRotation(M_PI/2);
    } else if (UIInterfaceOrientationPortraitUpsideDown == orientation)
    {
        return CGAffineTransformMakeRotation(-M_PI);
    } else
    {
        return CGAffineTransformIdentity;
    }
}


- (void)actionButtonDown:(UIButton *)button
{
    if (button.tag == 0) {
        if ([self.delegate respondsToSelector:@selector(actionSheetButtonClicked:)]) {
            [self.delegate actionSheetButtonClicked:self];
        }
    }
    [self removeFromSuperview];
}

- (void)showView
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
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

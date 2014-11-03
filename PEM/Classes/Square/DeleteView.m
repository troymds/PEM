//
//  DeleteView.m
//  PEM
//
//  Created by tianj on 14-8-29.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "DeleteView.h"
#import "AdaptationSize.h"

#define DELETE_TYPE 4000
#define CANCEL_TYPE 4001

@implementation DeleteView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        CGRect frame = [[UIScreen mainScreen] bounds];
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        UIView *view = [[UIView alloc] initWithFrame:frame];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.5;
        [self addSubview:view];
        
        CGSize size = [AdaptationSize getSizeFromString:title Font:[UIFont systemFontOfSize:16] withHight:CGFLOAT_MAX withWidth:180];
        
        bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,200,20+size.height+70+1)];
        bgView.userInteractionEnabled = YES;
        bgView.center = self.center;
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10, 180, size.height)];
        titleLabel.numberOfLines = 0;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = title;
        [bgView addSubview:titleLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,20+size.height,200, 0.5)];
        line.backgroundColor = HexRGB(0x808080);
        [bgView addSubview:line];
        
        delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        delBtn.frame = CGRectMake(0,20+size.height,200,35);
        delBtn.tag = DELETE_TYPE;
        UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,60, 35)];
        title1.text=@"删除";
        title1.textColor = HexRGB(0x3a3a3a);
        title1.backgroundColor = [UIColor clearColor];
        [delBtn addSubview:title1];
        [delBtn setTitleColor:HexRGB(0x808080) forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:delBtn];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0,20+size.height+35,200, 0.5)];
        line1.backgroundColor = HexRGB(0x808080);
        [bgView addSubview:line1];

        cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0,20+size.height+35,200, 35);
        cancelBtn.tag = CANCEL_TYPE;
        cancelBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [cancelBtn setTitleColor:HexRGB(0x808080) forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:cancelBtn];
        
        UILabel *title2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,60, 35)];
        title2.text=@"取消";
        title2.textColor = HexRGB(0x3a3a3a);
        title2.backgroundColor = [UIColor clearColor];
        [cancelBtn addSubview:title2];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.1];
        [UIView setAnimationDelegate:self];
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


- (void)buttonDown:(UIButton *)btn{
    if (btn.tag == DELETE_TYPE) {
        if ([self.delegate respondsToSelector:@selector(buttonClicked:)]) {
            [self.delegate buttonClicked:btn];
        }
    }
    [self removeFromSuperview];
}

- (void)showView{
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

//
//  ProActionSheet.m
//  PEM
//
//  Created by tianj on 14-8-21.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "ProActionSheet.h"

@interface ProActionSheet ()
{
    UIButton *cancelBtn;
}
@end

@implementation ProActionSheet

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        UIView *view = [[UIView alloc] initWithFrame:frame];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.5;
        [self addSubview:view];
        CGRect mframe = [[UIScreen mainScreen] bounds];
        self.frame = mframe;
        cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.layer.masksToBounds = YES;
        cancelBtn.layer.cornerRadius = 5;
        cancelBtn.tag = 4002;
        cancelBtn.frame = CGRectMake(14,kHeight,kWidth-28, 45);
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"white_bg.png"] forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"white_bg_pre.png"] forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:HexRGB(0x1081fe) forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(14,kHeight,kWidth-28,90)];
        _bgView.backgroundColor = HexRGB(0xffffff);
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 5;
        [self addSubview:_bgView];
        UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        photoBtn.frame = CGRectMake(0, 0, kWidth-28, 45);
        photoBtn.tag = 4000;
        [photoBtn setBackgroundImage:[UIImage imageNamed:@"white_bg.png"] forState:UIControlStateNormal];
        [photoBtn setBackgroundImage:[UIImage imageNamed:@"white_bg_pre.png"] forState:UIControlStateNormal];
        [photoBtn setTitle:@"从相册中选取" forState:UIControlStateNormal];
        [photoBtn setTitleColor:HexRGB(0x1081fe) forState:UIControlStateNormal];
        [photoBtn addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:photoBtn];
        
        UIButton *takePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        takePhotoBtn.frame = CGRectMake(0,45, kWidth-28, 45);
        takePhotoBtn.tag = 4001;
        [takePhotoBtn setBackgroundImage:[UIImage imageNamed:@"white_bg.png"] forState:UIControlStateNormal];
        [takePhotoBtn setBackgroundImage:[UIImage imageNamed:@"white_bg_pre.png"] forState:UIControlStateNormal];
        [takePhotoBtn addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchUpInside];
        [takePhotoBtn setTitle:@"拍照" forState:UIControlStateNormal];
        [takePhotoBtn setTitleColor:HexRGB(0x1081fe) forState:UIControlStateNormal];
        [_bgView addSubview:takePhotoBtn];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 45, kWidth-28, 1)];
        line.backgroundColor = HexRGB(0xc3c3c7);
        [_bgView addSubview:line];
    }
    return self;
}

- (void)buttonDown:(UIButton*)btn{
    if ([self.delegate respondsToSelector:@selector(buttonClicked:)]) {
        [self.delegate buttonClicked:btn];
    }
    [self dismissView];
}

- (void)dismissView{
    [UIView animateWithDuration:0.3 animations:^{
        cancelBtn.frame = CGRectMake(14, kHeight,kWidth-28, 45);
        _bgView.frame = CGRectMake(14, kHeight,kWidth-28, 90);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)showView{
    [UIView animateWithDuration:0.3 animations:^{
        cancelBtn.frame = CGRectMake(14, kHeight-14-45,kWidth-28, 45);
        _bgView.frame = CGRectMake(14,kHeight-28-45-90,kWidth-28, 90);
    }];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code ```````
}
*/

@end

//
//  ProActionSheet.m
//  PEM
//
//  Created by tianj on 14-8-21.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "ProActionSheet.h"

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
        NSArray *arr = [NSArray arrayWithObjects:@"从相册选取",@"拍照",@"取消", nil];
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0,mframe.size.height, mframe.size.width, 200)];
        _bgView.backgroundColor = HexRGB(0xffffff);
        [self addSubview:_bgView];
        NSInteger space = (200-35*3)/(3+1);
        for (int i = 0; i< 3; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(40, space+(space+35)*i, mframe.size.width-40*2, 35);
            [btn setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"finish.png"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"finish_pre.png"] forState:UIControlStateHighlighted];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag =4000+i;
            [_bgView addSubview:btn];
        }
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
    CGRect frame = [[UIScreen mainScreen] bounds];
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.frame =CGRectMake(0, frame.size.height, frame.size.width, 200);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



- (void)showView{
    CGRect frame = [[UIScreen mainScreen] bounds];
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.frame = CGRectMake(0, frame.size.height-200, frame.size.width, 200);
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

//
//  DeleteView.m
//  PEM
//
//  Created by tianj on 14-8-29.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "DeleteView.h"

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
        bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 171, 91)];
        bgView.userInteractionEnabled = YES;
        bgView.center = self.center;
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,18, 171, 20)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = title;
        titleLabel.textColor = HexRGB(0x3a3a3a);
        [bgView addSubview:titleLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 40, 150, 0.4)];
        line.backgroundColor = HexRGB(0x808080);
        [bgView addSubview:line];
        
        delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        delBtn.frame = CGRectMake(20, 49, 55, 24);
        delBtn.tag = DELETE_TYPE;
        [delBtn setTitle:@"删除" forState:UIControlStateNormal];
        [delBtn setTitleColor:HexRGB(0xffffff) forState:UIControlStateNormal];
        [delBtn setBackgroundImage:[UIImage imageNamed:@"home_login.png"] forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:delBtn];
        
        cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(95, 49, 55, 24);
        cancelBtn.tag = CANCEL_TYPE;
        [cancelBtn setTitleColor:HexRGB(0xffffff) forState:UIControlStateNormal];
        cancelBtn.backgroundColor = [UIColor grayColor];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:cancelBtn];
    }
    return self;
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

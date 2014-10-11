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
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = title;
        titleLabel.textColor = HexRGB(0x3a3a3a);
        [bgView addSubview:titleLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,20+size.height,200, 0.5)];
        line.backgroundColor = HexRGB(0x808080);
        [bgView addSubview:line];
        
        delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        delBtn.frame = CGRectMake(0,20+size.height,200,35);
        delBtn.tag = DELETE_TYPE;
        [delBtn setTitle:@"删除" forState:UIControlStateNormal];
        [delBtn setTitleColor:HexRGB(0x808080) forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:delBtn];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0,20+size.height+35,200, 0.5)];
        line1.backgroundColor = HexRGB(0x808080);
        [bgView addSubview:line1];

        cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0,20+size.height+35,200, 35);
        cancelBtn.tag = CANCEL_TYPE;
        [cancelBtn setTitleColor:HexRGB(0x808080) forState:UIControlStateNormal];
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

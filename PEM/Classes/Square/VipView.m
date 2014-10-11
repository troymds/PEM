//
//  VipView.m
//  PEM
//
//  Created by tianj on 14-9-5.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "VipView.h"

@implementation VipView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        NSInteger space = 17;
        NSArray *array = [NSArray arrayWithObjects:@"享受普通会员全部特权",@"发布企业求购信息/供应信息",@"可一键拨打电话咨询产品详细情况",@"可订阅23标签，精确推送相关求购信息", nil];
        for (int i = 0; i < [array count]; i++) {
            NSString *text = [array objectAtIndex:i];
            CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(CGFLOAT_MAX, 31) lineBreakMode:NSLineBreakByCharWrapping];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 17+(31+space)*i,size.width+20, 31)];
            label.textColor = HexRGB(0x666666);
            label.text = text;
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.borderColor = HexRGB(0xd4d9db).CGColor;
            label.layer.borderWidth = 1.0f;
            [self addSubview:label];
        }
        _upGradeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _upGradeBtn.frame = CGRectMake(16, 209,239, 35);
        _upGradeBtn.tag = VIP_TYPE;
        [_upGradeBtn addTarget:self action:@selector(vipBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_upGradeBtn setTitle:@"立即升级" forState:UIControlStateNormal];
        [_upGradeBtn setBackgroundImage:[UIImage imageNamed:@"finish.png"] forState:UIControlStateNormal];
        [_upGradeBtn setBackgroundImage:[UIImage imageNamed:@"finish_pre.png"] forState:UIControlStateHighlighted];
        [self addSubview:_upGradeBtn];

    }
    return self;
}

- (void)vipBtnClicked:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(privilegeBtnDown:)]) {
        [self.delegate privilegeBtnDown:btn];
    }

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

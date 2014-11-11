//
//  SecondCateView.m
//  PEM
//
//  Created by tianj on 14-11-11.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "SecondCateView.h"

@implementation SecondCateView



- (id)initWithArray:(NSArray *)array
{
    if (self = [super init]) {
        NSInteger width = kWidth/3;
        for (int i = 0 ; i < array.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake((i%3)*width,25+(i/3)*(20+28), width, 20);
            button.tag = 1000+i;
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        NSInteger row = [array count]%3==0? array.count/3:array.count/3+1;
        self.frame = CGRectMake(0, 0,kWidth,50+row*20+(row-1)*28);
    }
    return self;
}

- (void)buttonClicked:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(secondCateClicked:)]) {
        [self.delegate secondCateClicked:btn.tag-1000];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

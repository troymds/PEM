//
//  ProLabel.m
//  PEM
//
//  Created by tianj on 14-10-16.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "ProLabel.h"

@implementation ProLabel



- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(proLabelClick:)]) {
        [self.delegate proLabelClick:self];
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

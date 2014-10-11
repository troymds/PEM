//
//  SetImageView.m
//  PEM
//
//  Created by tianj on 14-8-28.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "SetImageView.h"

@implementation SetImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,10, 100, 20)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = HexRGB(0x666666);
        [self addSubview:_titleLabel];
        self.backgroundColor = [UIColor clearColor];

    }
    return self;
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

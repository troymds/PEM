//
//  CellView.m
//  PEM
//
//  Created by tianj on 14-8-25.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "CellView.h"

@implementation CellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,50, frame.size.height)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = HexRGB(0x666666);
        _nameLabel.font = [UIFont systemFontOfSize:PxFont(20)];
        [self addSubview:_nameLabel];
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(50, (frame.size.height-20)/2, 1, 20)];
        _lineView.backgroundColor = HexRGB(0x666666);
        [self addSubview:_lineView];
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

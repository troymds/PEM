//
//  SetAreaView.m
//  PEM
//
//  Created by tianj on 14-9-24.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "SetAreaView.h"

@implementation SetAreaView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10, 70, 20)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:PxFont(22)];
        _titleLabel.textColor = HexRGB(0x666666);
        [self addSubview:_titleLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(80, 10, 1, 20)];
        line.backgroundColor = HexRGB(0x666666);
        [self addSubview:line];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10,frame.size.width-90-10, 20)];
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.textColor = HexRGB(0x808080);
        _contentLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentLabel];

        
        _areaBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _areaBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:_areaBtn];

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

//
//  PriHeadView.m
//  PEM
//
//  Created by tianj on 14-9-5.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "PriHeadView.h"

@implementation PriHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _bgView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_bgView];
        _iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 80, 80)];
        _iconImg.layer.masksToBounds = YES;
        _iconImg.layer.cornerRadius = 40;
        [self addSubview:_iconImg];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 30, 200, 20)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = HexRGB(0x3a3a3a);
        [self addSubview:_nameLabel];
        
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 62, 160, 20)];
        _typeLabel.backgroundColor = [UIColor clearColor];
        _typeLabel.textColor = HexRGB(0x3a3a3a);
        [self addSubview:_typeLabel];
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

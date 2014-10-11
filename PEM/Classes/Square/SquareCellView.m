//
//  SquareCellView.m
//  PEM
//
//  Created by tianj on 14-8-27.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "SquareCellView.h"
#import "ProImageView.h"

@implementation SquareCellView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(30,11, 17, 17)];
        [self addSubview:_imgView];
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 11, 100, 17)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = HexRGB(0x666666);
        _nameLabel.font = [UIFont systemFontOfSize:PxFont(24)];
        [self addSubview:_nameLabel];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-36-7, 13, 7, 13)];
        img.image = [UIImage imageNamed:@"next.png"];
        [self addSubview:img];
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

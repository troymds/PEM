//
//  PriImageView.m
//  PEM
//
//  Created by tianj on 14-9-5.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "PriImageView.h"

@implementation PriImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        selectedView = [[UIView alloc] initWithFrame:self.bounds];
        selectedView.backgroundColor = HexRGB(0xffffff);
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, frame.size.height)];
        lineView.backgroundColor = HexRGB(0xe83428);
        [selectedView addSubview:lineView];
        selectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(4,20, 52, 20)];
        selectedLabel.backgroundColor = [UIColor clearColor];
        selectedLabel.font = [UIFont systemFontOfSize:PxFont(16)];
        selectedLabel.textAlignment = NSTextAlignmentCenter;
        selectedLabel.textColor = HexRGB(0xe83428);
        [selectedView addSubview:selectedLabel];
        
        
        nomalView = [[UIView alloc] initWithFrame:self.bounds];
        nomalView.backgroundColor = HexRGB(0xe0e0e0);
        nomalLabel = [[UILabel alloc] initWithFrame:CGRectMake(4,20, 52, 20)];
        nomalLabel.backgroundColor = [UIColor clearColor];
        nomalLabel.textAlignment = NSTextAlignmentCenter;
        nomalLabel.font = [UIFont systemFontOfSize:PxFont(16)];
        nomalLabel.textColor = HexRGB(0x3a3a3a);
        [nomalView addSubview:nomalLabel];
        [self addSubview:nomalView];
        [self addSubview:selectedView];
        
        selectedView.hidden = YES;
    }
    return self;
}


- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (_isSelected) {
        selectedView.hidden = NO;
        nomalView.hidden = YES;
    }else{
        selectedView.hidden = YES;
        nomalView.hidden = NO;
    }
}


- (void)setVipName:(NSString *)name
{
    nomalLabel.text = name;
    selectedLabel.text = name;
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

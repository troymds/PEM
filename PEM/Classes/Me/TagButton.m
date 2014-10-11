//
//  TagButton.m
//  PEM
//
//  Created by tianj on 14-9-4.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "TagButton.h"

@implementation TagButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setIsSelected:NO];
    }
    return self;
}


- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (_isSelected) {
        [self setBorderColor:HexRGB(0x31add9) TextColor:HexRGB(0x31add9)];
    }else{
        [self setBorderColor:[UIColor grayColor] TextColor:[UIColor grayColor]];
    }
}

- (void)setBorderColor:(UIColor *)borderColor TextColor:(UIColor *)textColor{
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = 1.0f;
    [self setTitleColor:textColor forState:UIControlStateNormal];
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

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
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, frame.size.height)];
        lineView.backgroundColor = HexRGB(0xe83428);
        [selectedView addSubview:lineView];
        
        selectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 50, 52, 20)];
        selectedLabel.backgroundColor = [UIColor clearColor];
        selectedLabel.font = [UIFont systemFontOfSize:PxFont(16)];
        selectedLabel.textAlignment = NSTextAlignmentCenter;
        selectedLabel.textColor = HexRGB(0xe83428);
        [selectedView addSubview:selectedLabel];
        
        selectedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 20, 30, 30)];
        [selectedView addSubview:selectedImageView];
        
        nomalView = [[UIView alloc] initWithFrame:self.bounds];
        nomalView.backgroundColor = HexRGB(0xe0e0e0);
        nomalLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 50, 52, 20)];
        nomalLabel.backgroundColor = [UIColor clearColor];
        nomalLabel.textAlignment = NSTextAlignmentCenter;
        nomalLabel.font = [UIFont systemFontOfSize:PxFont(16)];
        nomalLabel.textColor = HexRGB(0x3a3a3a);
        [nomalView addSubview:nomalLabel];

        nomalImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 20, 30, 30)];
        [nomalView addSubview:nomalImageView];
        
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


- (void)setIconNomalImg:(UIImage *)nomalImg selectedImg:(UIImage *)seletedImg withTitle:(NSString *)title{
    nomalImageView.image = nomalImg;
    selectedImageView.image = seletedImg;
    nomalLabel.text = title;
    selectedLabel.text = title;
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

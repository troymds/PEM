//
//  RegionCell.m
//  PEM
//
//  Created by Tianj on 14/11/9.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "RegionCell.h"

@implementation RegionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef content = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(content, HexRGB(0xd5d5d5).CGColor);
    CGContextStrokeRect(content, CGRectMake(0,rect.size.height, rect.size.width, 1));
}

@end

//
//  ExtendCell.m
//  PEM
//
//  Created by Tianj on 14/11/11.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "ExtendCell.h"

@implementation ExtendCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat width = (kWidth-4)/3;
        _img1 = [[ProImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        [self.contentView addSubview:_img1];
        _img2 = [[ProImageView alloc] initWithFrame:CGRectMake(width+2,0, width, width)];
        [self.contentView addSubview:_img2];
        _img3 = [[ProImageView alloc] initWithFrame:CGRectMake(width*2+4,0, width, width)];
        [self.contentView addSubview:_img3];
        _extendView = [[UIView alloc] initWithFrame:CGRectMake(0, _img1.frame.origin.y+_img1.frame.size.height, kWidth,0)];
        [self.contentView addSubview:_extendView];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

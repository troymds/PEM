//
//  SelectImgCell.m
//  PEM
//
//  Created by tianj on 14-11-10.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "SelectImgCell.h"

@implementation SelectImgCell

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

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

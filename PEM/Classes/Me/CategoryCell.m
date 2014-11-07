//
//  CategoryCell.m
//  PEM
//
//  Created by tianj on 14-11-6.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "CategoryCell.h"

@implementation CategoryCell

- (void)awakeFromNib {
    // Initialization code
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(18,9, 57, 57)];
        [self addSubview:_iconImg];
        _TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30+57, 18, 100,20)];
        _TitleLabel.textColor = HexRGB(0x3a3a3a);
        _TitleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_TitleLabel];
        
        _desLabel = [[UILabel alloc] initWithFrame:CGRectMake(30+57, 51,100,15)];
        _desLabel.backgroundColor = [UIColor clearColor];
        _desLabel.textColor = HexRGB(0x808080);
        [self addSubview:_desLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  SupplyCell.m
//  PEM
//
//  Created by tianj on 14-8-27.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "SupplyCell.h"

@implementation SupplyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,13,59,59)];
        [self.contentView addSubview:_iconImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(98, 13, 200, 20)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = HexRGB(0x3a3a3a);
        [self.contentView addSubview:_nameLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(98,35, 150, 20)];
        _priceLabel.backgroundColor = [UIColor clearColor];
        _priceLabel.textColor = HexRGB(0xff7300);
        _priceLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_priceLabel];
        
        _standardLabel = [[UILabel alloc] initWithFrame:CGRectMake(98,57, 100, 15)];
        _standardLabel.backgroundColor = [UIColor clearColor];
        _standardLabel.font = [UIFont  systemFontOfSize:12];
        _standardLabel.textColor = HexRGB(0x808080);
        [self.contentView addSubview:_standardLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth-40-150,57, 150, 15)];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = HexRGB(0x808080);
        [self.contentView addSubview:_timeLabel];
        
        _resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth-40-60, 35, 60,20)];
        _resultLabel.backgroundColor = [UIColor clearColor];
        _resultLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_resultLabel];
        
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

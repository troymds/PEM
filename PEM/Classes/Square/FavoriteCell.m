//
//  FavoriteCell.m
//  PEM
//
//  Created by tianj on 14-8-28.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "FavoriteCell.h"

@implementation FavoriteCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        CGFloat width = self.frame.size.width;
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 74, 74)];
        [self.contentView addSubview:_iconImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, width-100-20, 40)];
        _nameLabel.numberOfLines = 2;
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = HexRGB(0x3a3a3a);
        [self.contentView addSubview:_nameLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 55, 100, 15)];
        _priceLabel.backgroundColor = [UIColor clearColor];
        _priceLabel.textColor = HexRGB(0xff7300);
        _priceLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_priceLabel];
        
        _timesLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 55, 200, 15)];
        _timesLabel.backgroundColor = [UIColor clearColor];
        _timesLabel.textColor = HexRGB(0x808080);
        _timesLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_timesLabel];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 75, 150, 15)];
        _dateLabel.textColor = HexRGB(0x808080);
        _dateLabel.font = [UIFont systemFontOfSize:12];
        _dateLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_dateLabel];
        

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

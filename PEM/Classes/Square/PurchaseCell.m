//
//  PurchaseCell.m
//  PEM
//
//  Created by tianj on 14-8-28.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "PurchaseCell.h"

@implementation PurchaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,10,250, 20)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = HexRGB(0x3a3a3a);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_nameLabel];
        
        _visitLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 35, 100, 15)];
        _visitLabel.backgroundColor = [UIColor clearColor];
        _visitLabel.textColor = HexRGB(0x808080);
        _visitLabel.font = [UIFont systemFontOfSize:12];
        _visitLabel.textAlignment  = NSTextAlignmentLeft;
        [self.contentView addSubview:_visitLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth-40-150, 35, 150, 15)];
        _timeLabel.backgroundColor =[UIColor clearColor];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = HexRGB(0x808080);
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_timeLabel];
        
        _resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth-40-60,10,60,20)];
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

//
//  DialRecordCell.m
//  PEM
//
//  Created by tianj on 14-8-29.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "DialRecordCell.h"

@implementation DialRecordCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20,kWidth-20-20-37-20, 20)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_titleLabel];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,75-20-10,100,20)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textColor = HexRGB(0x808080);
        [self.contentView addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth-20-37-20-120,75-20-10, 120, 20)];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = HexRGB(0x808080);
        [self.contentView addSubview:_timeLabel];
        
        _dialBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dialBtn setBackgroundImage:[UIImage imageNamed:@"dial_btn.png"] forState:UIControlStateNormal];
        _dialBtn.frame = CGRectMake(kWidth-20-37, 19, 37, 37);
        [self.contentView addSubview:_dialBtn];
        

        
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

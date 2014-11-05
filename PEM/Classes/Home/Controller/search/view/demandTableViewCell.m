//
//  demandTableViewCell.m
//  PEM
//
//  Created by YY on 14-9-4.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "demandTableViewCell.h"

@implementation demandTableViewCell
@synthesize nameLabel,read_numLabel,IntroductionLabel,dateLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 180, 20)];
        dateLabel.font =[UIFont systemFontOfSize:PxFont(14)];
        [self addSubview:dateLabel];
        dateLabel.backgroundColor =[UIColor clearColor];
        
        read_numLabel = [[UILabel alloc] initWithFrame:CGRectMake(245, 10, 80, 20)];
        read_numLabel.font =[UIFont systemFontOfSize:PxFont(14)];
        [self addSubview:read_numLabel];
        read_numLabel.backgroundColor =[UIColor clearColor];


        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 280, 20)];
        nameLabel.textColor =HexRGB(0x3a3a3a);
        nameLabel.font =[UIFont systemFontOfSize:PxFont(20)];
        [self addSubview:nameLabel];
        nameLabel.backgroundColor =[UIColor clearColor];

        
        IntroductionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 42, 280, 50)];
        IntroductionLabel.numberOfLines = 2;
        IntroductionLabel.font =[UIFont systemFontOfSize:PxFont(16)];
        [self addSubview:IntroductionLabel];
        IntroductionLabel.backgroundColor =[UIColor clearColor];

        
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

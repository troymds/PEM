//
//  conditionTableViewCell.m
//  PEM
//
//  Created by YY on 14-9-10.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "conditionTableViewCell.h"

@implementation conditionTableViewCell
@synthesize TitleLabel,contentLabel,dateLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        TitleLabel=[[UILabel alloc]init];
        [self addSubview:TitleLabel];
        TitleLabel.text=@"浙江省信用和棕色开往大得多";
        TitleLabel.frame =CGRectMake(20, 0, 200, 30);
        TitleLabel.font =[UIFont systemFontOfSize:PxFont(20)];
        TitleLabel.backgroundColor =[UIColor clearColor];

        dateLabel=[[UILabel alloc]init];
        [self addSubview:dateLabel];
        dateLabel.text =@"09-10";
        dateLabel.frame =CGRectMake(232, 0, 120, 30);
        dateLabel.font =[UIFont systemFontOfSize:PxFont(14)];
        dateLabel.textColor=HexRGB(0x666666);
        dateLabel.backgroundColor =[UIColor clearColor];


        contentLabel=[[UILabel alloc]init];
        [self addSubview:contentLabel];
        contentLabel.text =@"浙大得多公司与浙江省信色开往大得多";
        contentLabel.numberOfLines = 2;
        contentLabel.frame =CGRectMake(20, 25, 280, 40);
        contentLabel.font =[UIFont systemFontOfSize:PxFont(17)];
        contentLabel.textColor=HexRGB(0x666666);
        contentLabel.backgroundColor =[UIColor clearColor];

        
        
        
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

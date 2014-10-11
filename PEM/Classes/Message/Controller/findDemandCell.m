//
//  findDemandCell.m
//  PEM
//
//  Created by YY on 14-9-11.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "findDemandCell.h"

@implementation findDemandCell
@synthesize nameLabel,read_numLabel,dateLabel,contentLabel,demand_numLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 180, 20)];
        nameLabel.text = @"产品产品产品产品";
        nameLabel.font =[UIFont systemFontOfSize:PxFont(20)];
        [self addSubview:nameLabel];
        
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 10, 180, 20)];
        dateLabel.text = @"09-11";
        dateLabel.font =[UIFont systemFontOfSize:PxFont(14)];
        [self addSubview:dateLabel];
        dateLabel.textColor=HexRGB(0x666666);
        

        
        demand_numLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 180, 20)];
        demand_numLabel.text = @"￥123";
        demand_numLabel.textColor=HexRGB(0xff7300);
        demand_numLabel.font =[UIFont systemFontOfSize:PxFont(22)];
        [self addSubview:demand_numLabel];
        
        
        
        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 200, 20)];
        contentLabel.text = @"供应商:普而摩网络技术有限公司";
        [self addSubview:contentLabel];
        contentLabel.font =[UIFont systemFontOfSize:PxFont(16)];
        contentLabel.textColor=HexRGB(0x666666);
        
        
        read_numLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 50, 180, 20)];
        read_numLabel.text = @"浏览1205次";
        [self addSubview:read_numLabel];
        read_numLabel.font =[UIFont systemFontOfSize:PxFont(14)];
        read_numLabel.textColor=HexRGB(0x666666);

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

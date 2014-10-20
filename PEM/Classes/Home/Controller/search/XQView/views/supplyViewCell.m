//
//  supplyViewCell.m
//  PEM
//
//  Created by YY on 14-9-10.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "supplyViewCell.h"

@implementation supplyViewCell
@synthesize supply_numLabel,nameLabel,priceLabel,supplyImage,read_numLabel,dateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        supplyImage = [[UIImageView alloc] initWithFrame:CGRectMake(14, 10, 62, 62)];
        supplyImage.image =[UIImage imageNamed:@"ad1.png"];
        //这里的self 指的是某一个单元格对象
        [self.contentView addSubview:supplyImage];
        
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 7, 160, 20)];
        nameLabel.text = @"产品产品产品产品";
        nameLabel.font =[UIFont systemFontOfSize:PxFont(22)];
        [self.contentView addSubview:nameLabel];
        
        dateLabel= [[UILabel alloc] initWithFrame:CGRectMake(250, 7, 60, 40)];
        dateLabel.text = @"09-10";
        dateLabel.numberOfLines = 1;
        dateLabel.textColor=HexRGB(0x666666);

        dateLabel.font =[UIFont systemFontOfSize:PxFont(14)];
        [self.contentView addSubview:dateLabel];
        
        
        priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 24, 180, 25)];
        priceLabel.text = @"￥330";
        priceLabel.textColor=HexRGB(0xff7300);
        priceLabel.font =[UIFont systemFontOfSize:PxFont(22)];
        [self.contentView addSubview:priceLabel];
        
        
        
        
        supply_numLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 43, 180, 20)];
        supply_numLabel.text = @"浏览量123次";
        supply_numLabel.font =[UIFont systemFontOfSize:PxFont(17)];
        [self.contentView addSubview:supply_numLabel];
        supply_numLabel.textColor=HexRGB(0x666666);

        
        read_numLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 60, 180, 20)];
        read_numLabel.text = @"10件批发期";
        [self.contentView addSubview:read_numLabel];
        read_numLabel.font =[UIFont systemFontOfSize:PxFont(17)];
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

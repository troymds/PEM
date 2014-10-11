//
//  findSupplyCel.m
//  PEM
//
//  Created by YY on 14-9-11.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "findSupplyCel.h"

@implementation findSupplyCel
@synthesize supplyImage,priceLabel,read_numLabel,companyLabel,nameLabel,supply_numLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        supplyImage = [[UIImageView alloc] initWithFrame:CGRectMake(26, 13, 43, 43)];
        supplyImage.image =[UIImage imageNamed:@"ad1.png"];
        [self addSubview:supplyImage];
        
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 10, 180, 20)];
        nameLabel.text = @"产品产品产品产品";
        nameLabel.font =[UIFont systemFontOfSize:PxFont(22)];
        [self addSubview:nameLabel];
        nameLabel.textColor=HexRGB(0x666666);

        
        
        priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 30, 100, 20)];
        priceLabel.text = @"￥123";
        priceLabel.textColor=HexRGB(0xff7300);
        priceLabel.font =[UIFont systemFontOfSize:PxFont(22)];
        [self addSubview:priceLabel];
        
        supply_numLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 30, 100, 20)];
        supply_numLabel.text = @"10起条供应";
        supply_numLabel.font =[UIFont systemFontOfSize:PxFont(14)];
        [self addSubview:supply_numLabel];
        supply_numLabel.textColor=HexRGB(0x666666);

        
        companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 48, 180, 20)];
        companyLabel.text = @"供应商:普而摩网络技术有限公司";
        [self addSubview:companyLabel];
        companyLabel.font =[UIFont systemFontOfSize:PxFont(14)];
        companyLabel.textColor=HexRGB(0x666666);


        read_numLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 48, 180, 20)];
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

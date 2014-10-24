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
        
        supplyImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        supplyImage.image =[UIImage imageNamed:@""];
        [self addSubview:supplyImage];
        
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 10, 240, 20)];
        nameLabel.text = @"";
        nameLabel.font =[UIFont systemFontOfSize:PxFont(20)];
        [self addSubview:nameLabel];
        nameLabel.textColor=[UIColor blackColor];

        
        
        priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 30, 110, 20)];
        priceLabel.text = @"";
        priceLabel.textColor=HexRGB(0xff7300);
        priceLabel.font =[UIFont systemFontOfSize:PxFont(22)];
        [self addSubview:priceLabel];
        
        supply_numLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 30, 100, 20)];
        supply_numLabel.text = @"";
        supply_numLabel.font =[UIFont systemFontOfSize:PxFont(14)];
        [self addSubview:supply_numLabel];
        supply_numLabel.textColor=HexRGB(0x666666);

        
        companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 48, 190, 20)];
        companyLabel.text = @"";
        [self addSubview:companyLabel];
        companyLabel.font =[UIFont systemFontOfSize:PxFont(14)];
        companyLabel.textColor=HexRGB(0x666666);


        read_numLabel = [[UILabel alloc] initWithFrame:CGRectMake(255, 48, 180, 20)];
        read_numLabel.text = @"";
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

//
//  supplyTableViewCell.m
//  PEM
//
//  Created by YY on 14-9-4.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "supplyTableViewCell.h"
#import "supplyTool.h"
#import "yySupplyModel.h"
@implementation supplyTableViewCell

@synthesize supply_numLabel,nameLabel,companyLabel,priceLabel,supplyImage,read_numLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        supplyImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 92, 67)];
        [self addSubview:supplyImage];
        
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 200, 20)];
        nameLabel.backgroundColor =[UIColor clearColor];
        nameLabel.font =[UIFont systemFontOfSize:PxFont(20)];
        [self addSubview:nameLabel];
        
        
        priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 30, 200, 20)];
        priceLabel.textColor=HexRGB(0xff0000);
        priceLabel.font =[UIFont systemFontOfSize:PxFont(17)];
        [self addSubview:priceLabel];
        priceLabel.backgroundColor =[UIColor clearColor];

        
       
        
        supply_numLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 47, 90, 20)];
        supply_numLabel.font =[UIFont systemFontOfSize:PxFont(14)];
        [self addSubview:supply_numLabel];
        supply_numLabel.backgroundColor =[UIColor clearColor];

        read_numLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 47, 90, 20)];
        [self addSubview:read_numLabel];
        read_numLabel.font =[UIFont systemFontOfSize:PxFont(14)];
        read_numLabel.backgroundColor =[UIColor clearColor];
        read_numLabel.textAlignment =NSTextAlignmentRight;


        
        companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 63, 200, 20)];
        [self addSubview:companyLabel];
        companyLabel.font =[UIFont systemFontOfSize:PxFont(14)];
        companyLabel.backgroundColor =[UIColor clearColor];

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

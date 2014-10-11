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

        supplyImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 13, 92, 67)];
        supplyImage.image =[UIImage imageNamed:@"ad1.png"];
        //这里的self 指的是某一个单元格对象
        [self addSubview:supplyImage];
        
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 10, 180, 20)];
        nameLabel.text = @"产品产品产品产品";
        nameLabel.font =[UIFont systemFontOfSize:PxFont(20)];
        [self addSubview:nameLabel];
        
        
        priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 26, 180, 20)];
        priceLabel.text = @"价格";
        priceLabel.textColor=HexRGB(0xff0000);
        priceLabel.font =[UIFont systemFontOfSize:PxFont(17)];
        [self addSubview:priceLabel];
        
        
       
        
        supply_numLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 40, 180, 20)];
        supply_numLabel.text = @"起购";
        supply_numLabel.font =[UIFont systemFontOfSize:PxFont(14)];
        [self addSubview:supply_numLabel];
        
        read_numLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 52, 180, 20)];
        read_numLabel.text = @"查看";
        [self addSubview:read_numLabel];
        read_numLabel.font =[UIFont systemFontOfSize:PxFont(14)];


        
        companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 65, 180, 20)];
        companyLabel.text = @"公司";
        [self addSubview:companyLabel];
        companyLabel.font =[UIFont systemFontOfSize:PxFont(14)];

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

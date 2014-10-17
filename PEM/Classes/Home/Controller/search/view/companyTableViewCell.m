//
//  companyTableViewCell.m
//  PEM
//
//  Created by YY on 14-9-4.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "companyTableViewCell.h"

@implementation companyTableViewCell
@synthesize nameLabel,regionLabel,imageCompany,businessLabel,vipType;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        imageCompany = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 60, 60)];
        imageCompany.image =[UIImage imageNamed:@"ad1.png"];
        [self addSubview:imageCompany];
        vipType = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 60, 60)];
        vipType.image =[UIImage imageNamed:@"ad1.png"];
        [self addSubview:imageCompany];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 10, 195, 20)];
        nameLabel.text = @"产品产品产品产品";
        nameLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        [self addSubview:nameLabel];
        
        vipType = [[UIImageView alloc] initWithFrame:CGRectMake(280, 11, 13, 18)];
        vipType.image =[UIImage imageNamed:@"Vip1.png"];
        [self addSubview:vipType];

        regionLabel = [[UILabel alloc] initWithFrame:CGRectMake(265, 10, 42, 20)];
        regionLabel.text = @"江苏";
        regionLabel.numberOfLines = 0;
        regionLabel.font =[UIFont systemFontOfSize:PxFont(14)];
        [self addSubview:regionLabel];
        
        
        
        businessLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, 230, 40)];
        businessLabel.text = @"产品产品产品";
        businessLabel.numberOfLines = 0;
        businessLabel.font =[UIFont systemFontOfSize:PxFont(16)];
        [self addSubview:businessLabel];
        
     
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

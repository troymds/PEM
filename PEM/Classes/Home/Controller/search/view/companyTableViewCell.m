//
//  companyTableViewCell.m
//  PEM
//
//  Created by YY on 14-9-4.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "companyTableViewCell.h"

@implementation companyTableViewCell
@synthesize nameLabel,regionLabel,imageCompany,businessLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        imageCompany = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 60, 60)];
        imageCompany.image =[UIImage imageNamed:@"ad1.png"];
        //这里的self 指的是某一个单元格对象
        [self addSubview:imageCompany];
        
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 10, 195, 20)];
        nameLabel.text = @"产品产品产品产品";
        nameLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        [self addSubview:nameLabel];
        
        
        regionLabel = [[UILabel alloc] initWithFrame:CGRectMake(265, 10, 42, 20)];
        regionLabel.text = @"江苏";
        regionLabel.numberOfLines = 0;
        regionLabel.font =[UIFont systemFontOfSize:PxFont(14)];
        [self addSubview:regionLabel];
        regionLabel.lineBreakMode=UILineBreakModeClip;
        
        
        
        businessLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, 230, 40)];
        businessLabel.text = @"起购产品产品产品产品产品产品产品产品产品产品产品产品产品产品产品产品产品产品产品产品产品产品产品产品产品产品产品产品产品产品产品产品产品产品产品产品";
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

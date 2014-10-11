//
//  FavoriteCell.h
//  PEM
//
//  Created by tianj on 14-8-28.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteCell : UITableViewCell

@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UILabel *timesLabel;
@property (nonatomic,strong) UILabel *dateLabel;

@end

//
//  HeaderView.h
//  PEM
//
//  Created by tianj on 14-8-26.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProImageView.h"
#import "ProLabel.h"

@protocol HeaderViewDelegate <NSObject>

@optional

- (void)buttonClick:(UIButton *)btn;

@end

@interface HeaderView : UIView



@property (nonatomic,strong) UIImageView *bgView;
@property (nonatomic,strong) ProImageView *headerImage;
@property (nonatomic,strong) UIButton *registerBtn;
@property (nonatomic,strong) ProLabel *nameLabel;
@property (nonatomic,strong) UILabel *supplayLabel;
@property (nonatomic,strong) UILabel *purchaseLabel;
@property (nonatomic,strong) UILabel *favoriteLabel;
@property (nonatomic,strong) UILabel *messageLabel;
@property (nonatomic,strong) UIImageView *markImg;
@property (nonatomic,strong) UILabel *experienceLabel;

@property (nonatomic,weak) id <HeaderViewDelegate> delegate;

- (void)setName:(NSString *)name;

@end

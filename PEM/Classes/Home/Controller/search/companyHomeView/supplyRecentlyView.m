//
//  supplyRecentlyView.m
//  PEM
//
//  Created by promo on 14-10-28.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "supplyRecentlyView.h"
#import "comPanyModel.h"
#import "UIImage+MJ.h"

#define KsmallIconWH  20
#define KSpace 10
#define KTimeW 60

@interface supplyRecentlyView()
{
    UIImageView * _smallIcon;     //小图标
    UILabel * _titleLabel;       // 公司信息
    UILabel * _timeLabel;       //时间
    
}

@end

@implementation supplyRecentlyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat startX = 20;
        CGFloat startY = 3;
        _smallIcon = [[UIImageView alloc] init];
        _smallIcon.frame = CGRectMake(startX, startY+5, 12, 12);
        [self addSubview:_smallIcon];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = CGRectMake(startX + KsmallIconWH + KSpace, startY, 200, KsmallIconWH);
        _titleLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        [_titleLabel setTextColor:HexRGB(0x808080)] ;
        [self addSubview:_titleLabel];
        
        _timeLabel = [[UILabel alloc] init];
        CGFloat timeX = kWidth - KTimeW - KSpace;
        _timeLabel.frame =CGRectMake (timeX,startY,KTimeW,KsmallIconWH);
        _timeLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        _timeLabel.textColor =HexRGB(0x808080);
        _timeLabel.textAlignment  = NSTextAlignmentCenter;
        [self addSubview:_timeLabel];
        
        UIView *lin =[[UIView alloc]init];
        lin.frame = CGRectMake(0, frame.size.height -1 , kWidth, 1);
        lin.backgroundColor =HexRGB(0xe6e3e4);
        lin.alpha = 0.5;
        [self addSubview:lin];
    }
    return self;
}

- (void)setData:(comPanyModel *)data
{
    _data = data;
    if ([_data.type isEqualToString:@"1"]) {
        _smallIcon.image = [UIImage imageNamed:@"company1.png"];
//        _smallIcon.image = [UIImage resizedImage:@"company1.png"];
    }else
    {
        _smallIcon.image = [UIImage imageNamed:@"company2.png"];
    }
    
    _titleLabel.text = _data.name;
    _timeLabel.text = _data.time;
    
}
@end

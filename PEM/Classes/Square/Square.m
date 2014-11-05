//
//  Square.m
//  PEM
//
//  Created by tianj on 14-8-27.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "Square.h"

@implementation Square

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0,0, kWidth, 117)];
        bgView1.backgroundColor = HexRGB(0xffffff);
        bgView1.userInteractionEnabled = YES;
        [self addSubview:bgView1];
        for (int i = 1; i < 4; i++){
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39*i, kWidth, 0.5)];
            [bgView1 addSubview:line];
            if (i==3) {
                line.backgroundColor = HexRGB(0xcccccc);
            }else{
                line.backgroundColor = HexRGB(0xefeded);
            }
        }
        
        _mySupplyView = [[SquareCellView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 39)];
        _mySupplyView.nameLabel.text = @"我的供应";
        _mySupplyView.tag = SUPPLY_TYPE;
        _mySupplyView.imgView.image = [UIImage imageNamed:@"supply.png"];
        [_mySupplyView addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
        [bgView1 addSubview:_mySupplyView];
        
        _myPurchaseView = [[SquareCellView alloc] initWithFrame:CGRectMake(0, 39, kWidth, 39)];
        _myPurchaseView.nameLabel.text = @"我的求购";
        _myPurchaseView.tag = PURCHASE_TYPE;
        _myPurchaseView.imgView.image = [UIImage imageNamed:@"purchase.png"];
        [_myPurchaseView addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
        [bgView1 addSubview:_myPurchaseView];
        
        _myFavoriteView = [[SquareCellView alloc] initWithFrame:CGRectMake(0, 78, kWidth, 39)];
        _myFavoriteView.nameLabel.text = @"我的收藏";
        _myFavoriteView.tag = FAVORITE_TYPE;
        _myFavoriteView.imgView.image = [UIImage imageNamed:@"favorite.png"];
        [_myFavoriteView addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
        [bgView1 addSubview:_myFavoriteView];
        
        UIView *bgView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 132, kWidth, 117)];
        bgView2.backgroundColor = HexRGB(0xffffff);
        [self addSubview:bgView2];
        
        for (int i = 0; i < 4; i++){
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39*i, kWidth, 0.5)];
            [bgView2 addSubview:line];
            if (i==0||i==3) {
                line.backgroundColor = HexRGB(0xcccccc);
            }else{
                line.backgroundColor = HexRGB(0xefeded);
            }
        }

        _mySubscriptionView = [[SquareCellView alloc] initWithFrame:CGRectMake(0,0, kWidth, 39)];
        _mySubscriptionView.nameLabel.text = @"我的订阅";
        _mySubscriptionView.tag = SUBSCRIPE_TYPE;
        _mySubscriptionView.imgView.image = [UIImage imageNamed:@"subscription.png"];
        [_mySubscriptionView addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
        [bgView2 addSubview:_mySubscriptionView];
        
        _myPrivilegeView = [[SquareCellView alloc] initWithFrame:CGRectMake(0,39, kWidth, 39)];
        _myPrivilegeView.nameLabel.text = @"我的特权";
        _myPrivilegeView.tag = PRIVILEGE_TYPE;
        _myPrivilegeView.imgView.image = [UIImage imageNamed:@"privilege.png"];
        [_myPrivilegeView addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
        [bgView2 addSubview:_myPrivilegeView];
        
        _dialRecordView = [[SquareCellView alloc] initWithFrame:CGRectMake(0, 78, kWidth, 39)];
        _dialRecordView.nameLabel.text = @"拨号记录";
        _dialRecordView.tag = DIALRECORD_TYPE;
        _dialRecordView.imgView.image = [UIImage imageNamed:@"dial.png"];
        [_dialRecordView addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
        [bgView2 addSubview:_dialRecordView];
        
        UIView *bgView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 264, kWidth, 117)];
        bgView3.backgroundColor = HexRGB(0xffffff);
        [self addSubview:bgView3];
        
        for (int i = 0; i < 4; i++) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39*i, kWidth, 0.5)];
            [bgView3 addSubview:line];
            if (i==0||i==3) {
                line.backgroundColor = HexRGB(0xcccccc);
            }else{
                line.backgroundColor = HexRGB(0xefeded);
            }
        }

        _setView = [[SquareCellView alloc] initWithFrame:CGRectMake(0,39, kWidth, 39)];
        _setView.nameLabel.text = @"设置";
        _setView.tag = SET_TYPE;
        _setView.imgView.image = [UIImage imageNamed:@"setting.png"];
        [_setView addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
        [bgView3 addSubview:_setView];
        
        _infoView = [[SquareCellView alloc] initWithFrame:CGRectMake(0,0, kWidth,39)];
        _infoView.nameLabel.text = @"企业资料";
        _infoView.tag = INFO_TYPE;
        _infoView.imgView.image = [UIImage imageNamed:@"companyInfo.png"];
        [_infoView addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
        [bgView3 addSubview:_infoView];
        
        _shareView = [[SquareCellView alloc] initWithFrame:CGRectMake(0,78, kWidth, 39)];
        _shareView.nameLabel.text = @"分享";
        _shareView.tag = SHARE_TYPE;
        _shareView.imgView.image = [UIImage imageNamed:@"share.png"];
        [_shareView addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
        [bgView3 addSubview:_shareView];

     }
    return self;
}


- (void)btnDown:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(buttonClicked:)]) {
        [self.delegate buttonClicked:btn];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

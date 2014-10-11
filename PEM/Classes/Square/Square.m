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
        CGRect rect = CGRectMake(0, 0, kWidth, 39);
        _mySupplyView.nameLabel.text = @"我的供应";
        _mySupplyView.nameLabel.font = [UIFont systemFontOfSize:16];

        _mySupplyView.imgView.image = [UIImage imageNamed:@"supply.png"];
        
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = rect;
        btn1.tag  = SUPPLY_TYPE;
        btn1.backgroundColor = [UIColor clearColor];
        [btn1 addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
        [_mySupplyView addSubview:btn1];
        [bgView1 addSubview:_mySupplyView];
        
        _myPurchaseView = [[SquareCellView alloc] initWithFrame:CGRectMake(0, 39, kWidth, 39)];
        _myPurchaseView.nameLabel.text = @"我的求购";
        _myPurchaseView.nameLabel.font = [UIFont systemFontOfSize:16];

        _myPurchaseView.imgView.image = [UIImage imageNamed:@"purchase.png"];

        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame = rect;
        btn2.tag  = PURCHASE_TYPE;
        btn2.backgroundColor = [UIColor clearColor];
        [btn2 addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
        [_myPurchaseView addSubview:btn2];
        [bgView1 addSubview:_myPurchaseView];
        
        _myFavoriteView = [[SquareCellView alloc] initWithFrame:CGRectMake(0, 78, kWidth, 39)];
        _myFavoriteView.nameLabel.text = @"我的收藏";
        _myFavoriteView.nameLabel.font = [UIFont systemFontOfSize:16];

        _myFavoriteView.imgView.image = [UIImage imageNamed:@"favorite.png"];

        UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn3.frame = rect;
        btn3.tag  = FAVORITE_TYPE;
        btn3.backgroundColor = [UIColor clearColor];
        [btn3 addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
        [_myFavoriteView addSubview:btn3];
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
        _mySubscriptionView.nameLabel.font = [UIFont systemFontOfSize:16];

        _mySubscriptionView.imgView.image = [UIImage imageNamed:@"subscription.png"];

        UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn4.frame = rect;
        btn4.tag  = SUBSCRIPE_TYPE;
        btn4.backgroundColor = [UIColor clearColor];
        [btn4 addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
        [_mySubscriptionView addSubview:btn4];
        [bgView2 addSubview:_mySubscriptionView];
        
        _myPrivilegeView = [[SquareCellView alloc] initWithFrame:CGRectMake(0,39, kWidth, 39)];
        _myPrivilegeView.nameLabel.text = @"我的特权";
        _myPrivilegeView.nameLabel.font = [UIFont systemFontOfSize:16];

        _myPrivilegeView.imgView.image = [UIImage imageNamed:@"privilege.png"];

        UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn5.frame = rect;
        btn5.tag  = PRIVILEGE_TYPE;
        btn5.backgroundColor = [UIColor clearColor];
        [btn5 addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
        [_myPrivilegeView addSubview:btn5];
        [bgView2 addSubview:_myPrivilegeView];
        
        _dialRecordView = [[SquareCellView alloc] initWithFrame:CGRectMake(0, 78, kWidth, 39)];
        _dialRecordView.nameLabel.text = @"拨号记录";
        _dialRecordView.nameLabel.font = [UIFont systemFontOfSize:16];

        _dialRecordView.imgView.image = [UIImage imageNamed:@"dial.png"];

        UIButton *btn6 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn6.frame = rect;
        btn6.tag  = DIALRECORD_TYPE;
        btn6.backgroundColor = [UIColor clearColor];
        [btn6 addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
        [_dialRecordView addSubview:btn6];
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
        _setView.nameLabel.font = [UIFont systemFontOfSize:16];
        _setView.imgView.image = [UIImage imageNamed:@"setting.png"];

        UIButton *btn7 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn7.frame = rect;
        btn7.tag  = SET_TYPE;
        btn7.backgroundColor = [UIColor clearColor];
        [btn7 addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
        [_setView addSubview:btn7];
        [bgView3 addSubview:_setView];
        
        _infoView = [[SquareCellView alloc] initWithFrame:CGRectMake(0,0, kWidth,39)];
        _infoView.nameLabel.text = @"企业资料";
        _infoView.nameLabel.font = [UIFont systemFontOfSize:16];
        _infoView.imgView.image = [UIImage imageNamed:@"companyInfo.png"];

        UIButton *btn8 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn8.frame = rect;
        btn8.tag  = INFO_TYPE;
        btn8.backgroundColor = [UIColor clearColor];
        [btn8 addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
        [_infoView addSubview:btn8];
        [bgView3 addSubview:_infoView];
        
        _shareView = [[SquareCellView alloc] initWithFrame:CGRectMake(0,78, kWidth, 39)];
        _shareView.nameLabel.text = @"分享";
        _shareView.nameLabel.font = [UIFont systemFontOfSize:16];
        _shareView.imgView.image = [UIImage imageNamed:@"share.png"];
        
        UIButton *btn9 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn9.frame = rect;
        btn9.tag  = SHARE_TYPE;
        btn9.backgroundColor = [UIColor clearColor];
        [btn9 addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
        [_shareView addSubview:btn9];
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

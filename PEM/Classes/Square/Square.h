//
//  Square.h
//  PEM
//
//  Created by tianj on 14-8-27.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SquareCellView.h"
#define SUPPLY_TYPE 1000
#define PURCHASE_TYPE 1001
#define FAVORITE_TYPE 1002
#define SUBSCRIPE_TYPE 1003
#define PRIVILEGE_TYPE 1004
#define DIALRECORD_TYPE 1005
#define SET_TYPE 1006
#define INFO_TYPE 1007
#define SHARE_TYPE 1008


@protocol SquareDelegate <NSObject>

@optional
- (void)buttonClicked:(UIButton *)btn;

@end

@interface Square : UIView

@property (nonatomic,strong) SquareCellView *mySupplyView;
@property (nonatomic,strong) SquareCellView *myPurchaseView;
@property (nonatomic,strong) SquareCellView *myFavoriteView;
@property (nonatomic,strong) SquareCellView *mySubscriptionView;
@property (nonatomic,strong) SquareCellView *myPrivilegeView;
@property (nonatomic,strong) SquareCellView *dialRecordView;
@property (nonatomic,strong) SquareCellView *setView;
@property (nonatomic,strong) SquareCellView *infoView;
@property (nonatomic,strong) SquareCellView *shareView;

@property (nonatomic,weak) id<SquareDelegate> delegate;

@end

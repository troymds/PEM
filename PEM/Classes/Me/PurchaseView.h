//
//  PurchaseView.h
//  PEM
//
//  Created by tianj on 14-8-25.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CellView.h"
#import "PublishViewDelegate.h"
#import "PurchaseItem.h"


#define PC_TITLE_TYPE 100
#define PC_LINKMAN_TYPE 101
#define PC_PHONENUM_TYPE 102
#define PC_PURCHASE_TYPE 103
#define PC_UNIT_TYPE 104


@interface PurchaseView : UIView<UITextFieldDelegate>
{
    UITapGestureRecognizer *tap;
}

@property (nonatomic,strong) CellView *categoryView;
@property (nonatomic,strong) CellView *titleView;
@property (nonatomic,strong) CellView *descriptionView;
@property (nonatomic,strong) CellView *linkmanView;
@property (nonatomic,strong) CellView *phoneNumView;
@property (nonatomic,strong) CellView *markView;
@property (nonatomic,strong) CellView *purchaseNum;
@property (nonatomic,strong) CellView *unitView;
@property (nonatomic,strong) UILabel *categoryLabel;
@property (nonatomic,strong) UILabel *descriptionLabel;
@property (nonatomic,strong) UILabel *markLabel;
@property (nonatomic,strong) UITextField *titleTextField;
@property (nonatomic,strong) UITextField *linkManTextField;
@property (nonatomic,strong) UITextField *phoneNumTextField;
@property (nonatomic,strong) UITextField *purchaseNumField;
@property (nonatomic,strong) UITextField *unitField;


@property (nonatomic,weak) id<PublishViewDelegate> delegate;


@end

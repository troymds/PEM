//
//  SupplyView.h
//  PEM
//
//  Created by tianj on 14-8-22.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellView.h"
#import "PublishViewDelegate.h"
#import "SupplyItem.h"
#import "ProImageView.h"

#define PRICE_TYPE 0
#define TITLE_TYPE 1
#define STANDARD_TYPE 2
#define LINKMAN_TYPE 3
#define PHONENUM_TYPE 4
#define UNIT_TYPE 5

@interface SupplyView : UIView<UITextFieldDelegate>
{
    
}
@property (nonatomic,strong) CellView *categoryView;
@property (nonatomic,strong) CellView *areaView;
@property (nonatomic,strong) CellView *priceView;
@property (nonatomic,strong) CellView *imageView;
@property (nonatomic,strong) CellView *descriptionView;
@property (nonatomic,strong) CellView *titleView;
@property (nonatomic,strong) CellView *standardView;
@property (nonatomic,strong) CellView *linkmanView;
@property (nonatomic,strong) CellView *phoneNumView;
@property (nonatomic,strong) CellView *unitView;
@property (nonatomic,strong) UILabel *categoryLabel;
@property (nonatomic,strong) UILabel *areaLabel;
@property (nonatomic,strong) UILabel *descriptionLabel;
@property (nonatomic,strong) UITextField *priceTextField;
@property (nonatomic,strong) UITextField *titleTextField;
@property (nonatomic,strong) UITextField *standardTextField;
@property (nonatomic,strong) UITextField *linkManTextField;
@property (nonatomic,strong) UITextField *phoneNumTextField;
@property (nonatomic,strong) UITextField *unitField;
@property (nonatomic,strong) ProImageView *headImage;
@property (nonatomic,strong) UIButton *publishBtn;
@property (nonatomic,strong) UIView *remindView;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,assign) BOOL  isHide;            //是否显示3D提醒内容
@property (nonatomic,assign) BOOL isExistImg;         //是否存在图片



@property (nonatomic,weak) id<PublishViewDelegate> delegate;


- (void)reloadView;

@end

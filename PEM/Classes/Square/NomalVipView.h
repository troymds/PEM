//
//  NomalVipView.h
//  PEM
//
//  Created by tianj on 14-9-5.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrivilegeViewDelegete.h"


@interface NomalVipView : UIView<PrivilegeViewDelegete>

    

@property (nonatomic,strong) UIButton *upGradeBtn;
@property (nonatomic,weak) id <PrivilegeViewDelegete> delegate;


@end

//
//  CompanyInfoController.h
//  PEM
//
//  Created by tianj on 14-8-29.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoCellView.h"

@interface CompanyInfoController : UIViewController
{
    UIImageView *_iconImage;
    UILabel *_nameLabel;
    UILabel *_regionLabel;
    UILabel *_vipTypeLabel;
    InfoCellView *_regionView;
    InfoCellView *_websiteView;
    InfoCellView *_emailView;
    InfoCellView *_phoneView;
}
@end

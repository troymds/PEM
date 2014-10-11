//
//  companyTableViewCell.h
//  PEM
//
//  Created by YY on 14-9-4.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface companyTableViewCell : UITableViewCell
@property (nonatomic, strong)UILabel *nameLabel;//公司名称
@property (nonatomic, strong)UILabel *regionLabel;//地区
@property (nonatomic, strong)UIImageView *imageCompany;//图片

@property (nonatomic, strong)UILabel *businessLabel;//内容
@end

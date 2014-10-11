//
//  supplyTableViewCell.h
//  PEM
//
//  Created by YY on 14-9-4.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface supplyTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *supplyImage;//图片
@property (nonatomic, strong)UILabel *nameLabel;//产品名称
@property (nonatomic, strong)UILabel *companyLabel;//公司名称
@property (nonatomic, strong)UILabel *read_numLabel;//查看次数

@property (nonatomic, strong)UILabel *priceLabel;//价格
@property (nonatomic, strong)UILabel *supply_numLabel;//起购标准

@end

//
//  CompanyMenuItem.h
//  PEM
//
//  Created by promo on 14-10-23.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    KTopMenuCompannyHome = 0, //首页
    kTopMenyDynamic,          //动态
    KTopMenuSupply,           //供求
}TopEenuType;

@interface CompanyMenuItem : UIButton
//设置文字
@property (nonatomic, strong) NSString * title;
@property (assign, nonatomic) TopEenuType currentType;
@property (assign, nonatomic)int btnTag;
@end

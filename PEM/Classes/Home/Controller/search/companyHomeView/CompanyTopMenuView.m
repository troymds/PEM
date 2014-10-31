//
//  CompanyTopMenuView.m
//  PEM
//
//  Created by promo on 14-10-23.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "CompanyTopMenuView.h"
#import "CompanyMenuItem.h"

@interface CompanyTopMenuView()
{
    CompanyMenuItem *_companyHomeItem; //公司首页item
    CompanyMenuItem *_companyDynamicItem; //企业动态item
    CompanyMenuItem *_companySupplyItem; // 供求信息item
    
    CompanyMenuItem *_selectedItem; //选中的item
    
    
}

@end

@implementation CompanyTopMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HexRGB(0xe1e9e9);
     _companyHomeItem =     [self addMenuItem :@"公司首页" index: 0];
     _companyDynamicItem =  [self addMenuItem:@"企业动态" index:1];
     _companySupplyItem =   [self addMenuItem:@"供求信息" index:2];
    }
    return self;
}

#pragma mark 添加一个菜单按钮
- (CompanyMenuItem *) addMenuItem :(NSString *) title index:(int) index
{
    CompanyMenuItem * item = [[CompanyMenuItem alloc] init];
    item.btnTag = index;
    item.tag = index;
    item.frame = CGRectMake(index * KCompanyMenuItemW, 0, 0, 0);
    item.title = title;
    [item addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:item];
    switch (index) {
        case 0:
            item.currentType = KTopMenuCompannyHome;
            break;
        case 1:
            item.currentType = kTopMenyDynamic;
            break;
        case 2:
            item.currentType = KTopMenuSupply;
            break;
        default:
            break;
    }
    return item;
    if (index == 1) {
        [self itemClicked:item];
    }
}

- (void)setFrame:(CGRect)frame
{
    frame.size = CGSizeMake(3 * KCompanyMenuItemW, KCompanyMenuItemH);
    [super setFrame:frame];
}

- (void) itemClicked:(CompanyMenuItem *) item
{
    //0 通知代理
//    if ([_delegate respondsToSelector:@selector(menu:from:to:)]) {
//        [_delegate menu:self from:_selectedItem.tag to:item.tag];
//    }
    if ([_delegate respondsToSelector:@selector(menu:to:)]) {
        [_delegate menu:self to:item];
    }
    // 1 控制item状态
    _selectedItem.selected = NO;
    item.selected = YES;
    _selectedItem = item;
    
    
}
@end

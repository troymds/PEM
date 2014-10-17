//
//  findViewController.h
//  PEM
//
//  Created by YY on 14-8-27.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface findViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    UIButton *_selectedFind;
    NSMutableArray *_CateSupplyArray;
    NSMutableArray *_CateDemandArray;
    NSMutableArray *_CetCategoryListArray;
    UIButton *_supplyBtnPice;
    UIButton *bigbutton;
}
@property(nonatomic,retain)NSMutableArray *CateSupplyArray;
@property(nonatomic,retain)NSMutableArray *CateDemandArray;
@property(nonatomic ,strong)UITableView *tableView;
@property(nonatomic ,strong)UIButton *selectedFind;
@property(nonatomic,retain)NSMutableArray *CetCategoryListArray;

@property(nonatomic,retain)NSString *cateIndex;
@property(nonatomic,weak)NSString *titleLabel;
@property(nonatomic,retain)NSString *HOTORDER;
@property(nonatomic,retain)UIButton *suppANDdemBtntag;
@end

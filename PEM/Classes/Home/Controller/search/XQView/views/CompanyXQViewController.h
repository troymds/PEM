//
//  CompanyXQViewController.h
//  PEM
//
//  Created by YY on 14-9-9.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@interface CompanyXQViewController : UIViewController{
    
    UIScrollView* _companyHomeScrollView;
    
    UIView *conditionView;
    UITableView *_conditionTableView;


    UIView *suplyANDdemandView;
    UITableView *_supplyANDdemandTableView;
    
    UIButton *ChosseSelectedBtn;
    NSMutableArray *_companyHomeArray;

    UIScrollView *_BigCompanyScrollView;
    UIView *companyBackView;
    
    MJRefreshHeaderView *header;
    MJRefreshFooterView *footer;
    

}
@property(nonatomic ,strong)UIScrollView *BigCompanyScrollView;

@property(nonatomic,strong)UIView *companyHom;
@property(nonatomic ,strong)UIButton* companySDIndex;

@property(nonatomic,retain)NSMutableArray *companyHomeArray;
@property(nonatomic,retain)NSMutableArray *companyNEWArray;
@property(nonatomic,retain)NSMutableArray *companySupplyArray;
@property(nonatomic,retain)NSMutableArray *companyDemandArray;


@property(nonatomic,retain)NSMutableArray *comArr;
@property(nonatomic,retain)NSString *companyName;


@property(nonatomic,weak)NSString *companyID;


@end

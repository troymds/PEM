//
//  CompanyXQViewController.h
//  PEM
//
//  Created by YY on 14-9-9.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "LoginView.h"
#import "RegisterContrller.h"
#import "FindSecretController.h"


typedef enum
{
    homeType,
    conditionType,
    supplyAndDemandType,
    
}interfaceType;

typedef enum {
    supplyType,
    demandType
}infoType;

@interface CompanyXQViewController : UIViewController<LoginViewDelegate>{
    
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
    interfaceType currentInterType;
    infoType selectType;
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
@property(nonatomic,weak)NSString *loginID;


@end

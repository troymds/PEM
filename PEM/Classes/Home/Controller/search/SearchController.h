//
//  SearchController.h
//  PEM
//
//  Created by YY on 14-8-27.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchController : UIViewController<UITextFieldDelegate>
{
    UIButton *_selectedBtnImage;
    UIButton *_selectXuanka;
    
    UIView *clearView;
    UIButton *bigBtn ;
    UIButton *history;
    
    UILabel *historyBtn;
    UIImageView *historyImage;

    int currentSelectedBtnTag;
}
@property(nonatomic,strong)NSMutableArray *supllyArray;
@property(nonatomic,strong)NSMutableArray *demandArray;
@property(nonatomic,strong)NSMutableArray *compangyArray;

@property(nonatomic,strong)NSMutableArray *hotSearchDemandArray;
@property(nonatomic,strong)NSMutableArray *hotSearchSupplyArray;
@property(nonatomic,strong)NSMutableArray *hotSearchCompanyArray;



@end

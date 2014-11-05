//
//  AreaController.h
//  PEM
//
//  Created by tianj on 14-8-21.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "SendValueDelegate.h"

@interface AreaController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    UITableView *_provinceTabelView;
    UITableView *_cityTableView;
    NSMutableArray *_dataArray;
    NSMutableArray *_provinceArray;    //包含所有省份的数组
    NSArray *titleArray;
    NSMutableArray *_cityArray;
    NSString *provinceName;           //选中的城市名
}

@property (nonatomic,weak) id <SendValueDelegate> delegate;

@end

//
//  CategoryController.h
//  PEM
//
//  Created by tianj on 14-8-21.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendValueDelegate.h"

@interface CategoryController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    UIScrollView *_scrollView;
    NSMutableArray *_categoryArr;
    NSMutableArray *_firstArray;
    NSMutableArray *_secondArray;
    UITableView *_firstTableView;
    UITableView *_secondTableView;
}

@property (nonatomic,assign) BOOL isSupply;
@property (nonatomic,weak) id<SendValueDelegate> delegate;

@end

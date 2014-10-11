//
//  AreaController.h
//  PEM
//
//  Created by tianj on 14-8-21.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SendValueDelegate.h"

@interface AreaController : UIViewController<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    CLLocationManager *_currentLocation;
    NSMutableArray *_provinceArray;    //包含所有省份的数组
    NSArray *titleArray;
}

@property (nonatomic,weak) id <SendValueDelegate> delegate;

@end

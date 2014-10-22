//
//  DemandController.h
//  PEM
//
//  Created by tianj on 14-9-26.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurchaseView.h"
#import "PurchaseItem.h"
#import "SendValueDelegate.h"
#import "ReloadDataDelegate.h"
@interface DemandController : UIViewController<PublishViewDelegate,SendValueDelegate,UIAlertViewDelegate>
{
    UIScrollView *_scorllView;
    PurchaseView *_demandView;
    CGPoint _offset;
    
    CategoryItem *demandCateItem;        //发布求购分类
    NSString *demandDes;                   //发布求购描述
    NSMutableArray *tagsArray;           //标签数组
 
    UITextField *activeField;
}

@property (nonatomic,copy) NSString *info_id;
@property (nonatomic,weak) id<ReloadDataDelegate> delegate;
@property (nonatomic,assign) BOOL isAdd;   //判断是添加还是修改

@end

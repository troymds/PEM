//
//  MySupplyController.h
//  PEM
//
//  Created by tianj on 14-8-27.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "BaseController.h"
#import "DeleteView.h"
#import "MJRefresh.h"
#import "ReloadDataDelegate.h"


@interface MySupplyController : BaseController<DeleteViewDelegate,MJRefreshBaseViewDelegate,ReloadDataDelegate>
{
    UILongPressGestureRecognizer *longGesture;
    NSIndexPath *delIndex;
    MJRefreshHeaderView *MJHeadView;
    MJRefreshFooterView *MJFootView;
    UIView *remindView;
}
@end

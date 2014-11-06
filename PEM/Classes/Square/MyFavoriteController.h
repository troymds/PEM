//
//  MyFavoriteController.h
//  PEM
//
//  Created by tianj on 14-8-27.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "BaseController.h"
#import "MJRefresh.h"
#import "ReloadDataDelegate.h"

@interface MyFavoriteController : BaseController<MJRefreshBaseViewDelegate,ReloadDataDelegate>
{
    MJRefreshHeaderView *MJHeadView;
    MJRefreshFooterView *MJFootView;
    BOOL isRefresh;
    BOOL isLoad;
}
@end

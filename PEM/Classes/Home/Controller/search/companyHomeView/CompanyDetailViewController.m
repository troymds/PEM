//
//  CompanyDetailViewController.m
//  PEM
//
//  Created by promo on 14-10-23.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "CompanyDetailViewController.h"
#import "CompanyTopMenuView.h"
#import "MJRefresh.h"
#import "XQgetInfoTool.h"
#import "comHomeModel.h"
#import "comPanyModel.h"
#import "CompanyHomeView.h"
#import "qiugouXQ.h"
#import "xiangqingViewController.h"
#import "CompanyMenuItem.h"

@interface CompanyDetailViewController ()<CompanyTopMenuViewDelegate,MJRefreshBaseViewDelegate,UIScrollViewDelegate>
{
    UIView *_orangLin;                  //menu底部的划线
    UIScrollView *_backScroll;           // 最底层的scroll，用来左右滑动
    CompanyMenuItem *_selectedBtn;      //选中的menu button
    CompanyTopMenuView * _topMenu;        //顶部菜单栏
}
@property (nonatomic, strong)  NSMutableArray  *companyHomeArray;//   公司首页数组
@property (nonatomic, strong)   NSMutableArray *comArr;//    公司详情数组
@end

@implementation CompanyDetailViewController



- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ebingoClicked) name:@"eBingooClicked" object:nil] ;
    _companyHomeArray = [NSMutableArray array];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 0, 200, 30);
    titleLabel.text = self.companyName;
    self.navigationItem.titleView = titleLabel;
    
//    self.title = self.companyName;
    // 1 加顶部菜单栏
    CompanyTopMenuView * topMenu = [[CompanyTopMenuView alloc] init];
    topMenu.frame = CGRectMake(0, 0, kWidth, KCompanyMenuItemH);
    topMenu.delegate = self;
    [self.view addSubview:topMenu];
    _topMenu = topMenu;
    
    //2 加顶部菜单栏底部的划线
    _orangLin =[[UIView alloc]init];
    [self.view addSubview:_orangLin];
    _orangLin.frame =CGRectMake(0, KCompanyMenuItemH-2, KCompanyMenuItemW, 2);
    _orangLin.backgroundColor =HexRGB(0x069dd4);
    
    [self addBackScrool];
    // 3 加刷新控件
    [self addRefreshViews];
    // 4 加载公司首页数据,并更新UI
    [self loadHomeCompanyData];
    // 5 添加企业动态View
    [self addEnterpriseActivityUI];
    // 6 添加供求信息View
    [self addSupplyInfoUI];

}

#pragma mark 供求信息UI
-(void) addSupplyInfoUI
{
    UIView *supplyInfoView = [[UIView alloc] initWithFrame:CGRectMake(2 * kWidth, 0, kWidth, self.view.frame.size.height-KCompanyMenuItemH)];
    supplyInfoView.backgroundColor = [UIColor redColor];
    [_backScroll addSubview:supplyInfoView];
    
    
}

#pragma mark 企业动态UI
- (void) addEnterpriseActivityUI
{
    UIView *enterPriseView = [[UIView alloc] initWithFrame:CGRectMake(1 * kWidth, 0, kWidth, self.view.frame.size.height-KCompanyMenuItemH)];
    enterPriseView.backgroundColor = [UIColor blueColor];
    [_backScroll addSubview:enterPriseView];
}

#pragma mark  点击ebingo按钮
- (void)ebingoClicked{
//    comHomeModel *comHomeModel =[[_companyHomeArray objectAtIndex:0]objectAtIndex:0];
    
//    EbingooView *ebingView =[[EbingooView alloc]init];
//    ebingView.ebingooID =comHomeModel.e_url;
//    [self.navigationController pushViewController:ebingView animated:YES];
}
#pragma mark 加底层scrollview
- (void) addBackScrool
{
    _backScroll = [[UIScrollView alloc] init];
     CGFloat backH = self.view.frame.size.height-KCompanyMenuItemH;
    _backScroll.frame = CGRectMake(0, KCompanyMenuItemH, kWidth, backH);
    _backScroll.showsHorizontalScrollIndicator = NO;
    _backScroll.showsVerticalScrollIndicator = NO;
    _backScroll.pagingEnabled = YES;
    _backScroll.bounces = NO;
    _backScroll.scrollEnabled = YES;
    _backScroll.userInteractionEnabled = YES;
    _backScroll.delegate = self;
    _backScroll.contentSize = CGSizeMake(kWidth * 3, backH);
    [self.view addSubview:_backScroll];
}

#pragma mark 加载数据（公司首页）
-(void) loadHomeCompanyData
{
    if (![_companyID isKindOfClass:[NSNull class]] ) {
        //    公司首页
        [XQgetInfoTool statusesWithSuccessNew:^(NSArray *statues) {
            [_companyHomeArray addObject:statues];
            comHomeModel *statuModel =[statues objectAtIndex:0];
            
            if (![statuModel.infoarray isKindOfClass:[NSNull class]]){
                
                for (NSDictionary *dict in statuModel.infoarray)
                {
                    comPanyModel *hotModel = [[comPanyModel alloc]initWithDictionaryForComapnyBtn:dict];
                    [_comArr addObject:hotModel];
                }
            }
            [self buildCompanyHomeUI];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } newFailure:^(NSError *error) {
            
        } NewCompanyid:_companyID loginId:[SystemConfig sharedInstance].company_id];
    }
}


#pragma mark 更新公司主页UI
- (void)buildCompanyHomeUI{
    CompanyHomeView * companyHome = [[CompanyHomeView alloc] initWithBlock:^(comPanyModel *data) {
       // 跳转到公司

        comPanyModel *model = data;
        if ([model.type isEqualToString:@"1"]) {
            qiugouXQ *detailVC = [[qiugouXQ alloc] init];
            detailVC.demandIndex = model.comid;
            [self.navigationController pushViewController:detailVC animated:YES];
        }else
        {
            xiangqingViewController *xiq =[[xiangqingViewController alloc]init];
            xiq.supplyIndex = model.comid;
            [self.navigationController pushViewController:xiq animated:YES];
        }
    }];
    comHomeModel* data = [[_companyHomeArray objectAtIndex:0] objectAtIndex:0];
    companyHome.frame  = CGRectMake(0, 0, kWidth, self.view.frame.size.height-KCompanyMenuItemH);
    companyHome.data = data;
    [_backScroll addSubview:companyHome];
}

#pragma mark 顶部菜单栏点击 delegate
//- (void)menu:(CompanyTopMenuView *)menu from:(NSInteger)from to:(NSInteger)to
//{
//        // 1 移动menu底部的线
//        [UIView animateWithDuration:0.3 animations:^{
//            CGFloat x = to * KCompanyMenuItemW;
//            _orangLin.frame = CGRectMake(x, KCompanyMenuItemH-2, KCompanyMenuItemW, 2);
//        }];
//
//        // 2 加载数据
//}

- (void) menu:(CompanyTopMenuView *)menu to:(CompanyMenuItem *)to
{
    _selectedBtn = to;
    _backScroll.contentOffset = CGPointMake(_selectedBtn.tag * kWidth, 0);
    // 移动menu底部的线
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat x = _selectedBtn.btnTag * KCompanyMenuItemW;
        _orangLin.frame = CGRectMake(x, KCompanyMenuItemH-2, KCompanyMenuItemW, 2);
        
    }];
}

#pragma mark 集成刷新控件
- (void)addRefreshViews
{
    // 1.下拉刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
//    header.scrollView = _conditionTableView;
    header.delegate = self;
    [header beginRefreshing];
    
    // 2.上拉加载更多
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
//    header.scrollView = _conditionTableView;
    
    footer.delegate = self;
}

#pragma mark 刷新代理方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]])
    {
        // 上拉加载更多
//        [self loadViewStatuce:refreshView];
    } else {
        // 下拉刷新
//        [self loadViewStatuce:refreshView];
    }
}

#pragma mark  ------scrollview_delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 1 移动线条
        float x = scrollView.contentOffset.x/scrollView.frame.size.width * KCompanyMenuItemW;
    [UIView animateWithDuration:0.3 animations:^{
        _orangLin.frame = CGRectMake(x, KCompanyMenuItemH - 2, KCompanyMenuItemW, 2);
    }];
    
    // 2 取到顶部菜单栏 点击按钮
    if (scrollView.contentOffset.x == 320) {
        for (UIView *subView in _topMenu.subviews){
            if ([subView isKindOfClass:[CompanyMenuItem class]]) {
                CompanyMenuItem * btn = (CompanyMenuItem *)subView;
                if (btn.currentType == kTopMenyDynamic) {
                    _selectedBtn = btn;
                    _selectedBtn.selected = YES;
                }else{
                    btn.selected = NO;
                }
            }
        }
       
    }else if (scrollView.contentOffset.x == 0)
    {
        for (UIView *subView in _topMenu.subviews) {
            if ([subView isKindOfClass:[CompanyMenuItem class]]) {
                CompanyMenuItem * btn = (CompanyMenuItem *)subView;
                if (btn.currentType == KTopMenuCompannyHome) {
                    _selectedBtn = btn;
                    _selectedBtn.selected = YES;
                }else{
                    btn.selected = NO;
                }
            }
        }
    }else if (scrollView.contentOffset.x == 640)
    {
        for (UIView *subView in _topMenu.subviews) {
            if ([subView isKindOfClass:[CompanyMenuItem class]]) {
                CompanyMenuItem * btn = (CompanyMenuItem *)subView;
                if (btn.currentType == KTopMenuSupply) {
                    _selectedBtn = btn;
                    _selectedBtn.selected = YES;
                }else{
                    btn.selected = NO;
                }
            }
        }
    }
}

@end

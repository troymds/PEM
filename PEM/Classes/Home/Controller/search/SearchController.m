//
//  SearchController.m
//  PEM
//
//  Created by YY on 14-8-27.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "SearchController.h"
#import "SearchResultModel.h"
#import "xiangqingViewController.h"
#import "CompanyXQViewController.h"
#import "SaveTempDataTool.h"
#import "supplyTableViewCell.h"
#import "demandTableViewCell.h"
#import "companyTableViewCell.h"
#import "supplyTool.h"
#import "demandTool.h"
#import "companyTool.h"
#import "yySupplyModel.h"
#import "yyDemandModel.h"
#import "yyCompanyModel.h"
#import "MJRefresh.h"
#import "qiugouXQ.h"
#import "SearchModel.h"
#import "SearchTool.h"
#import "UIImageView+WebCache.h"
#import "RemindView.h"
#import "SearchCompanyModel.h"
#import "SearchDenamdModel.h"
#import "LoadMoreCell.h"


#import "hotSearchTool.h"
#import "YYSearchButton.h"
#import <QuartzCore/QuartzCore.h>

#define RecTableView 255
#define ResultTableView 256

@interface SearchController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    UIImageView *_searchImage ;
    UITextField *_searchTextField;
    UIButton *_selectBtn;
    
    UITableView *_recTableView;
    UIView *_bgView;
    UIButton * _searBtn;
    
    UIView *_backViw;
    
    UITableView *_resultTableView;
    UIView *_resultBgView;
    
    CGFloat _tableViewHeight;
    NSMutableArray *_supllyArray;
    NSMutableArray *_demandArray;
    NSMutableArray *_compangyArray;
    
    UILabel *recordLabel;
    UILabel *dataLabel;
    UIView *noDataBgView;
    MJRefreshBaseView *_refreshView;
    
    NSString *_currentKeyString;
    
    UIScrollView *_backScrollview;
    UIWebView *_webView;
    
    BOOL needLoad;//是否需要加载
    BOOL isLoading;//是否正在加载
}

@property (nonatomic,retain) NSMutableArray *searchSupplyArray;
@property (nonatomic,retain) NSMutableArray *searchDemandArray;
@property (nonatomic,retain) NSMutableArray *searchComanyArray;

@end

@implementation SearchController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    
    _supllyArray = [[NSMutableArray array]init];
    _demandArray = [[NSMutableArray array]init];
    _compangyArray = [[NSMutableArray array]init];
    
    
    _searchSupplyArray = [[NSMutableArray alloc] initWithCapacity:0];
    _searchComanyArray = [[NSMutableArray alloc] initWithCapacity:0];
    _searchDemandArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    _hotSearchCompanyArray = [[NSMutableArray alloc] initWithCapacity:0];// 热门搜索
    _hotSearchDemandArray = [[NSMutableArray alloc] initWithCapacity:0];
    _hotSearchSupplyArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    _selectXuanka =[[UIButton alloc]init];
    _selectedBtnImage=[[UIButton alloc]init];
    
    
    currentSelectedBtnTag = 200;
    
    [self getSearchResultData];     //保存历史记录
    [self addbutton];
    [self addTableView];            // 搜索记录表
    
    [self addResultTableView];      // 搜索结果表
    // 2.集成刷新控件
    [self addRefreshViews];
    
    [self addShowNoRecordView];     //无数据
    [self addShowNoDataView];       //无记录
    [self loadHotSearchStatuses];   //热门搜索加载数据
    [self addWebView];
    
}
// 热门搜索
#pragma mark ---加载热门搜索数据
-(void)loadHotSearchStatuses{
    [hotSearchTool statusesWithSuccess:^(NSArray *statues) {
        
        NSDictionary *dict = [statues objectAtIndex:0];
        _hotSearchCompanyArray = [dict objectForKey:@"company"];
        _hotSearchDemandArray = [dict objectForKey:@"demand"];
        _hotSearchSupplyArray = [dict objectForKey:@"supply"];
        
        
        
        [self addHotSearchView];
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)addWebView
{
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
}


-(void)addHotSearchView{
    UIImage *hotImge =[UIImage imageNamed:@"home_hot.png"];
    UIImageView *hotSearchImage =[[UIImageView alloc]initWithFrame:CGRectMake(30, 15, hotImge.size.width, hotImge.size.height)];
    hotSearchImage.image = hotImge;
    [_backScrollview addSubview:hotSearchImage];
    
    UILabel *hotTitleLabel =[[UILabel alloc]initWithFrame:CGRectMake(60, 10, 100, 30)];
    [_backScrollview addSubview:hotTitleLabel];
    hotTitleLabel.text =@"热门搜索";
    hotTitleLabel.font =[UIFont systemFontOfSize:PxFont(22)];
    hotTitleLabel.textColor=HexRGB(0x3a3a3a);
    
    YYSearchButton *hotSearchDemandBtn;
    UIView *demandView;
    UIView *supplyView;
    UIView *companyView;
    
    if (currentSelectedBtnTag ==202) {
        [supplyView removeFromSuperview];
        [demandView removeFromSuperview];
        [companyView removeFromSuperview];
        
        demandView =[[UIView alloc]initWithFrame:CGRectMake(0, 35, kWidth, 150)];
        demandView.backgroundColor =[UIColor whiteColor];
        [_backScrollview addSubview:demandView];
        for (int i=0; i<_hotSearchCompanyArray.count; i++) {
            
            hotSearchDemandBtn =[YYSearchButton buttonWithType:UIButtonTypeCustom];
            NSString *demandStr =[_hotSearchCompanyArray objectAtIndex:i];
            [hotSearchDemandBtn setTitle:demandStr forState:UIControlStateNormal];
            hotSearchDemandBtn.frame =CGRectMake(13+i%4*(kWidth/4-5),8+ i/4*40, 68, 30);
            [hotSearchDemandBtn setTitleColor:HexRGB(0x808080) forState:UIControlStateNormal];
            hotSearchDemandBtn.titleLabel.font =[UIFont systemFontOfSize:PxFont(18)];
            
            [hotSearchDemandBtn setBackgroundImage:[UIImage imageNamed:@"dibuhengtiao.png"] forState:UIControlStateHighlighted];
            [demandView addSubview:hotSearchDemandBtn];
            [hotSearchDemandBtn addTarget:self action:@selector(hotSearchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            hotSearchDemandBtn.tag = i+70;
        }
    }else if (currentSelectedBtnTag ==201){
        
        
        [supplyView removeFromSuperview];
        [demandView removeFromSuperview];
        [companyView removeFromSuperview];
        companyView =[[UIView alloc]initWithFrame:CGRectMake(0, 35, kWidth, 150)];
        companyView.backgroundColor =[UIColor whiteColor];
        [_backScrollview addSubview:companyView];
        for (int i=0; i<_hotSearchDemandArray.count; i++) {
            hotSearchDemandBtn =[YYSearchButton buttonWithType:UIButtonTypeCustom];
            NSString *demandStr =[_hotSearchDemandArray objectAtIndex:i];
            [hotSearchDemandBtn setTitle:demandStr forState:UIControlStateNormal];
            hotSearchDemandBtn.frame =CGRectMake(13+i%4*(kWidth/4-5),8+ i/4*40, 68, 30);
            [hotSearchDemandBtn setTitleColor:HexRGB(0x808080) forState:UIControlStateNormal];
            hotSearchDemandBtn.titleLabel.font =[UIFont systemFontOfSize:PxFont(18)];
            
            [hotSearchDemandBtn setBackgroundImage:[UIImage imageNamed:@"dibuhengtiao.png"] forState:UIControlStateHighlighted];
            [companyView addSubview:hotSearchDemandBtn];
            [hotSearchDemandBtn addTarget:self action:@selector(hotSearchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            hotSearchDemandBtn.tag = i+90;
        }
    }else{
        [supplyView removeFromSuperview];
        [demandView removeFromSuperview];
        [companyView removeFromSuperview];
        
        supplyView =[[UIView alloc]initWithFrame:CGRectMake(0, 35, kWidth, 150)];
        supplyView.backgroundColor =[UIColor whiteColor];
        [_backScrollview addSubview:supplyView];
        
        
        
        for (int i=0; i<_hotSearchSupplyArray.count; i++) {
            hotSearchDemandBtn =[YYSearchButton buttonWithType:UIButtonTypeCustom];
            NSString *demandStr =[_hotSearchSupplyArray objectAtIndex:i];
            [hotSearchDemandBtn setTitle:demandStr forState:UIControlStateNormal];
            hotSearchDemandBtn.frame =CGRectMake(13+i%4*(kWidth/4-5),8+ i/4*40, 68, 30);
            [hotSearchDemandBtn setTitleColor:HexRGB(0x808080) forState:UIControlStateNormal];
            hotSearchDemandBtn.titleLabel.font =[UIFont systemFontOfSize:PxFont(18)];
            
            [hotSearchDemandBtn setBackgroundImage:[UIImage imageNamed:@"dibuhengtiao.png"] forState:UIControlStateHighlighted];
            [supplyView addSubview:hotSearchDemandBtn];
            [hotSearchDemandBtn addTarget:self action:@selector(hotSearchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            hotSearchDemandBtn.tag = i+80;
        }
    }
}
-(void)hotSearchBtnClick:(UIButton *)sender{
    [_supllyArray removeAllObjects];
    [_demandArray removeAllObjects];
    [_compangyArray removeAllObjects];
    [_searchSupplyArray removeAllObjects];
    [_searchDemandArray removeAllObjects];
    [_searchComanyArray removeAllObjects];
    
    [_resultTableView reloadData];
    [_recTableView reloadData];
    
    _currentKeyString = sender.titleLabel.text;
    _searchTextField.text =_currentKeyString;
    
    [self searchToGo];
    
    
}




- (void)getSearchResultData
{
    if (currentSelectedBtnTag ==202)
    {
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:[SaveTempDataTool getFilePathWithTag:currentSelectedBtnTag]])
        {
            if (_searchComanyArray.count>0)
            {
                [_searchComanyArray removeAllObjects];
            }
            for(NSString *tempStr in [SaveTempDataTool unarchiveClassWithArrayTag:currentSelectedBtnTag])
            {
                SearchCompanyModel *resultModel = [[SearchCompanyModel alloc] init];
                resultModel.searchKeyword = tempStr;
                [_searchComanyArray insertObject:resultModel atIndex:_searchComanyArray.count];
            }
        }
        
    }else if (currentSelectedBtnTag == 201){
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:[SaveTempDataTool getFilePathWithTag:currentSelectedBtnTag]])
        {
            if (_searchDemandArray.count>0)
            {
                [_searchDemandArray removeAllObjects];
            }
            for(NSString *tempStr in [SaveTempDataTool unarchiveClassWithArrayTag:currentSelectedBtnTag])
            {
                SearchDenamdModel *resultModel = [[SearchDenamdModel alloc] init];
                resultModel.searchKeyword = tempStr;
                [_searchDemandArray insertObject:resultModel atIndex:_searchDemandArray.count];
            }
        }
    }else{
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:[SaveTempDataTool getFilePathWithTag:currentSelectedBtnTag]])
        {
            if (_searchSupplyArray.count>0)
            {
                [_searchSupplyArray removeAllObjects];
            }
            for(NSString *tempStr in [SaveTempDataTool unarchiveClassWithArrayTag:currentSelectedBtnTag])
            {
                SearchResultModel *resultModel = [[SearchResultModel alloc] init];
                resultModel.searchKeyword = tempStr;
                [_searchSupplyArray insertObject:resultModel atIndex:_searchSupplyArray.count];
                
            }
        }
        
    }
    
    
}

- (void)addShowNoRecordView
{
    recordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    recordLabel.textAlignment = NSTextAlignmentCenter;
    recordLabel.backgroundColor = [UIColor clearColor];
    recordLabel.text = @"暂无搜索记录！";
    if (currentSelectedBtnTag ==202)
    {
        if (_searchComanyArray.count > 0)
        {
            recordLabel.hidden = YES;
        }else{
            recordLabel.hidden = NO;
        }
    }else if (currentSelectedBtnTag == 201){
        if (_searchDemandArray.count > 0)
        {
            recordLabel.hidden = YES;
        }else{
            recordLabel.hidden = NO;
        }
    }else{
        if (_searchSupplyArray.count > 0)
        {
            recordLabel.hidden = YES;
        }else{
            recordLabel.hidden = NO;
        }
    }
    recordLabel.enabled = NO;
    [_bgView addSubview:recordLabel];
}

- (void)addShowNoDataView
{
    noDataBgView = [[UIView alloc] initWithFrame:_resultBgView.bounds];
    noDataBgView.backgroundColor = [UIColor whiteColor];
    dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    dataLabel.textAlignment = NSTextAlignmentCenter;
    dataLabel.backgroundColor = [UIColor clearColor];
    dataLabel.text = @"没有数据！";
    dataLabel.enabled = NO;
    [noDataBgView addSubview:dataLabel];
    
    [_resultBgView addSubview:noDataBgView];
    noDataBgView.hidden = YES;
    
}

#pragma mark 集成刷新控件
- (void)addRefreshViews
{
    // 1.下拉刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = _resultTableView;
    header.delegate = self;
    //[header beginRefreshing];
}

#pragma mark 刷新代理方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        [self loadViewStatuses:refreshView];
    }
}
-(void)loadViewStatuses:(MJRefreshBaseView *)refreshView{
    
    _currentKeyString = [_searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    // 获取数据
    if (self.view == _resultBgView)
    {
        if (currentSelectedBtnTag ==202) {
            [self companyRequest];
            
        }
        else if(currentSelectedBtnTag == 201)
        {
            [self demandRequest];
            
        }else
        {
            [self supplyRequest];
            
            
        }
    }
    
    _refreshView = refreshView;
}
-(void)loadUpViewStatuses:(MJRefreshBaseView *)refreshView{
    
    _currentKeyString = [_searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    // 获取数据
    if (self.view == _resultBgView)
    {
        if (currentSelectedBtnTag ==202) {
            [self loadcompanyRequest];
            
        }
        else if(currentSelectedBtnTag == 201)
        {
            [self loaddemandRequest];
            
        }else
        {
            [self loadsupplyRequest];
            
            
        }
    }
    
    _refreshView = refreshView;
}

#pragma mark----request上拉加载更多
- (void)loadsupplyRequest
{
    if (_currentKeyString.length>0)
    {
        [SearchTool searchWithSupplySuccessBlock:^(NSArray *search) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (search.count<=0)
            {
                needLoad = NO;
                noDataBgView.hidden = NO;
                _resultTableView.hidden = YES;
            }else
            {
                if (search.count == 10) {
                    needLoad = YES;
                }else{
                    needLoad = NO;
                }
                _resultTableView.hidden = NO;
                noDataBgView.hidden = YES;
                [_supllyArray addObjectsFromArray:search];
            }
            if (isLoading) {
                isLoading = NO;
            }
            [self tableReloadData];
            
        } SupplywithKeywords:_currentKeyString lastID:0? 0:[NSString stringWithFormat:@"%u",[_supllyArray count]-0]  SupplyfailureBlock:^(NSError *error) {
            if (isLoading) {
                isLoading = NO;
            }
            NSInteger count = [_resultTableView numberOfRowsInSection:0];
            if (count!=_supllyArray.count) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_supllyArray.count inSection:0];
                LoadMoreCell *cell = (LoadMoreCell *)[_resultTableView cellForRowAtIndexPath:indexPath];
                cell.loadBtn.hidden = NO;
            }

            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
        }];
        
    }else
    {
        [supplyTool statusesWithSuccess:^(NSArray *statues) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (statues.count<=0)
            {
                needLoad = NO;
                noDataBgView.hidden = NO;
                _resultTableView.hidden = YES;
            }else
            {
                if (statues.count == 10) {
                    needLoad = YES;
                }else{
                    needLoad = NO;
                }
                _resultTableView.hidden = NO;
                noDataBgView.hidden = YES;
                [_supllyArray addObjectsFromArray:statues];
            }
            if (isLoading) {
                isLoading = NO;
            }
            [self tableReloadData];
            
        } lastID:0? 0:[NSString stringWithFormat:@"%u",[_supllyArray count]-0] failure:^(NSError *error) {
            
            if (isLoading) {
                isLoading = NO;
            }
            NSInteger count = [_resultTableView numberOfRowsInSection:0];
            if (count!=_supllyArray.count) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_supllyArray.count inSection:0];
                LoadMoreCell *cell = (LoadMoreCell *)[_resultTableView cellForRowAtIndexPath:indexPath];
                cell.loadBtn.hidden = NO;
            }

            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
            
            
        }];
        
    }
    
    
    
}
- (void)loaddemandRequest
{
    
    
    if (_searchTextField.text.length>0)
    {
        [SearchTool searchWithDemandSuccessBlock:^(NSArray *search) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            if (search.count<=0)
            {
                needLoad = NO;
                noDataBgView.hidden = NO;
                _resultTableView.hidden = YES;
            }else
            {
                if (search.count == 10) {
                    needLoad = YES;
                }else{
                    needLoad = NO;
                }
                noDataBgView.hidden = YES;
                _resultTableView.hidden = NO;
                [_demandArray addObjectsFromArray:search];
            }
            if (isLoading) {
                isLoading = NO;
            }
            [self tableReloadData];
            
        } DemandwithKeywords:_currentKeyString lastID:0? 0:[NSString stringWithFormat:@"%d",[_demandArray count]-0] DemandfailureBlock:^(NSError *error) {
            if (isLoading) {
                isLoading = NO;
            }
            NSInteger count = [_resultTableView numberOfRowsInSection:0];
            if (count!=_supllyArray.count) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_demandArray.count inSection:0];
                LoadMoreCell *cell = (LoadMoreCell *)[_resultTableView cellForRowAtIndexPath:indexPath];
                cell.loadBtn.hidden = NO;
            }

            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
        }];
        
    }else
    {
        [demandTool statusesWithSuccess:^(NSArray *statues) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            if (statues.count<=0)
            {
                needLoad = NO;
                noDataBgView.hidden = NO;
                _resultTableView.hidden = YES;
            }else
            {
                if (statues.count == 10) {
                    needLoad = YES;
                }else{
                    needLoad = NO;
                }
                noDataBgView.hidden = YES;
                _resultTableView.hidden = NO;
                [_demandArray addObjectsFromArray:statues];
            }
            if (isLoading) {
                isLoading = NO;
            }
            [self tableReloadData];
        } lastID:0? 0:[NSString stringWithFormat:@"%u",[_demandArray count]-0] failure:^(NSError *error) {
            if (isLoading) {
                isLoading = NO;
            }
            NSInteger count = [_resultTableView numberOfRowsInSection:0];
            if (count!=_supllyArray.count) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_demandArray.count inSection:0];
                LoadMoreCell *cell = (LoadMoreCell *)[_resultTableView cellForRowAtIndexPath:indexPath];
                cell.loadBtn.hidden = NO;
            }

            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
            
        }];
        
    }
    
}
- (void)loadcompanyRequest
{
    
    
    if (_currentKeyString.length > 0)
    {
        
        [SearchTool searchWithSuccessBlock:^(NSArray *search)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             
             
             if (search.count<=0)
             {
                 needLoad = NO;
                 noDataBgView.hidden = NO;
                 _resultTableView.hidden = YES;
             }else
             {
                 if (search.count ==10) {
                     needLoad = YES;
                 }else{
                     needLoad = NO;
                 }
                 noDataBgView.hidden = YES;
                 _resultTableView.hidden = NO;
                 
             }
             [_compangyArray addObjectsFromArray:search];
             if (isLoading) {
                 isLoading = NO;
             }
             [self tableReloadData];
             
         } withKeywords:_currentKeyString lastID: 0? 0:[NSString stringWithFormat:@"%u",[_compangyArray count]-0]
                              failureBlock:^(NSError *error) {
                                  if (isLoading) {
                                      isLoading = NO;
                                  }
                                  NSInteger count = [_resultTableView numberOfRowsInSection:0];
                                  if (count!=_supllyArray.count) {
                                      NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_compangyArray.count inSection:0];
                                      LoadMoreCell *cell = (LoadMoreCell *)[_resultTableView cellForRowAtIndexPath:indexPath];
                                      cell.loadBtn.hidden = NO;
                                  }

                                  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                  
                                  [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
                                  
                              }];
    }
    else
    {
        [companyTool statusesWithSuccess:^(NSArray *statues) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            if (statues.count<=0)
            {
                needLoad = NO;
                noDataBgView.hidden = NO;
                _resultTableView.hidden = YES;
            }else
            {
                if (statues.count ==10) {
                    needLoad = YES;
                }else{
                    needLoad = NO;
                }
                noDataBgView.hidden = YES;
                _resultTableView.hidden = NO;
                [_compangyArray addObjectsFromArray:statues];
            }
            if (isLoading) {
                isLoading = NO;
            }
            [self tableReloadData];
            
        } lasiID:0? 0:[NSString stringWithFormat:@"%u",[_compangyArray count]-0] failure:^(NSError *error) {
            if (isLoading) {
                isLoading = NO;
            }
            NSInteger count = [_resultTableView numberOfRowsInSection:0];
            if (count!=_supllyArray.count) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_compangyArray.count inSection:0];
                LoadMoreCell *cell = (LoadMoreCell *)[_resultTableView cellForRowAtIndexPath:indexPath];
                cell.loadBtn.hidden = NO;
            }
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
            
        }];
    }
    
}


#pragma mark----request下拉刷新
- (void)supplyRequest
{
    if (_currentKeyString.length>0)
    {
        
        
        [SearchTool searchWithSupplySuccessBlock:^(NSArray *search) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            if (search.count<=0)
            {
                needLoad = NO;
                noDataBgView.hidden = NO;
                _resultTableView.hidden = YES;
            }else
            {
                if (search.count == 10) {
                    needLoad = YES;
                }else{
                    needLoad = NO;
                }
                _resultTableView.hidden = NO;
                noDataBgView.hidden = YES;
                [_supllyArray removeAllObjects];
                [_supllyArray addObjectsFromArray:search];
            }
            
            
            [self tableReloadData];
            
        } SupplywithKeywords:_currentKeyString lastID:0? 0:[NSString stringWithFormat:@"%u",[_supllyArray count]-0]  SupplyfailureBlock:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
        }];
        
    }else
    {
        [supplyTool statusesWithSuccess:^(NSArray *statues) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (statues.count<=0)
            {
                needLoad = NO;
                noDataBgView.hidden = NO;
                _resultTableView.hidden = YES;
            }else
            {
                if (statues.count == 10) {
                    needLoad = YES;
                }else{
                    needLoad = NO;
                }
                _resultTableView.hidden = NO;
                noDataBgView.hidden = YES;
                [_supllyArray removeAllObjects];
                [_supllyArray addObjectsFromArray:statues];
            }
            
            
            [self tableReloadData];
            
        } lastID:0? 0:[NSString stringWithFormat:@"%u",[_supllyArray count]-0] failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
            
        }];
        
    }
    
    
    
}
- (void)demandRequest
{
    if (_searchTextField.text.length>0)
    {
        [SearchTool searchWithDemandSuccessBlock:^(NSArray *search) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            if (search.count<=0)
            {
                needLoad = NO;
                 noDataBgView.hidden = NO;
                _resultTableView.hidden = YES;
            }else
            {
                if (search.count == 10) {
                    needLoad = YES;
                }else{
                    needLoad = NO;
                }
                noDataBgView.hidden = YES;
                _resultTableView.hidden = NO;
                [_demandArray removeAllObjects];
                [_demandArray addObjectsFromArray:search];
                
            }
            
            [self tableReloadData];
            
        } DemandwithKeywords:_currentKeyString lastID:0? 0:[NSString stringWithFormat:@"%d",[_demandArray count]-0] DemandfailureBlock:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
            
            
        }];
        
    }else
    {
        [demandTool statusesWithSuccess:^(NSArray *statues) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            if (statues.count<=0)
            {
                noDataBgView.hidden = NO;
                _resultTableView.hidden = YES;
            }else
            {
                noDataBgView.hidden = YES;
                _resultTableView.hidden = NO;
                [_demandArray removeAllObjects];
                [_demandArray addObjectsFromArray:statues];
                
            }
            
            [self tableReloadData];
        } lastID:0? 0:[NSString stringWithFormat:@"%u",[_demandArray count]-0] failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
            
        }];
        
    }
    
}
- (void)companyRequest
{
    if (_currentKeyString.length > 0){
        
        [SearchTool searchWithSuccessBlock:^(NSArray *search){
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             
             if (search.count<=0)
             {
                 needLoad = NO;
                 noDataBgView.hidden = NO;
                 _resultTableView.hidden = YES;
             }else{
                 if (search.count == 10) {
                     needLoad = YES;
                 }else{
                     needLoad = NO;
                 }
                 noDataBgView.hidden = YES;
                 _resultTableView.hidden = NO;
                 [_compangyArray removeAllObjects];
                 [_compangyArray addObjectsFromArray:search];
             }
             
             [self tableReloadData];
             
         } withKeywords:_currentKeyString lastID: 0? 0:[NSString stringWithFormat:@"%u",[_compangyArray count]-0]
                              failureBlock:^(NSError *error) {
                                  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                  
                                  [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
                                  
                                  
        }];
    }else{
        [companyTool statusesWithSuccess:^(NSArray *statues) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            if (statues.count<=0){
                noDataBgView.hidden = NO;
                _resultTableView.hidden = YES;
            }else{
                if (statues.count == 10) {
                    needLoad = YES;
                }else{
                    needLoad = NO;
                }
                noDataBgView.hidden = YES;
                _resultTableView.hidden = NO;
                [_compangyArray removeAllObjects];
                [_compangyArray addObjectsFromArray:statues];
            }
            [self tableReloadData];
            
        } lasiID:0? 0:[NSString stringWithFormat:@"%u",[_compangyArray count]-0] failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
        }];
    }
}


- (void)tableReloadData
{
    [_refreshView endRefreshing];
    [_resultTableView reloadData];
}


- (void)addResultTableView
{
    _resultBgView = [[UIView alloc] initWithFrame:self.view.bounds];
    _resultBgView.backgroundColor = [UIColor whiteColor];
    
    _resultTableView = [[UITableView alloc]initWithFrame:_resultBgView.bounds style:UITableViewStylePlain];
    _resultTableView.delegate = self;
    _resultTableView.dataSource = self;
    _resultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _resultTableView.tag = ResultTableView;
    [_resultBgView addSubview:_resultTableView];
}

-(void)addbutton
{
    _searchImage =[[UIImageView alloc]init];
    _searchImage.frame =CGRectMake(0, 7, 230, 30);
    self.navigationItem.titleView =_searchImage;
    _searchImage.userInteractionEnabled = YES;
    _searchImage.image =[UIImage imageNamed:@"nav_searchBtn.png"];
    
    //    选项
    _selectBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [_searchImage addSubview:_selectBtn];
    _selectBtn.frame =CGRectMake(0, 0, 60, 30);
    [_selectBtn setTitle:@"供应" forState:UIControlStateNormal];
    [_selectBtn setTitleColor:HexRGB(0x666666) forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"nav_under.png"] forState:UIControlStateSelected];
    [_selectBtn setImage:[UIImage imageNamed:@"nav_under_btnselected.png"] forState:UIControlStateNormal];
    _selectBtn.selected = YES;
    _selectBtn.titleLabel.font =[UIFont systemFontOfSize:PxFont(20)];
    _selectBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    _selectBtn.imageEdgeInsets = UIEdgeInsetsMake(0,13,0,-65);
    
    _searchTextField =[[UITextField alloc]init];
    _searchTextField.frame =CGRectMake(63, 0, 145, 30);
    [_searchImage addSubview:_searchTextField];
    [_selectBtn addTarget:self action:@selector(xuankaBtn:) forControlEvents:UIControlEventTouchUpInside];
//    搜索框
    _searchTextField.delegate = self;
    _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    
    
    //    放大镜
    _searBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    _searBtn.bounds = CGRectMake(0, 0, 23, 23);
    [_searBtn setImage:[UIImage imageNamed:@"nav_search_btn.png"] forState:UIControlStateNormal];
    
    [_searBtn setImage:[UIImage imageNamed:@"nav_search_btn_pre.png"] forState:UIControlStateHighlighted];
    
    [_searBtn addTarget:self action:@selector(searchBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *canselButton = [[UIBarButtonItem alloc]initWithCustomView:_searBtn];
    self.navigationItem.rightBarButtonItem = canselButton;
    
}


-(void)xuangxiangka
{
    self.view = _bgView;
    
    
    _backViw =[[UIView alloc]initWithFrame:CGRectMake(50, 3, 100, 70)];
    [_bgView addSubview:_backViw];
    _backViw.backgroundColor =[UIColor clearColor];
    
    [_recTableView reloadData];
    
    if (currentSelectedBtnTag == 202)
    {
        if (_searchComanyArray.count>0)
            
        {
            recordLabel.hidden = YES;
        }else{
            recordLabel.hidden = NO;
        }
        
    }
    else if (currentSelectedBtnTag == 201)
    {
        if (_searchDemandArray.count>0)
            
        {
            recordLabel.hidden = YES;
        }else{
            recordLabel.hidden = NO;
        }
        
    }
    else
    {
        if (_searchSupplyArray.count>0)
            
        {
            recordLabel.hidden = YES;
        }else{
            recordLabel.hidden = NO;
        }
        
    }
    
    UIImageView *kuangImage =[[UIImageView alloc]init];
    kuangImage.frame = CGRectMake(-14, -58, 130, 168);
    kuangImage.image =[UIImage imageNamed:@"xialakuang.png"];
    [_backViw addSubview:kuangImage];
    kuangImage.userInteractionEnabled = YES;
    
    NSArray *sea =@[@"供应",@"求购",@"企业"];
    for (int segBtn=0; segBtn<3; segBtn++)
    {
        
        UIButton * sear =[UIButton buttonWithType:UIButtonTypeCustom];
        [kuangImage addSubview:sear];
        [sear setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        sear.frame =CGRectMake(16, 55+segBtn%3*(17+8), 95, 25);
        sear.titleLabel.font =[UIFont systemFontOfSize:14];
        [sear setTitle:sea[segBtn] forState:UIControlStateNormal];
        [sear setBackgroundImage:[UIImage imageNamed:@"blackBg.png"] forState:UIControlStateHighlighted];
        sear.tag = 200+segBtn;
        
        [sear addTarget:self action:@selector(sortSelectedBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    for (int i=0; i<2; i++) {
        UIView *l =[[UIView alloc]init];
        [kuangImage addSubview:l];
        l.frame =CGRectMake(16, 80+i%3*(17+8), 95, 1);
        l.backgroundColor =HexRGB(0xe6e3e4);
    }
    
}
-(void)addTableView
{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    _backScrollview =[[UIScrollView alloc]initWithFrame:CGRectMake(0,0, kWidth,kHeight-64)];
    _backScrollview.showsHorizontalScrollIndicator = NO;
    _backScrollview.showsVerticalScrollIndicator = NO;
    _backScrollview.contentSize = CGSizeMake(kWidth, _bgView.frame.size.height+90);
    _backScrollview.backgroundColor =[UIColor whiteColor];
    [_bgView addSubview:_backScrollview];
    _recTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 180, kWidth, _bgView.frame.size.height-90) style:UITableViewStylePlain];
    
    _recTableView.delegate =self;
    _recTableView.dataSource =self;
    _recTableView.bounces = NO;
    _recTableView.tag = RecTableView;
    [_backScrollview addSubview:_recTableView];
    _recTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _recTableView.separatorColor = [UIColor clearColor];
    _backViw.backgroundColor =[UIColor redColor];
    
    self.view = _bgView;
    
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // --- 》对应3个数组
    
    if (self.view == _bgView)
    {
        [_demandArray removeAllObjects];
        [_supllyArray removeAllObjects];
        [_compangyArray removeAllObjects];
        
        [_resultTableView reloadData];
        [_recTableView reloadData];
        
        
        if (currentSelectedBtnTag == 202)
        {
            if (_searchComanyArray.count > 0)
            {
                SearchCompanyModel *searchResult = [_searchComanyArray objectAtIndex:indexPath.row-1];
                _searchTextField.text = searchResult.searchKeyword;
                _currentKeyString = searchResult.searchKeyword;
                for (int i = 0;i<_searchComanyArray.count;i++)
                {
                    SearchCompanyModel *resultMod = [_searchComanyArray objectAtIndex:i];
                    if ([resultMod.searchKeyword isEqualToString:_currentKeyString])
                    {
                        [_searchComanyArray removeObjectAtIndex:i];
                    }
                }
                [_searchComanyArray insertObject:searchResult atIndex:0];
                
                
            }
        }
        else if (currentSelectedBtnTag == 201)
        {
            if (_searchDemandArray.count > 0)
            {
                SearchDenamdModel *searchResult = [_searchDemandArray objectAtIndex:indexPath.row-1];
                _searchTextField.text = searchResult.searchKeyword;
                _currentKeyString = searchResult.searchKeyword;
                
                for (int i = 0;i<_searchDemandArray.count;i++)
                {
                    SearchDenamdModel *resultMod = [_searchDemandArray objectAtIndex:i];
                    if ([resultMod.searchKeyword isEqualToString:_currentKeyString])
                    {
                        [_searchDemandArray removeObjectAtIndex:i];
                    }
                }
                [_searchDemandArray insertObject:searchResult atIndex:0];
                
            }
        }
        else
        {
            if (_searchSupplyArray.count > 0)
            {
                SearchResultModel *searchResult = [_searchSupplyArray objectAtIndex:indexPath.row-1];
                _searchTextField.text = searchResult.searchKeyword;
                _currentKeyString = searchResult.searchKeyword;
                for (int i = 0;i<_searchSupplyArray.count;i++)
                {
                    SearchResultModel *resultMod = [_searchSupplyArray objectAtIndex:i];
                    if ([resultMod.searchKeyword isEqualToString:_currentKeyString])
                    {
                        [_searchSupplyArray removeObjectAtIndex:i];
                    }
                }
                [_searchSupplyArray insertObject:searchResult atIndex:0];
            }
        }
        
        [self searchToGo];
        
        
    }
    
    else
    {
        if (currentSelectedBtnTag == 202)
        {
            CompanyXQViewController *xqVC = [CompanyXQViewController alloc];
            yyCompanyModel *comID =[_compangyArray objectAtIndex:indexPath.row];
            xqVC.companyName = comID.name;
            xqVC.companyID =comID.companyid;
            
            [self.navigationController pushViewController:xqVC animated:YES];
        }else if (currentSelectedBtnTag ==201)
        {
            // 从企业数组中取得enterpriseModel
            
            
            qiugouXQ *demand =[qiugouXQ alloc];
            yyDemandModel *dema =[_demandArray objectAtIndex:indexPath.row];
            demand.demandIndex = dema.demandid;
            [self.navigationController pushViewController:demand animated:YES];
            
        }else
        {
            // 从供应数组中取得provideModel
            xiangqingViewController *xiangq =[xiangqingViewController alloc];
            yySupplyModel *model = [_supllyArray objectAtIndex:indexPath.row];
            xiangq.supplyIndex = model.supplyId;
            [self.navigationController pushViewController:xiangq animated:YES];
        }
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.view == _bgView)
    {
        if (currentSelectedBtnTag == 202)
        {
            if (_searchComanyArray.count > 0)
            {
                return [_searchComanyArray count]+1 ;
            }else{ return 0;}
        }else if(currentSelectedBtnTag == 201)
        {
            if (_searchDemandArray.count > 0)
            {
                return [_searchDemandArray count]+1 ;
            }else{ return 0;}
        }else
        {
            if (_searchSupplyArray.count > 0)
            {
                return [_searchSupplyArray count]+1 ;
            }else{ return 0;}
        }
        
    }else
    {
        if (currentSelectedBtnTag==200)
        {
            return needLoad? [_supllyArray count]+1:_supllyArray.count;
            
        }
        if (currentSelectedBtnTag ==201)
        {
            return needLoad? [_demandArray count]+1:_demandArray.count;
        }else if (currentSelectedBtnTag ==202)
        {
            return needLoad? [_compangyArray count]+1:_compangyArray.count;
        }
    }
    
    return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.view == _bgView)
    {
        return 60;
    }else
    {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.view == _bgView)
    {
        return 44;
    }else if(_searBtn.selected){
        if(currentSelectedBtnTag == 202){
            if (indexPath.row < _compangyArray.count) {
                return 80;
            }else{
                return 40;
            }
        }else if (currentSelectedBtnTag == 201){
            if (indexPath.row< _demandArray.count) {
                return 86;
            }else{
                return 40;
            }
        }else {
            if (indexPath.row < _supllyArray.count) {
                return 86;
            }
            return 40;
        }
    }
    return 90;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *lineView;
    static NSString *cellName = @"cellName";
    if (self.view == _bgView){
        static NSString *cellID = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        if (indexPath.row == 0){
            history =[UIButton buttonWithType:UIButtonTypeCustom];
            history.frame = CGRectMake(0, 0, kWidth, 44);
            [history setTitleColor:HexRGB(0x3a3a3a) forState:UIControlStateNormal];
            [history setTitle:@"  搜索历史" forState:UIControlStateNormal];
            history.titleLabel.font =[UIFont systemFontOfSize:PxFont(22)];
            history.titleEdgeInsets =UIEdgeInsetsMake(0, -150, 0, 0);
            history.imageEdgeInsets = UIEdgeInsetsMake(0, -150, 0, 0);
            [history setImage:[UIImage imageNamed:@"home_history.png"] forState:UIControlStateNormal];
            history.tag = 10000;
            [cell addSubview:history];
            lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 44, kWidth-20, 1)];
            [cell addSubview:lineView];
            lineView.tag = history.tag;
            lineView.backgroundColor =HexRGB(0xe6e3e4);
            
            
            for (UIView *view in [cell subviews]){
                
                if (![view viewWithTag:10000]){
                    
                    [view removeFromSuperview];
                }
            }
        }
        else if(indexPath.row > 0){
            
            if (currentSelectedBtnTag ==202){
                if (_searchComanyArray.count>0){
                    history.hidden = NO;
                    lineView.hidden = NO;
                    SearchCompanyModel *resultModel =  [_searchComanyArray objectAtIndex:indexPath.row-1];
                    cell.textLabel.text = resultModel.searchKeyword;
                    cell.textLabel.textColor = HexRGB(0x666666);
                }else{
                    history.hidden =YES;
                    lineView.hidden = YES;

                }
            }else if (currentSelectedBtnTag ==201){
                if (_searchDemandArray.count>0){
                    history.hidden = NO;
                    lineView.hidden = NO;

                    SearchDenamdModel *resultModel =  [_searchDemandArray objectAtIndex:indexPath.row-1];
                    cell.textLabel.text = resultModel.searchKeyword;
                    cell.textLabel.textColor = HexRGB(0x666666);
                }else{
                    history.hidden =YES;
                    lineView.hidden = YES;

                }
            }else{
                if (_searchSupplyArray.count>0){
                    history.hidden = NO;
                    lineView.hidden = NO;

                    SearchResultModel *resultModel =  [_searchSupplyArray objectAtIndex:indexPath.row-1];
                    cell.textLabel.text = resultModel.searchKeyword;
                    cell.textLabel.textColor = HexRGB(0x666666);
                    
                }else{
                    history.hidden =YES;
                    lineView.hidden = YES;

                }
            }
        }
        UIView *cellLine = [[UIView alloc] initWithFrame:CGRectMake(10, 44, kWidth - 20, 1)];
        cellLine.backgroundColor = HexRGB(0xd5d5d5);
        [cell.contentView addSubview:cellLine];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        
        if (currentSelectedBtnTag ==202 ){
            if (indexPath.row<_compangyArray.count) {
                static NSString *cellIndexfider =@"Cell3";
                companyTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIndexfider];
                if (!cell) {
                    cell =[[companyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
                }
                if (_compangyArray.count>0){
                    yyCompanyModel *c=_compangyArray [indexPath.row];
                    cell.nameLabel.text =c.name;
                    cell.regionLabel.text = c.region;
                    [cell.imageCompany setImageWithURL:[NSURL URLWithString:c.image] placeholderImage:[UIImage imageNamed:@"loading.png"]];
                    cell.businessLabel.text =c.business;
                    
                    CGFloat nameCompanyw =[c.name sizeWithFont:[UIFont systemFontOfSize:PxFont(18)] constrainedToSize:CGSizeMake(195, 50)].width;
                    cell.vipType.frame = CGRectMake(80+nameCompanyw, 11, 13, 18);
                    
                    switch ([c.rank intValue]) {
                        case -1:
                        {
                            cell.vipType.image = [UIImage imageNamed:@"Vip6.png"];
                        }
                            break;
                        case 0:
                        {
                            cell.vipType.image = [UIImage imageNamed:@"Vip5.png"];
                        }
                            break;
                        case 1:
                        {
                            cell.vipType.image = [UIImage imageNamed:@"Vip4.png"];
                        }
                            break;
                        case 2:
                        {
                            cell.vipType.image = [UIImage imageNamed:@"Vip3.png"];
                            
                        }
                            break;
                        case 3:
                        {
                            cell.vipType.image = [UIImage imageNamed:@"Vip2.png"];
                            
                        }
                            break;
                        case 4:
                        {
                            cell.vipType.image = [UIImage imageNamed:@"Vip1.png"];
                            
                        }
                            break;
                            
                        default:
                            break;
                    }
                    
                    noDataBgView.hidden = YES;
                    _resultTableView.hidden = NO;
                }else{
                    noDataBgView.hidden = NO;
                    _resultTableView.hidden = YES;
                    
                }
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10,79, kWidth-20, 1)];
                lineView.backgroundColor = HexRGB(0xd5d5d5);
                [cell.contentView addSubview:lineView];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            }else{
                LoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
                if (cell == nil) {
                    cell = [[LoadMoreCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
                }
                [cell.activityView startAnimating];
                [cell.loadBtn addTarget:self action:@selector(loadBtnDown:) forControlEvents:UIControlEventTouchUpInside];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            
        }else if(currentSelectedBtnTag == 201){
            if (indexPath.row< _demandArray.count) {
                static NSString *cellIndexfider =@"Cell2";
                demandTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIndexfider];
                if (!cell) {
                    cell =[[demandTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
                }
                if (_demandArray.count>0){
                    yyDemandModel *d =_demandArray [indexPath.row];
                    cell.dateLabel.text =d.demandDate;
                    cell.IntroductionLabel.text =d.Introduction;
                    cell.nameLabel.text =d.name;
                    cell.read_numLabel.text = [NSString stringWithFormat:@"浏览%@次",d.read_num];
                    noDataBgView.hidden = YES;
                    _resultTableView.hidden = NO;
                    
                }else{
                    
                    noDataBgView.hidden = NO;
                    _resultTableView.hidden = YES;
                    
                }
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10,85, kWidth-20, 1)];
                lineView.backgroundColor = HexRGB(0xd5d5d5);
                [cell.contentView addSubview:lineView];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else{
                LoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
                if (cell == nil) {
                    cell = [[LoadMoreCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
                }
                [cell.activityView startAnimating];
                [cell.loadBtn addTarget:self action:@selector(loadBtnDown:) forControlEvents:UIControlEventTouchUpInside];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            
        }else{
            if (indexPath.row < _supllyArray.count) {
                static NSString *cellIndexfider =@"Cell1";
                
                supplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndexfider];
                
                if (cell == nil) {
                    cell = [[supplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
                }
                
                if (_supllyArray.count>0){
                    yySupplyModel *s =_supllyArray [indexPath.row];
                    
                    cell.companyLabel.text =s.company;
                    cell.nameLabel.text =s.name;
                    cell.read_numLabel.text =[NSString stringWithFormat:@"浏览%@次",s.read_num];
                    [cell.supplyImage setImageWithURL:[NSURL URLWithString:s.image] placeholderImage:[UIImage imageNamed:@"log.png"]];
                    cell.supply_numLabel.text =[NSString stringWithFormat:@"%@件起批",s.min_supply_num];
                    
                    
                    if ([s.price isEqualToString:@"0"]) {
                        cell.priceLabel.text=@"电议";
                    }else{
                        cell.priceLabel.text =[NSString stringWithFormat:@"￥%@",s.price];
                        
                    }
                    noDataBgView.hidden = YES;
                    _resultTableView.hidden = NO;
                    
                    
                }else{
                    noDataBgView.hidden = NO;
                    _resultTableView.hidden = YES;
                    
                }
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10,89, kWidth-20, 1)];
                lineView.backgroundColor = HexRGB(0xd5d5d5);
                [cell.contentView addSubview:lineView];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else{
                LoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
                if (cell == nil) {
                    cell = [[LoadMoreCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
                }
                [cell.activityView startAnimating];
                [cell.loadBtn addTarget:self action:@selector(loadBtnDown:) forControlEvents:UIControlEventTouchUpInside];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
    }
    return nil;
}

- (void)loadBtnDown:(UIButton *)btn
{
    btn.hidden = YES;
    isLoading = YES;
    if (currentSelectedBtnTag == 200) {
        [self loadsupplyRequest];
    }else if(currentSelectedBtnTag == 201 ){
        [self loaddemandRequest];
    }else{
        [self loadcompanyRequest];
    }
}


#pragma mark 6.第section组头部显示什么控件
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if (self.view == _bgView){
        //    清楚历史记录
        clearView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 40)];
        clearView.backgroundColor =[UIColor whiteColor];
       UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 1, kWidth-20, 1)];
        [clearView addSubview:lineView];
        lineView.backgroundColor = HexRGB(0xd5d5d5);

        UIButton *clearBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        clearBtn.frame =CGRectMake(30, 10, 260, 30);
        [clearBtn setTitle:@"清除历史记录" forState:UIControlStateNormal];
        [clearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [clearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [clearBtn setBackgroundImage:[UIImage imageNamed:@"deleteBtn.png"] forState:UIControlStateNormal];
        [clearBtn setBackgroundImage:[UIImage imageNamed:@"deleteBtn _selected.png"] forState:UIControlStateHighlighted];
        [clearBtn addTarget:self action:@selector(clearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [clearView addSubview:clearBtn];
        
        if (currentSelectedBtnTag == 202){
            if (_searchComanyArray.count > 0){
                clearView.hidden = NO;
            }else{
                clearView.hidden = YES;
            }
            
        }else if (currentSelectedBtnTag == 201){
            if (_searchDemandArray.count > 0){
                clearView.hidden = NO;
            }else{
                clearView.hidden = YES;
            }
            
        }else{
            if (_searchSupplyArray.count > 0){
                clearView.hidden = NO;
            }else{
                clearView.hidden = YES;
            }
        }
        return clearView;
    }else{
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (self.view == _resultBgView)
    {
        UIView *viewForHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 44)];
        
        UIView *lin =[[UIView alloc]init];
        lin.frame =CGRectMake(10, 44, 310, 1);
        [viewForHeader addSubview:lin];
        lin.backgroundColor =HexRGB(0xe6e3e4);
        
        UILabel *idLabel =[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 290, 44)];
        idLabel.text =[NSString stringWithFormat:@"关键词: %@",_currentKeyString];
        idLabel.font =[UIFont systemFontOfSize:PxFont(22)];
        idLabel.textColor=HexRGB(0x808080);
        [viewForHeader addSubview:idLabel];
        viewForHeader.backgroundColor = [UIColor whiteColor];
        
        return viewForHeader;
        
    }
    else
    {
        UIView *viewHistory = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 173)];
        UIImageView *historyImge =[[UIImageView alloc]initWithFrame:CGRectMake(24, 10, 25, 25)];
        historyImge.image =[UIImage imageNamed:@"home_history.png"] ;
        [viewHistory addSubview:historyImge];
        
        UILabel *historyLabel =[[UILabel alloc]initWithFrame:CGRectMake(65, 5, 80, 40)];
        historyLabel.text =@"搜索历史";
        historyLabel.font =[UIFont systemFontOfSize:14];
        [viewHistory addSubview:historyLabel];
        
        
        
        return viewHistory;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.view == _resultBgView)
    {
        return 44;
    }
    return 0;
}
#pragma mark ------背景button
-(void)addBigButton{
    bigBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    bigBtn.frame = CGRectMake(0, 0, kWidth, kHeight);
    bigBtn.backgroundColor =[UIColor whiteColor];
    bigBtn.alpha =0.1;
    [_bgView addSubview:bigBtn];
    
    [bigBtn addTarget:self action:@selector(bigBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)bigBtnClick:(UIButton *)big
{
    _selectBtn.selected = YES;
    
    [bigBtn removeFromSuperview];
    [_backViw removeFromSuperview];
}
#pragma mark-----xuanka选卡
-(void)xuankaBtn:(UIButton *)xuan
{
    
    xuan.selected=!xuan.selected;
    _selectXuanka.selected = xuan.selected;
    if (xuan.selected==NO)
    {
        [self addBigButton];
        [self xuangxiangka];
        
    }else
    {
        [bigBtn removeFromSuperview];
        [_backViw removeFromSuperview];
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.view = _bgView;
    [_recTableView reloadData];
    
    [self showSearchRecordLabel];
    
    [self bigBtnClick:(UIButton *)textField];
    
}

- (void)showSearchRecordLabel
{
    if (currentSelectedBtnTag ==202)
    {
        if (_searchComanyArray.count > 0)
        {
            recordLabel.hidden = YES;
        }else{
            recordLabel.hidden = NO;
        }
    }else if (currentSelectedBtnTag == 201){
        if (_searchDemandArray.count > 0)
        {
            recordLabel.hidden = YES;
        }else{
            recordLabel.hidden = NO;
        }
    }else{
        if (_searchSupplyArray.count > 0)
        {
            recordLabel.hidden = YES;
        }else{
            recordLabel.hidden = NO;
        }
    }
    
    
    _searBtn.selected = YES;
}

-(void)searchBtn:(UIButton *)sear
{
    [_demandArray removeAllObjects];
    [_supllyArray removeAllObjects];
    [_compangyArray removeAllObjects];
    
    [_resultTableView reloadData];
    [_recTableView reloadData];
    
    _currentKeyString = [_searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (_currentKeyString.length>0)
    {
        if (_currentKeyString.length>1&&[_currentKeyString characterAtIndex:0] == '@') {
            
        }
        // 如果有重复关键字，保留最新的。
        if (currentSelectedBtnTag == 202)
        {
            if (_searchComanyArray.count>0)
            {
                for (int i = 0;i<_searchComanyArray.count;i++)
                {
                    SearchCompanyModel *resultMod = [_searchComanyArray objectAtIndex:i];
                    if ([resultMod.searchKeyword isEqualToString:_currentKeyString])
                    {
                        [_searchComanyArray removeObjectAtIndex:i];
                    }
                }
            }
            SearchCompanyModel *resultModel = [[SearchCompanyModel alloc] init];
            resultModel.searchKeyword = _currentKeyString;
            if (_searchComanyArray.count == 7)
            {
                [_searchComanyArray removeLastObject];
            }
            [_searchComanyArray insertObject:resultModel atIndex:0];
            [self saveTempSearchWordWithTag:202];
            
        }
        else if (currentSelectedBtnTag == 201)
        {
            if (_searchDemandArray.count>0)
            {
                for (int i = 0;i<_searchDemandArray.count;i++)
                {
                    SearchDenamdModel *resultMod = [_searchDemandArray objectAtIndex:i];
                    if ([resultMod.searchKeyword isEqualToString:_currentKeyString])
                    {
                        [_searchDemandArray removeObjectAtIndex:i];
                    }
                }
            }
            
            
            SearchDenamdModel *resultModel = [[SearchDenamdModel alloc] init];
            resultModel.searchKeyword = _currentKeyString;
            if (_searchDemandArray.count == 7)
            {
                [_searchDemandArray removeLastObject];
            }
            [_searchDemandArray insertObject:resultModel atIndex:0];
            [self saveTempSearchWordWithTag:201];
            
        }
        else
        {
            if (_searchSupplyArray.count>0)
            {
                for (int i = 0;i<_searchSupplyArray.count;i++)
                {
                    SearchResultModel *resultMod = [_searchSupplyArray objectAtIndex:i];
                    if ([resultMod.searchKeyword isEqualToString:_currentKeyString])
                    {
                        [_searchSupplyArray removeObjectAtIndex:i];
                    }
                }
            }
            SearchResultModel *resultModel = [[SearchResultModel alloc] init];
            resultModel.searchKeyword = _currentKeyString;
            if (_searchSupplyArray.count == 7)
            {
                [_searchSupplyArray removeLastObject];
            }
            [_searchSupplyArray insertObject:resultModel atIndex:0];
            [self saveTempSearchWordWithTag:200];
        }
    }
    [self bigBtnClick:sear];
    [self searchToGo];
}

-(void)removerThreeArray{
    
    [_compangyArray removeAllObjects];
    [_demandArray removeAllObjects];
    [_supllyArray removeAllObjects];
    [_resultTableView reloadData];
    
}


- (void)searchToGo
{
    
    self.view = _resultBgView;
    
    [_searchTextField resignFirstResponder];
    
    // 显示指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    if (self.view == _resultBgView)
    {    [self removerThreeArray];
        
        [_resultTableView reloadData];
        if (currentSelectedBtnTag == 202)
        {
            [self companyRequest];
        }else if(currentSelectedBtnTag == 201)
        {
            [self demandRequest];
            
        }else
        {
            [self supplyRequest];
            
        }
    }
    
}

- (void)saveTempSearchWordWithTag:(int)arrayTag
{
    if (arrayTag == 202)
    {
        [SaveTempDataTool archiveClass:_searchComanyArray withArrayTag:arrayTag];
        
    }else if(arrayTag == 201)
    {
        [SaveTempDataTool archiveClass:_searchDemandArray withArrayTag:arrayTag];
    }else
    {
        [SaveTempDataTool archiveClass:_searchSupplyArray withArrayTag:arrayTag];
    }
}

- (void)sortSelectedBtn:(UIButton *)sender
{
    [self loadHotSearchStatuses];
    
    _selectXuanka.selected =!_selectXuanka.selected;
    if (sender.selected==YES) {
        _selectBtn.selected = NO;
    }else{
        _selectBtn.selected = YES;
    }
    
    if (_selectedBtnImage == sender)
    {
        
    }
    else
    {
        _selectedBtnImage.selected = NO;
        [_selectedBtnImage setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _selectedBtnImage = sender;
        _selectedBtnImage.selected = YES;
        [_selectedBtnImage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    [_backViw removeFromSuperview];
    [bigBtn removeFromSuperview];
    [_searchTextField resignFirstResponder];
    NSString *currentTitle = sender.currentTitle;
    [_selectBtn setTitle:currentTitle forState:UIControlStateNormal];
    
    currentSelectedBtnTag = sender.tag;
    
    sender.selected =YES;
    
    [self getSearchResultData];
    [_recTableView reloadData];
    [self showSearchRecordLabel];
    
    
}

-(void)clearBtnClick:(UIButton *)clear
{
    if (currentSelectedBtnTag == 202)
    {
        [_supllyArray removeAllObjects];
        [_demandArray removeAllObjects];
        [_searchComanyArray removeAllObjects];
        [_recTableView reloadData];
        [SaveTempDataTool archiveClass:_searchComanyArray withArrayTag:202];
        _searchTextField.text = nil;
        
        recordLabel.hidden = NO;
        
    }else if(currentSelectedBtnTag == 201)
    {
        [_supllyArray removeAllObjects];
        [_compangyArray removeAllObjects];
        [_searchDemandArray removeAllObjects];
        [_recTableView reloadData];
        [SaveTempDataTool archiveClass:_searchDemandArray withArrayTag:201];
        _searchTextField.text = nil;
        
        recordLabel.hidden = NO;
        
    }else
    {
        [_searchSupplyArray removeAllObjects];
        [_recTableView reloadData];
        [SaveTempDataTool archiveClass:_searchSupplyArray withArrayTag:200];
        _searchTextField.text = nil;
        
        recordLabel.hidden = NO;
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        if (scrollView.tag == ResultTableView) {
            NSIndexPath * indexpath=[NSIndexPath indexPathForRow:[_resultTableView numberOfRowsInSection:0]-1 inSection:0];
            if ([[_resultTableView cellForRowAtIndexPath:indexpath] isKindOfClass:[LoadMoreCell class]]&&scrollView.contentSize.height-scrollView.contentOffset.y<=scrollView.frame.size.height+40) {
                if (!isLoading) {
                    isLoading = YES;
                    if (currentSelectedBtnTag == 200) {
                        [self loadsupplyRequest];
                    }else if(currentSelectedBtnTag == 201 ){
                        [self loaddemandRequest];
                    }else{
                        [self loadcompanyRequest];
                    }
                }
            }

        }
    }
}

#pragma mark textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}


@end

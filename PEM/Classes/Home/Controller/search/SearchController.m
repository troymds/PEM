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
    NSMutableArray *_provideArray;
    
    CGFloat _tableViewHeight;
    NSMutableArray *_supllyArray;
    NSMutableArray *_demandArray;
    NSMutableArray *_compangyArray;
    UIImageView *kuangImag;
    
    UILabel *recordLabel;
    UILabel *dataLabel;
    UIView *noDataBgView;
    UIButton *cansleButton;//删除搜索字体
    MJRefreshBaseView *_refreshView;
    
    NSString *_currentKeyString;
}
@property (nonatomic) NSMutableArray *searchArray;

@property (nonatomic , retain)NSMutableArray *tempListArray;
@property (nonatomic , retain)NSString *saveTempKeyword;

@end

@implementation SearchController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    _supllyArray = [[NSMutableArray array]init];
    _demandArray = [[NSMutableArray array]init];
    _compangyArray = [[NSMutableArray array]init];
    
    _searchModelArray =[[NSMutableArray alloc]initWithCapacity:0 ];
    
    _searchArray = [[NSMutableArray alloc] initWithCapacity:0];
    _provideArray = [[NSMutableArray alloc] init];
    _selectXuanka =[[UIButton alloc]init];
    _selectedBtnImage=[[UIButton alloc]init];
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[SaveTempDataTool getFilePath]])
    {
        if (_searchArray.count>0)
        {
            [_searchArray removeAllObjects];
        }
        for(NSString *tempStr in [SaveTempDataTool unarchiveClass])
        {
            SearchResultModel *resultModel = [[SearchResultModel alloc] init];
            resultModel.searchKeyword = tempStr;
            [_searchArray insertObject:resultModel atIndex:_searchArray.count];
        }
        
        //[SaveTempDataTool removeFilePath];
    }
    
    [self addbutton];
    [self addTableView];            // 搜索记录表
    
    [self addResultTableView];      // 搜索结果表
    // 2.集成刷新控件
    [self addRefreshViews];
    
    [self addShowNoRecordView];
    [self addShowNoDataView];
    
    
}
- (void)addShowNoRecordView
{
    recordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 320, 44)];
    recordLabel.textAlignment = NSTextAlignmentCenter;
    recordLabel.backgroundColor = [UIColor clearColor];
    recordLabel.text = @"没有历史记录！";
    
    if (_searchArray.count > 0)
    {
        recordLabel.hidden = YES;
    }else{
        recordLabel.hidden = NO;}
    recordLabel.enabled = NO;
    [_bgView addSubview:recordLabel];
}

- (void)addShowNoDataView
{
    noDataBgView = [[UIView alloc] initWithFrame:_resultBgView.bounds];
    noDataBgView.backgroundColor = [UIColor whiteColor];
    dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 320, 44)];
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
    
    // 2.上拉加载更多
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = _resultTableView;
    footer.delegate = self;
}

#pragma mark 刷新代理方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) {
        // 上拉加载更多
        [self loadViewStatuses:refreshView];
    } else {
        // 下拉刷新
        [self loadViewStatuses:refreshView];
    }
}
-(void)loadViewStatuses:(MJRefreshBaseView *)refreshView{
    
    
    _currentKeyString = [_searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // 显示指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载中...";
    hud.dimBackground = YES;
    
    // 获取数据
    if (self.view == _resultBgView)
    {
        if (_selectBtn.tag ==202) {
            [self companyRequest];
        }else if(_selectBtn.tag == 201)
        {
            [self demandRequest];
        }else
        {
            [self supplyRequest];
        }
    }
    
    //[refreshView endRefreshing];
    _refreshView = refreshView;
}
- (void)supplyRequest
{
    if (_supllyArray.count!=0) {
        [_supllyArray removeAllObjects];
        [_resultTableView reloadData];
    }
    
    if (_currentKeyString.length>0)
    {
        [SearchTool searchWithSupplySuccessBlock:^(NSArray *search) {
            
            if (search.count<=0)
            {
                noDataBgView.hidden = NO;
                _resultTableView.hidden = YES;
            }else
            {
                _resultTableView.hidden = NO;
                noDataBgView.hidden = YES;
                [_supllyArray addObjectsFromArray:search];
            }
            [self tableReloadData];
            
        } SupplywithKeywords:_currentKeyString lastID:0? 0:[NSString stringWithFormat:@"%u",[_supllyArray count]-0]  SupplyfailureBlock:^(NSError *error) {
            NSLog(@"hah");
        }];
        
    }else
    {
        [supplyTool statusesWithSuccess:^(NSArray *statues) {
            if (statues.count<=0)
            {
                noDataBgView.hidden = NO;
                _resultTableView.hidden = YES;
            }else
            {
                _resultTableView.hidden = NO;
                noDataBgView.hidden = YES;
                [_supllyArray addObjectsFromArray:statues];
            }
            [self tableReloadData];
            
        } lastID:0? 0:[NSString stringWithFormat:@"%u",[_supllyArray count]-0] failure:^(NSError *error) {
            
        }];
        
    }
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    
}
- (void)demandRequest
{
    if (_demandArray.count!=0) {
        [_demandArray removeAllObjects];
        [_resultTableView reloadData];
    }
    if (_searchTextField.text.length>0)
    {
        [SearchTool searchWithDemandSuccessBlock:^(NSArray *search) {
            
            if (search.count<=0)
            {
                noDataBgView.hidden = NO;
                _resultTableView.hidden = YES;
            }else
            {
                noDataBgView.hidden = YES;
                _resultTableView.hidden = NO;
                [_demandArray addObjectsFromArray:search];
            }
            [self tableReloadData];
            
        } DemandwithKeywords:_currentKeyString lastID:0? 0:[NSString stringWithFormat:@"%d",[_demandArray count]-0] DemandfailureBlock:^(NSError *error) {
            
        }];
        
    }else
    {
        [demandTool statusesWithSuccess:^(NSArray *statues) {
            if (statues.count<=0)
            {
                noDataBgView.hidden = NO;
                _resultTableView.hidden = YES;
            }else
            {
                noDataBgView.hidden = YES;
                _resultTableView.hidden = NO;
                [_demandArray addObjectsFromArray:statues];
            }
            
            [self tableReloadData];
        } lastID:0? 0:[NSString stringWithFormat:@"%lu",[_demandArray count]-0] failure:^(NSError *error) {
            
        }];
        
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
}
- (void)companyRequest
{
    if (_compangyArray.count!=0) {
        [_compangyArray removeAllObjects];
        [_resultTableView reloadData];
    }
    
    if (_currentKeyString.length > 0)
    {
        
        [SearchTool searchWithSuccessBlock:^(NSArray *search) {
            
            if (search.count<=0)
            {
                noDataBgView.hidden = NO;
                _resultTableView.hidden = YES;
            }else
            {
                noDataBgView.hidden = YES;
                _resultTableView.hidden = NO;
                [_compangyArray addObjectsFromArray:search];
            }
            [self tableReloadData];
            
        } withKeywords:_currentKeyString lastID: 0? 0:[NSString stringWithFormat:@"%lu",[_compangyArray count]-0]
                              failureBlock:^(NSError *error) {
                              }];
    }else
    {
        [companyTool statusesWithSuccess:^(NSArray *statues) {
            
            if (statues.count<=0)
            {
                noDataBgView.hidden = NO;
                _resultTableView.hidden = YES;
            }else
            {
                noDataBgView.hidden = YES;
                _resultTableView.hidden = NO;
                [_compangyArray addObjectsFromArray:statues];
            }
            
            [self tableReloadData];
            
            
        } lasiID:0? 0:[NSString stringWithFormat:@"%lu",[_compangyArray count]-0] failure:^(NSError *error) {
            
        }];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
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
    [_resultBgView addSubview:_resultTableView];
}

-(void)addbutton
{
    _searchImage =[[UIImageView alloc]init];
    _searchImage.frame =CGRectMake(0, 20, 250, 30);
    [self.view addSubview:_searchImage];
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
    _searchTextField.frame =CGRectMake(63, 0, 165, 30);
    [_searchImage addSubview:_searchTextField];
    [_selectBtn addTarget:self action:@selector(xuankaBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _searchTextField.delegate = self;
    _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
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
    
    kuangImag =[[UIImageView alloc]init];
    kuangImag.frame = CGRectMake(7, 28, 78, 10);
    kuangImag.image =[UIImage imageNamed:@"xialakuang1.png"];
    [_searchImage addSubview:kuangImag];
    
    
    _backViw =[[UIView alloc]initWithFrame:CGRectMake(70, 5, 100, 90)];
    
    [_bgView addSubview:_backViw];
    
    [_recTableView reloadData];
    if (_searchArray.count>0)
        
    {
        recordLabel.hidden = YES;
    }else{
        recordLabel.hidden = NO;
    }
    
    UIImageView *kuangImage =[[UIImageView alloc]init];
    kuangImage.frame = CGRectMake(-30, -50, 100, 138);
    kuangImage.image =[UIImage imageNamed:@"xialakuang.png"];
    [_backViw addSubview:kuangImage];
    kuangImage.userInteractionEnabled = YES;
    
    NSArray *sea =@[@"供应",@"求购",@"企业"];
    for (int segBtn=0; segBtn<3; segBtn++)
    {
        UIView *l =[[UIView alloc]init];
        [kuangImage addSubview:l];
        l.frame =CGRectMake(12, 67+segBtn%3*(17+2), 74, 1);
        l.backgroundColor =HexRGB(0xe6e3e4);
        UIButton * sear =[UIButton buttonWithType:UIButtonTypeCustom];
        [kuangImage addSubview:sear];
        [sear setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        sear.frame =CGRectMake(12, 47+segBtn%3*(17+2), 74, 20);
        sear.titleLabel.font =[UIFont systemFontOfSize:14];
        [sear setTitle:sea[segBtn] forState:UIControlStateNormal];
        [sear setBackgroundImage:[UIImage imageNamed:@"blackBg.png"] forState:UIControlStateHighlighted];
        sear.tag = 200+segBtn;
        
        [sear addTarget:self action:@selector(sortSelectedBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}
-(void)addTableView
{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height-64)];
    _recTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, _bgView.frame.size.height) style:UITableViewStylePlain];
    
    _recTableView.delegate =self;
    _recTableView.dataSource =self;
    [_bgView addSubview:_recTableView];
    
    
    self.view = _bgView;
    
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // --- 》对应3个数组
    
    if (self.view == _bgView)
    {
        if (_searchArray.count > 0)
        {
            SearchResultModel *searchResult = [_searchArray objectAtIndex:indexPath.row-1];
            _searchTextField.text = searchResult.searchKeyword;
        }
    }
    
    else
    {
        if (_selectBtn.tag == 201)
        {
            qiugouXQ *demand =[qiugouXQ alloc];
            yyDemandModel *dema =[_demandArray objectAtIndex:indexPath.row];
            demand.demandIndex = dema.demandid;
            [self.navigationController pushViewController:demand animated:YES];
        }else if (_selectBtn.tag ==202)
        {
            // 从企业数组中取得enterpriseModel
            
            CompanyXQViewController *xqVC = [CompanyXQViewController alloc];
            yyCompanyModel *comID =[_compangyArray objectAtIndex:indexPath.row];
            xqVC.companyName = comID.name;
            xqVC.companyID =comID.companyid;
            
            [self.navigationController pushViewController:xqVC animated:YES];
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
        if (_searchArray.count > 0)
        {
            return [_searchArray count]+1 ;
        }else{ return 0;}
        
    }else{
        if (_selectBtn.tag==200){
            return [_supllyArray count];
        }
        if (_selectBtn.tag ==201) {
            return [_demandArray count];
        }else if (_selectBtn.tag ==202) {
            return [_compangyArray count];
        }}
    
    return 8;
    
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
        return 90;
    }
    return 100;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.view == _bgView)
    {
        static NSString *cellID = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row == 0)
        {
            
            for (UIView *view in [cell subviews])
            {
                
                if (![view viewWithTag:10000])
                {
                    [view removeFromSuperview];
                }
            }
            
            history =[UIButton buttonWithType:UIButtonTypeCustom];
            [cell addSubview:history];
            //cell.contentView.tag = 10001;
            [history setTitleColor:HexRGB(0x3a3a3a) forState:UIControlStateNormal];
            [history setTitle:@"  搜索历史" forState:UIControlStateNormal];
            history.titleLabel.font =[UIFont systemFontOfSize:PxFont(22)];
            [history setImage:[UIImage imageNamed:@"home_history.png"] forState:UIControlStateNormal];
            history.tag = 10000;
            history.frame = CGRectMake(-140, 0, 450, 44);
            history.hidden = YES;
        }
        else if(indexPath.row > 0)
        {
            
            if (_searchArray.count>0)
            {
                history.hidden = NO;
                SearchResultModel *resultModel =  [_searchArray objectAtIndex:indexPath.row-1];
                cell.textLabel.text = resultModel.searchKeyword;
            }
        }
        return cell;
        
    }else
    {
        if (_selectBtn.tag ==202 )
        {
            static NSString *cellIndexfider =@"Cell3";
            companyTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIndexfider];
            if (!cell) {
                cell =[[companyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
            }
            if (_compangyArray.count>0)
            {
                yyCompanyModel *c=_compangyArray [indexPath.row];
                cell.nameLabel.text =c.name;
                cell.regionLabel.text = c.region;
                [cell.imageCompany setImageWithURL:[NSURL URLWithString:c.image] placeholderImage:[UIImage imageNamed:@"loading.png"]];
                cell.businessLabel.text =c.business;
                noDataBgView.hidden = YES;
                _resultTableView.hidden = NO;
            }else
            {
                noDataBgView.hidden = NO;
                _resultTableView.hidden = YES;

            }
            
            return cell;
            
        }
        else if(_selectBtn.tag == 201)
        {
            static NSString *cellIndexfider =@"Cell2";
            demandTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIndexfider];
            if (!cell) {
                cell =[[demandTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
            }
            if (_demandArray.count>0)
            {
                yyDemandModel *d =_demandArray [indexPath.row];
                cell.dateLabel.text =d.demandDate;
                cell.IntroductionLabel.text =d.Introduction;
                cell.nameLabel.text =d.name;
                cell.read_numLabel.text = [NSString stringWithFormat:@"浏览量%@次",d.read_num];
                noDataBgView.hidden = YES;
                _resultTableView.hidden = NO;

            }else
            {
                noDataBgView.hidden = NO;
                _resultTableView.hidden = YES;

            }
            return cell;
            
        }else
        {
            static NSString *cellIndexfider =@"Cell1";
            
            supplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndexfider];
            
            if (cell == nil) {
                cell = [[supplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
            }
            
            if (_supllyArray.count>0)
            {
                yySupplyModel *s =_supllyArray [indexPath.row];
                
                cell.companyLabel.text =s.company;
                cell.nameLabel.text =s.name;
                cell.read_numLabel.text =[NSString stringWithFormat:@"浏览量%@次",s.read_num];
                [cell.supplyImage setImageWithURL:[NSURL URLWithString:s.image] placeholderImage:[UIImage imageNamed:@"log.png"]];
                cell.supply_numLabel.text =[NSString stringWithFormat:@"%@件起批",s.min_supply_num];
                cell.priceLabel.text =[NSString stringWithFormat:@"￥%@",s.price];
                noDataBgView.hidden = YES;
                _resultTableView.hidden = NO;

            }else
            {
                noDataBgView.hidden = NO;
                _resultTableView.hidden = YES;

            }
            
            return cell;
        }
        
    }
}
#pragma mark 6.第section组头部显示什么控件
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if (self.view == _bgView)
    {
        //    清楚历史记录
        clearView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
        UIButton *clearBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        clearBtn.frame =CGRectMake(30, 10, 260, 30);
        [clearBtn setTitle:@"清除历史记录" forState:UIControlStateNormal];
        [clearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [clearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [clearBtn setBackgroundImage:[UIImage imageNamed:@"deleteBtn.png"] forState:UIControlStateNormal];
        [clearBtn setBackgroundImage:[UIImage imageNamed:@"deleteBtn _selected.png"] forState:UIControlStateHighlighted];
        [clearBtn addTarget:self action:@selector(clearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [clearView addSubview:clearBtn];
        
        if (_searchArray.count > 0)
        {
            clearView.hidden = NO;
        }else{
            clearView.hidden = YES;
        }
        return clearView;
        
    }
    else{
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (self.view == _resultBgView)
    {
        UIView *viewForHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        
        UIView *lin =[[UIView alloc]init];
        lin.frame =CGRectMake(10, 44, 310, 1);
        [viewForHeader addSubview:lin];
        lin.backgroundColor =[UIColor lightGrayColor];
        lin.alpha = 0.3;
        
        UILabel *idLabel =[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 290, 44)];
        idLabel.text =[NSString stringWithFormat:@"关键词: %@",_searchTextField.text];
        idLabel.font =[UIFont systemFontOfSize:PxFont(22)];
        idLabel.textColor=HexRGB(0x808080);
        [viewForHeader addSubview:idLabel];
        viewForHeader.backgroundColor = [UIColor whiteColor];
        
        return viewForHeader;
        
    }else
    {
        UIView *viewHistory = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 173)];
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


-(void)xuankaBtn:(UIButton *)xuan
{
    xuan.selected=!xuan.selected;
    _selectXuanka.selected = xuan.selected;
    if (xuan.selected==NO)
    {
        [self xuangxiangka];
    }else
    {
        [_backViw removeFromSuperview];
        [kuangImag removeFromSuperview];
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.view = _bgView;
    [_recTableView reloadData];
    
    if (_searchArray.count>0)
    {
        recordLabel.hidden = YES;
    }else{
        recordLabel.hidden = NO;
    }
    
    _searBtn.selected = YES;
   
}

-(void)searchBtn:(UIButton *)sear
{
    [_demandArray removeAllObjects];
    [_supllyArray removeAllObjects];
    [_compangyArray removeAllObjects];    [_resultTableView reloadData];
    _currentKeyString = [_searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (_currentKeyString.length>0)
    {
        // 如果有重复关键字，保留最新的。
        if (_searchArray.count>0)
        {
            for (int i = 0;i<_searchArray.count;i++)
            {
                SearchResultModel *resultMod = [_searchArray objectAtIndex:i];
                if ([resultMod.searchKeyword isEqualToString:_currentKeyString])
                {
                    [_searchArray removeObjectAtIndex:i];
                }
            }
        }
        
        
        SearchResultModel *resultModel = [[SearchResultModel alloc] init];
        resultModel.searchKeyword = _currentKeyString;
        if (_searchArray.count == 7)
        {
            [_searchArray removeLastObject];
        }
        [_searchArray insertObject:resultModel atIndex:0];
        [self saveTempSearchWord];
        
        
    }
    [_backViw removeFromSuperview];
    
    self.view = _resultBgView;
    
    
    _searBtn.selected = YES;
    
    [_searchTextField resignFirstResponder];
    
    // 显示指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载中...";
    hud.dimBackground = YES;
    
    
    if (self.view == _resultBgView)
    {
        if (_selectBtn.tag == 202)
        {
            [self companyRequest];
        }else if(_selectBtn.tag == 201)
        {
            [self demandRequest];
        }else
        {
            [self supplyRequest];
        }
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
}

- (void)saveTempSearchWord
{
    [SaveTempDataTool archiveClass:_searchArray];
}

- (void)sortSelectedBtn:(UIButton *)sender
{
    _selectXuanka.selected =!_selectXuanka.selected;
    if (sender.selected==YES) {
        _selectBtn.selected = NO;
    }else{
        _selectBtn.selected = YES;
    }
    
    if (_selectedBtnImage == sender)
    {
        
    }
    else {
        _selectedBtnImage.selected = NO;
        [_selectedBtnImage setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _selectedBtnImage = sender;
        _selectedBtnImage.selected = YES;
        [_selectedBtnImage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    //self.view = _resultBgView;
    [_backViw removeFromSuperview];
    [kuangImag removeFromSuperview];
    [_searchTextField resignFirstResponder];
    _searchTextField.text = nil;
    NSString *currentTitle = sender.currentTitle;
    [_selectBtn setTitle:currentTitle forState:UIControlStateNormal];
    [_selectBtn setTitleColor:HexRGB(0x069dd4) forState:UIControlStateSelected];
    [_selectBtn setImage:[UIImage imageNamed:@"up_pre.png"] forState:UIControlStateSelected];
    [_selectBtn setImage:[UIImage imageNamed:@"nav_under.png"] forState:UIControlStateNormal];
    _selectBtn.tag = sender.tag;
    
    //[_resultTableView reloadData];
    
    sender.selected =YES;

    

}

-(void)clearBtnClick:(UIButton *)clear
{
    [_searchArray removeAllObjects];
    [_recTableView reloadData];
    [SaveTempDataTool archiveClass:_searchArray];
    _searchTextField.text = nil;
    
    recordLabel.hidden = NO;
}
-(void)BackButton
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    
    return YES;
}


@end
//
//  CompanyXQViewController.m
//  PEM
//
//  Created by YY on 14-9-9.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "CompanyXQViewController.h"
#import "conditionTableViewCell.h"
#import "comditionController.h"
#import "supplyViewCell.h"
#import "demandCell.h"
#import "MJRefresh.h"
#import "conditionModel.h"
#import "conditionTool.h"
#import "XQgetInfoTool.h"
#import "comHomeModel.h"
#import "comPanyModel.h"
#import "comPanyNEWTool.h"
#import "UIImageView+WebCache.h"
#import "supplyTool.h"
#import "demandTool.h"
#import "demandCOM.h"
#import "supplyCOM.h"
#import "comContent.h"
#import "qiugouXQ.h"
#import "xiangqingViewController.h"
#import "SystemConfig.h"
#import "PrivilegeController.h"
#import "RemindView.h"
#import "EbingooView.h"
#import "LoginView.h"
#import "HttpTool.h"
#import "CompanyHomeView.h"
#import "EplatFormController.h"

#define KHEIGHT_COMPANY  12

@interface CompanyXQViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,CompanyHomeViewDeletgare>
{
    UIButton *_selectedBtn;
    UIView *_orangLin;
    
    
    UIButton *_chooseSelected;
    
    UIView *chooseBackView;
    
    NSMutableArray *_conditionArray;
    MJRefreshBaseView *_refreshView;
    UILabel *dataLabel;
}

@end

@implementation CompanyXQViewController

@synthesize companyHom,companyID ,comArr;
@synthesize companyHomeArray=_companyHomeArray ;
@synthesize BigCompanyScrollView=_BigCompanyScrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = HexRGB(0xffffff);
    ChosseSelectedBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _companySupplyArray =[[NSMutableArray alloc]init];
    _companyDemandArray =[[NSMutableArray alloc]init];
    
    _companyHomeArray =[[NSMutableArray alloc]init];
    _companyNEWArray =[[NSMutableArray alloc]init];
    _conditionArray =[[NSMutableArray alloc]init];
    comArr =[[NSMutableArray alloc]init];
    [self addBigCompanyScrollView];
    [self addCompanyButton];
    
    
    
    
    [self loadViewStatusesHome];
    
    UIView *lin =[[UIView alloc]init];
    [self.view addSubview:lin];
    lin.frame = CGRectMake(0, 30, kWidth, 1);
    lin.backgroundColor =HexRGB(0xe6e3e4);
    
    _orangLin =[[UIView alloc]init];
    [self.view addSubview:_orangLin];
    _orangLin.frame =CGRectMake(0, 30, 107, 2);
    _orangLin.backgroundColor =HexRGB(0x069dd4);
    
    [self addShowNoDataView];

    [self addCompanyConditionView];
    [self addSupplyDemandView];
    [self addChooseBtn];
    
    [self addRefreshViews];
    
}

#pragma mark 集成刷新控件
- (void)addRefreshViews
{
    // 1.下拉刷新
    header = [MJRefreshHeaderView header];
    header.delegate = self;
    
    // 2.上拉加载更多
    footer = [MJRefreshFooterView footer];
    footer.delegate = self;
}


#pragma mark 刷新代理方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]])
    {
        // 上拉加载更多
        [self loadViewStatuce:refreshView];
    } else {
        // 下拉刷新
        [self loadViewStatuce:refreshView];
    }
}

-(void)loadViewStatusesHome
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";

    if ([companyID isKindOfClass:[NSNull class]] ) {
    }else
    {
        //    公司首页
        [XQgetInfoTool statusesWithSuccessNew:^(NSArray *statues) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            [_companyHomeArray addObject:statues];
            comHomeModel *statuModel =[statues objectAtIndex:0];
            self.title = statuModel.name;
            if (statues.count > 0) {
                
                companyBackView.hidden = NO;
                dataLabel.hidden = YES;
            }else if(statues.count==0){
                dataLabel.hidden = NO;
                companyBackView.hidden = YES;
                
            }

            if ([statuModel.infoarray isKindOfClass:[NSNull class]]){
                
            }else
            {
                for (NSDictionary *dict in statuModel.infoarray)
                {
                    comPanyModel *hotModel = [[comPanyModel alloc]initWithDictionaryForComapnyBtn:dict];
                    [comArr addObject:hotModel];
                }
            }
            dataLabel.hidden = YES;
//            [self addCompanyHome];
            [self buildCompanyHomeUI];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } newFailure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
            
        } NewCompanyid:companyID loginId:[SystemConfig sharedInstance].company_id];
        
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
    companyHome.delegate = self;
    [_BigCompanyScrollView addSubview:companyHome];
}

#pragma mark---status
-(void)loadViewStatuce:(MJRefreshBaseView *)refreshLoading
{
    
    if (![companyID isEqualToString:@""])
    {
        if (_selectedBtn.tag == 22)
        {
            if (_chooseSelected.tag == 30)
            {
                [self supplyRequest];
                
            }else
            {
                [self demandRequest];
               
            }
            
            
        }
        else if(_selectedBtn.tag == 21)
        {
            [self companyRequest];
            
        }
    }
    
    
    _refreshView = refreshLoading;
}
- (void)addShowNoDataView
{
    dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    dataLabel.textAlignment = NSTextAlignmentCenter;
    dataLabel.backgroundColor = [UIColor clearColor];
    dataLabel.text = @"没有数据！";
    dataLabel.hidden = YES;
    dataLabel.enabled = NO;
    [self.view addSubview:dataLabel];
}


- (void)supplyRequest
{
   
    //供求
    [supplyTool CompanyStatusesWithSuccesscategory:^(NSArray *statues) {
        
        if (statues.count > 0) {
            
            _supplyANDdemandTableView.hidden = NO;
            dataLabel.hidden = YES;
        }else if(statues.count==0){
            dataLabel.hidden = NO;
            _supplyANDdemandTableView.hidden = YES;
            
        }
        
        if (_companySupplyArray.count > 0)
        {
            [_companySupplyArray removeAllObjects];
        }
        [_companySupplyArray addObjectsFromArray:statues];
        
        [self tableReloadData];
        
    } CompanyId:companyID CompanyFailure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];

        
        
    }];
    
    
}
- (void)demandRequest
{
    
    [demandTool DemandCompanyStatusesWithSuccess:^(NSArray *statues) {
        if (statues.count > 0) {
            
            _supplyANDdemandTableView.hidden = NO;
            dataLabel.hidden = YES;
        }else if(statues.count==0){
            dataLabel.hidden = NO;
            _supplyANDdemandTableView.hidden = YES;
            
        }
        if (_companyDemandArray.count>0)
        {
            [_companyDemandArray removeAllObjects];
        }
        [_companyDemandArray addObjectsFromArray:statues];
        
        [self tableReloadData];
    } DemandCompanyFailure:^(NSError *error) {
        
        [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
        
    } DemandCompanyId:companyID];
    
    
}
- (void)companyRequest
{
       //    公司企业
    [comPanyNEWTool statusesWithSuccessNew:^(NSArray *statues) {

        if (statues.count > 0) {
            
            _conditionTableView.hidden = NO;
            dataLabel.hidden = YES;
        }else if(statues.count==0){
            dataLabel.hidden = NO;
            _conditionTableView.hidden = YES;
            
        }
        if (_companyNEWArray.count > 0)
        {
            [_companyNEWArray removeAllObjects];
        }
        [_companyNEWArray addObjectsFromArray:statues];
        

        [self tableReloadData1];
        //[_conditionTableView reloadData];
    } NewFailure:^(NSError *error) {
        
        [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
    } CompanyID:companyID ];
    
    
    
}

#pragma mark背景scrollview
-(void)addBigCompanyScrollView
{
    _BigCompanyScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 32, kWidth, kHeight-32-64)];
    _BigCompanyScrollView.contentSize = CGSizeMake(kWidth*3, _BigCompanyScrollView.frame.size.height);
    _BigCompanyScrollView.showsHorizontalScrollIndicator = NO;
    _BigCompanyScrollView.showsVerticalScrollIndicator = NO;
    _BigCompanyScrollView.pagingEnabled = YES;
    _BigCompanyScrollView.bounces = NO;
    _BigCompanyScrollView.tag = 9999;
    _BigCompanyScrollView.userInteractionEnabled = YES;
//    _BigCompanyScrollView.bounces = NO;
    
    _BigCompanyScrollView.delegate = self;
    [self.view addSubview:_BigCompanyScrollView];
    
    
}

//企业动态
-(void)addCompanyConditionView
{
    conditionView =[[UIView alloc]initWithFrame:CGRectMake(kWidth, 0, kWidth, kHeight-32)];
    conditionView.backgroundColor =[UIColor whiteColor];
    
    [_BigCompanyScrollView addSubview:conditionView];
    [_BigCompanyScrollView bringSubviewToFront:conditionView];
    

    
    _conditionTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-32-44) style:UITableViewStylePlain];
    _conditionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [conditionView addSubview:_conditionTableView];
    _conditionTableView.backgroundColor =[UIColor whiteColor];
    _conditionTableView.delegate =self;
    _conditionTableView.dataSource = self;
    _conditionTableView.tag = 130;
    
    
}
//供求信息
-(void)addSupplyDemandView{
    
    suplyANDdemandView =[[UIView alloc]initWithFrame:CGRectMake(kWidth*2, 0, kWidth, kHeight-32)];
    suplyANDdemandView.backgroundColor =[UIColor whiteColor];
    
    [_BigCompanyScrollView addSubview:suplyANDdemandView];
    
    
    _supplyANDdemandTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, suplyANDdemandView.frame.size.height-110) style:UITableViewStylePlain];
    _supplyANDdemandTableView.backgroundColor =[UIColor whiteColor];
    _supplyANDdemandTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [suplyANDdemandView addSubview:_supplyANDdemandTableView];
    
    _supplyANDdemandTableView.delegate =self;
    _supplyANDdemandTableView.dataSource = self;
    _supplyANDdemandTableView.tag = 131;
    
}


#pragma mark  ------scrollview_delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 9999)
    {
        dataLabel.hidden = YES;
        if (scrollView.contentOffset.x <=0) {
            scrollView.contentOffset = CGPointMake(0, 0);
        }
        
        if (scrollView.contentOffset.x >= kWidth*2) {
            scrollView.contentOffset = CGPointMake(kWidth*2, 0);
        }
        
        [UIView animateWithDuration:0.01 animations:^{
            _orangLin.frame = CGRectMake(scrollView.contentOffset.x/3,30, kWidth/3, 2);
        }];
        if (scrollView.contentOffset.x == 0) {
            
            for (UIView *subView in companyBackView.subviews) {
                if ([subView isKindOfClass:[UIButton class]]) {
                    UIButton *btn = (UIButton *)subView;
                    if (btn.tag == 20) {
                        _selectedBtn = btn;
                        _selectedBtn.selected = YES;
                    }else{
                        btn.selected = NO;
                    }
                }
            }
            
        }
        
        else if (scrollView.contentOffset.x == kWidth)
        {
            header.scrollView = _conditionTableView;
            footer.scrollView = _conditionTableView;
            [self companyRequest];
            for (UIView *subView in companyBackView.subviews) {
                if ([subView isKindOfClass:[UIButton class]]) {
                    UIButton *btn = (UIButton *)subView;
                    if (btn.tag == 21) {
                        _selectedBtn = btn;
                        _selectedBtn.selected = YES;
                    }else{
                        btn.selected = NO;
                    }
                }
            }
            
        }
        else if (scrollView.contentOffset.x == kWidth*2) {
            
            header.scrollView = _supplyANDdemandTableView;
            header.scrollView = _supplyANDdemandTableView;
            for (UIView *subView in companyBackView.subviews) {
                if ([subView isKindOfClass:[UIButton class]]) {
                    UIButton *btn = (UIButton *)subView;
                    if (btn.tag == 22)
                    {
                        _selectedBtn = btn;
                        _selectedBtn.selected = YES;
                        if (_chooseSelected.tag == 31)
                        {
                            [self demandRequest];
                        }else{
                            [self supplyRequest];
                        }
                        
                    }else{
                        btn.selected = NO;
                    }
                }
            }
            
            
        }

    }else
    {
        return;
    }
    
}


#pragma mark -----CompanyHomeViewDeletgare
- (void) CompanyHomeView:(CompanyHomeView *)view
{
    comHomeModel *comHomeModel =[[_companyHomeArray objectAtIndex:0]objectAtIndex:0];
    if ([comHomeModel.e_url isKindOfClass:[NSNull class]]) {
       
            [RemindView showViewWithTitle:@"该企业未开通E平台" location:BELLOW];
    }
    else
    {
        EplatFormController *plat = [[EplatFormController alloc] init];
        plat.e_url = comHomeModel.e_url;
        [self.navigationController pushViewController:plat animated:YES];
    }
}


-(void)addChooseBtn
{
    
    chooseBackView =[[UIView alloc]initWithFrame:CGRectMake(0, kHeight-64-30-44, kWidth, 44)];
    chooseBackView.backgroundColor =[UIColor whiteColor];
    [suplyANDdemandView addSubview:chooseBackView];
    UIView *linview =[[UIView alloc]initWithFrame:CGRectMake(0,0, kWidth, 1)];
    [chooseBackView addSubview:linview];
    
    linview.backgroundColor =HexRGB(0xe6e3e4);
    for (int btn=0; btn<2; btn++)
    {
        NSArray *titleArray =@[@"供应信息",@"求购信息"];
        
        UIButton *chooseBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [chooseBackView addSubview:chooseBtn];
        [chooseBtn setTitleColor:HexRGB(0x666666) forState:UIControlStateNormal];
        [chooseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [chooseBtn setBackgroundImage:[UIImage imageNamed:@"back_companypre.png"] forState:UIControlStateSelected];
        chooseBtn.frame =CGRectMake(0+btn%3*kWidth/2, 1, kWidth/2,44);
        chooseBtn.titleLabel.font =[UIFont systemFontOfSize:PxFont(20)];
        [chooseBtn setTitle:titleArray[btn] forState:UIControlStateNormal];
        [chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        chooseBtn.tag = 30+btn;
        
        if (chooseBtn.tag ==30)
        {
            chooseBtn.selected = YES;
            _chooseSelected = chooseBtn;
        }
    }
    
    
}

#pragma mark 两个个button
-(void)chooseBtnClick:(UIButton *)choose
{
    _chooseSelected.selected = NO;
    choose.selected =YES;
    _chooseSelected = choose;
    
    if (choose.tag == 30)
    {
        [self supplyRequest];
    }else
    {
        if (![SystemConfig sharedInstance].isUserLogin) {
            LoginView *loginView = [[LoginView alloc] init];
            loginView.delegate = self;
            [loginView loginWithSuccess:^{
                [self demandRequest];
            } fail:^{
                NSLog(@"登陆失败");
            }];
            [loginView showView];
        }
      else if([[SystemConfig sharedInstance].viptype isEqualToString:@"0"]) {
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"温馨提示:" message:@"抱歉，您的级别不能查看求购的公司信息，请立即升级!" delegate:self cancelButtonTitle:@"立即升级" otherButtonTitles:@"取消", nil];
            [alert show];
        }
      
       else{
            [self demandRequest];

        }
    }
    
    [_supplyANDdemandTableView reloadData];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex ==0) {
        PrivilegeController *lvc =[[PrivilegeController alloc] init];
        [self.navigationController pushViewController:lvc animated:YES];
        
    }else{
    }
}
#pragma mark threeButton
-(void)addCompanyButton
{
   
    companyBackView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 30)];
    [self.view addSubview:companyBackView];
    companyBackView.backgroundColor =HexRGB(0xe1e9e9);
    for (int i=0; i<2; i++) {
        UIView *companyBackLine =[[UIView alloc]initWithFrame:CGRectMake(kWidth/3+i%3*(75+32), 8, 1, 14)];
        [companyBackView addSubview:companyBackLine];
        
        companyBackLine.backgroundColor =[UIColor lightGrayColor];
        companyBackLine.alpha = 0.5;
        
    }
    for (int p=0; p<3; p++)
    {
        NSArray *companyArr =@[@"公司首页",@"企业动态",@"供求信息"];
        UIButton *companyBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [companyBackView addSubview:companyBtn];
        
        [companyBtn setTitleColor:HexRGB(0x808080) forState:UIControlStateNormal];
        [companyBtn setTitleColor:HexRGB(0x069dd4) forState:UIControlStateSelected];
        
        [companyBtn setBackgroundImage:[UIImage imageNamed:@"deleteBtn _selected.png"] forState:UIControlStateHighlighted];
        companyBtn.frame =CGRectMake(0+p%3*107, 0, 107, 30);
        companyBtn.titleLabel.font =[UIFont systemFontOfSize:PxFont(20)];
        [companyBtn setTitle:companyArr[p] forState:UIControlStateNormal];
        
        companyBtn.tag =20+p;
        
        if (companyBtn.tag ==20)
        {
            companyBtn.selected = YES;
            _selectedBtn = companyBtn;
            
        }
        [companyBtn addTarget:self action:@selector(companyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}


#pragma mark 三个button
-(void)companyBtnClick:(UIButton *)company
{
    
    _selectedBtn.selected = NO;
    _selectedBtn = company;
    _selectedBtn.selected = YES;
    
    if (company.tag == 20)
    {
        dataLabel.hidden = YES;
        [_BigCompanyScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if(company.tag ==21)
    {
        header.scrollView = _conditionTableView;
        header.scrollView = _conditionTableView;
        [_BigCompanyScrollView setContentOffset:CGPointMake(kWidth, 0) animated:YES];
        [self companyRequest];
    }
    else if(company.tag ==22)
    {
        header.scrollView = _supplyANDdemandTableView;
        footer.scrollView = _supplyANDdemandTableView;
        [_BigCompanyScrollView setContentOffset:CGPointMake(kWidth*2, 0) animated:YES];
        if (_chooseSelected.tag == 31)
        {
            [self demandRequest];
        }else{
            [self supplyRequest];
        }
    }
}


- (void)tableReloadData
{
    [_refreshView endRefreshing];
    //[_conditionTableView reloadData];
    [_supplyANDdemandTableView reloadData];
}
- (void)tableReloadData1
{
    [_refreshView endRefreshing];
    [_conditionTableView reloadData];
    //[_supplyANDdemandTableView reloadData];
}


#pragma mark--tableViewDataSoure
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedBtn.tag ==21) {
        
        comditionController *com =[[comditionController alloc]init];
        comContent *comNew =[_companyNEWArray objectAtIndex:indexPath.row];
        com.companyIndex=comNew.comid;
        [self.navigationController pushViewController:com animated:YES];
    }else if(_selectedBtn.tag ==22)
    {
        if (_chooseSelected.tag ==31)
        {
            qiugouXQ *qig =[[qiugouXQ alloc]init];
            demandCOM *demid =[_companyDemandArray objectAtIndex:indexPath.row];
            qig.demandIndex =demid.companyID;
            [self.navigationController pushViewController:qig animated:YES];
            
        }else
        {
            xiangqingViewController *xq = [[xiangqingViewController alloc]init];
            supplyCOM *supid =[_companySupplyArray objectAtIndex:indexPath.row ];
            xq.supplyIndex = supid.uid;
            [self.navigationController pushViewController:xq animated:YES];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_selectedBtn.tag==22)
    {
        if (_chooseSelected.tag==31) {
            return 70;
            
        }else
        {
            return 80;
        }
    }else
    {
        return 70;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_selectedBtn.tag ==21) {
        
        return _companyNEWArray.count;

    }else if (_selectedBtn.tag ==22)
    {
        if (_chooseSelected.tag==31) {
            return _companyDemandArray.count;
            
        }else
        {
            return _companySupplyArray.count;
        }
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(_selectedBtn.tag==22)
    {
        static NSString *cellIndexfider =@"Cell3";
        demandCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIndexfider];
        if(_chooseSelected.tag==31)
        {

            if (!cell)
            {
                cell =[[demandCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
            }
            demandCOM *demand =[_companyDemandArray objectAtIndex:indexPath.row];
            
            cell.dateLabel.text =demand.date;
            cell.TitleLabel.text =demand.name;
            cell.contentLabel.text =demand.introduction;
            UIView *cellLine = [[UIView alloc] initWithFrame:CGRectMake(10, 69, kWidth - 20, 1)];
            cellLine.backgroundColor = HexRGB(0xd5d5d5);
            [cell.contentView addSubview:cellLine];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
            return cell;
        }else{
            static NSString *cellIndexfider =@"Cell2";
            
            supplyViewCell *supplyCell = [tableView dequeueReusableCellWithIdentifier:cellIndexfider];
            
            if (supplyCell == nil) {
                supplyCell = [[supplyViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
            }
            supplyCOM *item =[_companySupplyArray objectAtIndex:indexPath.row];
            supplyCell.nameLabel.text = item.name;
            supplyCell.priceLabel.text = [NSString stringWithFormat:@"¥%@元/每件",item.price];
            supplyCell.supply_numLabel.text = [NSString stringWithFormat:@"%@起供应",item.min_supply_num];
            supplyCell.read_numLabel.text = [NSString stringWithFormat:@"浏览%@次",item.read_num];

            supplyCell.dateLabel.text = item.date;
            [supplyCell.supplyImage setImageWithURL:[NSURL URLWithString:item.image] placeholderImage:[UIImage imageNamed:@"loading1.png"]];
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10,79, kWidth-20, 1)];
            line.backgroundColor = HexRGB(0xd5d5d5);
            [supplyCell.contentView addSubview:line];
            
            
            supplyCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return supplyCell;
            
        }
        
        return cell;
    }else
    {

        static NSString *cellID = @"Cell";
        conditionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            cell = [[conditionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        if (_companyNEWArray.count > 0)
        {
            comContent *conNew =[_companyNEWArray objectAtIndex:indexPath.row];
            
            cell.TitleLabel.text =conNew.title;
            cell.dateLabel.text =conNew.create_time;
            cell.contentLabel.text =conNew.description;
            
            UIView *cellLine = [[UIView alloc] initWithFrame:CGRectMake(10, 69, kWidth - 20, 1)];
            cellLine.backgroundColor = HexRGB(0xd5d5d5);
            [cell.contentView addSubview:cellLine];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
        }


        return cell;
    }
    
}



@end

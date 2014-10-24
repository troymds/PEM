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
#import "MJRefresh.h"
#import "RemindView.h"
#import "EbingooView.h"
#define KHEIGHT_COMPANY  12

@interface CompanyXQViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
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
    
    [self addRefreshViews];
    
    
    [self loadViewStatusesHome];
    
    UIView *lin =[[UIView alloc]init];
    [self.view addSubview:lin];
    lin.frame = CGRectMake(0, 30, kWidth, 1);
    lin.backgroundColor =[UIColor lightGrayColor];
    lin.alpha = 0.5;
    
    _orangLin =[[UIView alloc]init];
    [self.view addSubview:_orangLin];
    _orangLin.frame =CGRectMake(0, 30, 107, 2);
    _orangLin.backgroundColor =HexRGB(0x069dd4);
    
    //_selectedBtn = [[UIButton alloc]init];
    [self addShowNoDataView];

    [self addCompanyConditionView];
    [self addSupplyDemandView];
    [self addChooseBtn];
    
}


#pragma mark 集成刷新控件
- (void)addRefreshViews
{
    // 1.下拉刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = _conditionTableView;
    header.delegate = self;
    [header beginRefreshing];
    
    // 2.上拉加载更多
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    header.scrollView = _conditionTableView;
    
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
    if ([companyID isKindOfClass:[NSNull class]] ) {
    }else
    {
        //    公司首页
        [XQgetInfoTool statusesWithSuccessNew:^(NSArray *statues) {
            [_companyHomeArray addObject:statues];
            comHomeModel *statuModel =[statues objectAtIndex:0];
            
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
            [self addCompanyHome];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } newFailure:^(NSError *error) {
            
        } NewCompanyid:companyID];
        
    }
}

#pragma mark---status
-(void)loadViewStatuce:(MJRefreshBaseView *)refreshLoading
{
    // 显示指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载中...";
    hud.dimBackground = YES;
    
    if (![companyID isEqualToString:@""])
    {
        if (_selectedBtn.tag == 20)
        {
            [self supplyRequest];
            

        }
        else if(_selectedBtn.tag == 21)
        {
            [self companyRequest];
            if (_companyDemandArray.count ==0) {
                [RemindView showViewWithTitle:@"数据已全部加载完毕" location:BELLOW];
                
            }
        }
        
        else if(_selectedBtn.tag == 22)
        {
            [self demandRequest];
            if (_companyNEWArray.count ==0) {
                [RemindView showViewWithTitle:@"数据已全部加载完毕" location:BELLOW];
                
            }

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
        
        
    }];
    
    
}
- (void)demandRequest
{
    
    [demandTool DemandCompanyStatusesWithSuccess:^(NSArray *statues) {
        if (statues.count > 0) {
            
            _conditionTableView.hidden = NO;
            dataLabel.hidden = YES;
        }else if(statues.count==0){
            dataLabel.hidden = NO;
            _conditionTableView.hidden = YES;
            
        }
        if (_companyDemandArray.count>0)
        {
            [_companyDemandArray removeAllObjects];
        }
        [_companyDemandArray addObjectsFromArray:statues];
        
        [self tableReloadData];
    } DemandCompanyFailure:^(NSError *error) {
        
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
        [self tableReloadData];
    } NewFailure:^(NSError *error) {
        
    } CompanyID:companyID ];
    
    
    
}
#pragma mark背景scrollview
-(void)addBigCompanyScrollView{
    _BigCompanyScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 32, kWidth, kHeight-32-64)];
    _BigCompanyScrollView.contentSize = CGSizeMake(kWidth*3, _BigCompanyScrollView.frame.size.height);
    _BigCompanyScrollView.showsHorizontalScrollIndicator = NO;
    _BigCompanyScrollView.showsVerticalScrollIndicator = NO;
    _BigCompanyScrollView.pagingEnabled = YES;
    _BigCompanyScrollView.userInteractionEnabled = YES;
//    _BigCompanyScrollView.bounces = NO;
    
    _BigCompanyScrollView.delegate = self;
    [self.view addSubview:_BigCompanyScrollView];
    
    
}
//公司首页
-(void)addCompanyHome
{
    companyHom=[[UIView alloc]init];
    companyHom.frame =CGRectMake(0, 0, kWidth,kHeight-32);
    companyHom.backgroundColor =[UIColor whiteColor];
    [_BigCompanyScrollView addSubview:companyHom];
    [self addCompahyHomeUI];
}

//企业动态
-(void)addCompanyConditionView
{
    conditionView =[[UIView alloc]initWithFrame:CGRectMake(kWidth, 0, kWidth, kHeight-32)];
    conditionView.backgroundColor =[UIColor whiteColor];
    
    [_BigCompanyScrollView addSubview:conditionView];
    
    
    _conditionTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, conditionView.frame.size.height-44) style:UITableViewStylePlain];
    _conditionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [conditionView addSubview:_conditionTableView];
    _conditionTableView.backgroundColor =[UIColor whiteColor];
    _conditionTableView.delegate =self;
    _conditionTableView.dataSource = self;
    _conditionTableView.tag = 130;
    
    
}
//供求信息
-(void)addSupplyDemandView{
    
    suplyANDdemandView =[[UIView alloc]initWithFrame:CGRectMake(kWidth*2, 0, kWidth, kHeight-32-64)];
    suplyANDdemandView.backgroundColor =[UIColor whiteColor];
    
    [_BigCompanyScrollView addSubview:suplyANDdemandView];
    
    
    _supplyANDdemandTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, conditionView.frame.size.height-110) style:UITableViewStylePlain];
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
//    float x = scrollView.contentOffset.x/scrollView.frame.size.width;
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
}



#pragma mark ------companyHomeUI
-(void)addCompahyHomeUI
{
    if (_companyHomeArray.count>0)
    {
        
        comHomeModel *comHomeModel =[[_companyHomeArray objectAtIndex:0]objectAtIndex:0];
        
        UIView *navBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth-90, 44)];
        self.navigationItem.titleView =navBgView;
        navBgView.backgroundColor =[UIColor clearColor];
        UIButton *navBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [navBgView addSubview:navBtn];
        [navBtn setTitle:comHomeModel.name forState:UIControlStateNormal];
        navBtn.titleLabel.font =[UIFont systemFontOfSize:PxFont(20)];
        [navBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
        navBtn.frame = CGRectMake(0, 0, kWidth-90, 44);
        
        
        CGFloat keyContent =[comHomeModel.mainRun sizeWithFont:[UIFont systemFontOfSize:PxFont(18)] constrainedToSize:CGSizeMake(280, MAXFLOAT) ].height;
        CGFloat content =[comHomeModel.introduction sizeWithFont:[UIFont systemFontOfSize:PxFont(18)] constrainedToSize:CGSizeMake(280, MAXFLOAT)].height;
        CGFloat nameCompanyw =[comHomeModel.name sizeWithFont:[UIFont systemFontOfSize:PxFont(20)] constrainedToSize:CGSizeMake(180, 50)].width;
         CGFloat nameCompanyy =[comHomeModel.name sizeWithFont:[UIFont systemFontOfSize:PxFont(20)] constrainedToSize:CGSizeMake(180, MAXFLOAT)].height;
        
        CGFloat nameCompanww =[comHomeModel.name sizeWithFont:[UIFont systemFontOfSize:PxFont(20)] constrainedToSize:CGSizeMake(MAXFLOAT, 50)].width;
        
        
        
        
        
       //上下滑动背景图
        _companyHomeScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        _companyHomeScrollView.bounces = NO;
        [companyHom addSubview:_companyHomeScrollView];
        _companyHomeScrollView.showsVerticalScrollIndicator=NO;
        _companyHomeScrollView.userInteractionEnabled = YES;
        if (comArr.count>0) {
            _companyHomeScrollView.contentSize = CGSizeMake(kWidth,74+KHEIGHT_COMPANY*12+66+keyContent+content+comArr.count*30+140);
            
        }else{
            _companyHomeScrollView.contentSize = CGSizeMake(kWidth,74+KHEIGHT_COMPANY*12+66+keyContent+content+comArr.count*30+180);
            
        }
//        线条
        for (int li=0; li<4; li++) {
            UIImageView *linView =[[UIImageView alloc]init];
            [_companyHomeScrollView addSubview:linView];
            linView.image =[UIImage imageNamed:@"bg_homeCodition.png"];
            
                if (li==0) {
                    linView.frame =CGRectMake(0,74+KHEIGHT_COMPANY, kWidth, 10);
                    
                }
                if (li==1) {
                    linView.frame =CGRectMake(0,74+KHEIGHT_COMPANY*5+40, kWidth, 10);
                }if (li==2) {
                    linView.frame =CGRectMake(0,74+KHEIGHT_COMPANY*9+50+keyContent, kWidth, 10);;
                }
            if (li==3) {
                linView.frame =CGRectMake(0,74+KHEIGHT_COMPANY*12+66+keyContent+content, kWidth, 10);;
            }
            
            
        }
        
        
        UIImageView*  _companyImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 6, 105, 74)];
        [_companyImage setImageWithURL:[NSURL URLWithString:comHomeModel.image] placeholderImage:[UIImage imageNamed:@"loading.png"] options:(SDWebImageLowPriority||SDWebImageRetryFailed)];
        [_companyHomeScrollView addSubview:_companyImage];
        //名字
        UILabel* _nameCompany = [[UILabel alloc] initWithFrame:CGRectMake(125, KHEIGHT_COMPANY, 180, nameCompanyy)];
        _nameCompany.text = comHomeModel.name;
        _nameCompany.backgroundColor =[UIColor clearColor];
        _nameCompany.numberOfLines = 2;
        _nameCompany.font =[UIFont systemFontOfSize:PxFont(20)];
        [_companyHomeScrollView addSubview:_nameCompany];
        
        
        //vip
        UIImageView * _companyImgVip = [[UIImageView alloc] initWithFrame:CGRectMake(nameCompanyw, nameCompanyy-20, 18, 25)];
        _companyImgVip.backgroundColor =[UIColor clearColor];
        if (nameCompanyw== 180) {
            
            _companyImgVip.frame =CGRectMake(nameCompanww-180,17, 18, 25);
        }
        
        
        switch ([comHomeModel.viptype intValue]) {
            case -1:
            {
                _companyImgVip.image = [UIImage imageNamed:@"Vip6.png"];
            }
                break;
            case 0:
            {
                _companyImgVip.image = [UIImage imageNamed:@"Vip5.png"];
            }
                break;
            case 1:
            {
                _companyImgVip.image = [UIImage imageNamed:@"Vip4.png"];
            }
                break;
            case 2:
            {
                _companyImgVip.image = [UIImage imageNamed:@"Vip3.png"];
                
            }
                break;
            case 3:
            {
                _companyImgVip.image = [UIImage imageNamed:@"Vip2.png"];
                
            }
                break;
            case 4:
            {
                _companyImgVip.image = [UIImage imageNamed:@"Vip1.png"];
                
            }
                break;
                
            default:
                break;
        }

        
        [_nameCompany addSubview:_companyImgVip];
        
//        企业详情E平台
        UIButton *company_E =[UIButton buttonWithType:UIButtonTypeCustom];
        [_companyHomeScrollView addSubview:company_E];
        company_E.frame = CGRectMake(130, 55, 100, 30);
        [company_E addTarget:self action:@selector(ebingooE) forControlEvents:UIControlEventTouchUpInside];
        NSLog(@"----%@",comHomeModel.e_url);
        if ([comHomeModel.e_url isEqualToString:@""]) {
            [company_E setImage:[UIImage imageNamed:@"company_e_pre.png"] forState:UIControlStateNormal];
        }else{
            [company_E setImage:[UIImage imageNamed:@"company_E_btn.png"] forState:UIControlStateNormal];

        }
        
        
        //    电话
        UILabel*  _telphoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 74+KHEIGHT_COMPANY*2+10, kWidth-60, 15)];
        _telphoneLabel.text =[NSString stringWithFormat:@"电话:%@",comHomeModel.tel];
        _telphoneLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        _telphoneLabel.textColor=HexRGB(0x5e5e5e);
        _telphoneLabel.backgroundColor =[UIColor clearColor];
        
        UIImageView *_telphoneImage =[[UIImageView alloc]initWithFrame:CGRectMake(22, 74+KHEIGHT_COMPANY*2+10, 12, 12 )];
        [_companyHomeScrollView addSubview:_telphoneImage];
        _telphoneImage.image =[UIImage imageNamed:@"phone_pany.png"];


        //    网址
        UILabel * _urlLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 74+KHEIGHT_COMPANY*3+20, kWidth-60, 15)];
        _urlLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        _urlLabel.backgroundColor =[UIColor clearColor];
        
        _urlLabel.text =[NSString stringWithFormat:@"网址:%@",comHomeModel.website];
        [_companyHomeScrollView addSubview:_urlLabel];
        _urlLabel.textColor=HexRGB(0x5e5e5e);

        UIImageView *_urlImage =[[UIImageView alloc]initWithFrame:CGRectMake(22, 74+KHEIGHT_COMPANY*3+22, 12, 12 )];
        [_companyHomeScrollView addSubview:_urlImage];
        _urlImage.image =[UIImage imageNamed:@"website_url.png"];

        
        
        //地址
        UILabel*  _addessLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 74+KHEIGHT_COMPANY*4+30, kWidth-60, 15)];
        _addessLabel.text =[NSString stringWithFormat:@"地址:%@",comHomeModel.addr] ;
        _addessLabel.textColor=HexRGB(0x5e5e5e);
        _addessLabel.backgroundColor =[UIColor clearColor];
        _addessLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        [_companyHomeScrollView addSubview:_addessLabel];
        
        UIImageView *_addessImage =[[UIImageView alloc]initWithFrame:CGRectMake(22, 74+KHEIGHT_COMPANY*3+44, 12, 12 )];
        [_companyHomeScrollView addSubview:_addessImage];
        _addessImage.image =[UIImage imageNamed:@"place_company.png"];
        

        
        
        
        [_companyHomeScrollView addSubview:_telphoneLabel];
        
        
        NSArray *array =@[@"【主营范围】",@"【公司简介】",@"【近期供求】",];
        for (int s =0; s<3; s++) {
            UILabel *titleLabel =[[UILabel alloc]init];
            titleLabel.backgroundColor =[UIColor clearColor];
            titleLabel.textColor = HexRGB(0x3a3a3a);
            titleLabel.font =[UIFont systemFontOfSize:PxFont(20)];
            [_companyHomeScrollView addSubview:titleLabel];
            titleLabel.text =array[s];
            
            titleLabel.frame =CGRectMake(10, 74+KHEIGHT_COMPANY*6+40, 150, 40);
            
                if (s==1) {
                    titleLabel.frame =CGRectMake(10, 74+KHEIGHT_COMPANY*10+50+keyContent, 150, 40);
                    
                }
                if (s==2) {
                    titleLabel.frame =CGRectMake(10,74+KHEIGHT_COMPANY*13+66+keyContent+content, 150, 40 );
                
            }
            //        主营范围
            UILabel * _keyLabel =[[UILabel alloc]init];
            _keyLabel.text =comHomeModel.mainRun;
            [_companyHomeScrollView addSubview:_keyLabel];
            _keyLabel.numberOfLines = 0;
            _keyLabel.frame =CGRectMake(17, 74+KHEIGHT_COMPANY*8+46, 280, keyContent+15);
            _keyLabel.font =[UIFont systemFontOfSize:PxFont(18)];
            _keyLabel.textColor = HexRGB(0x666666);
            
            
            //        内容简介
            UILabel* _contentLabel =[[UILabel alloc]init];
            _contentLabel.text =comHomeModel.introduction;
            [_companyHomeScrollView addSubview:_contentLabel];
            _contentLabel.numberOfLines = 0;
            _contentLabel.textColor = HexRGB(0x666666);
            _contentLabel.font =[UIFont systemFontOfSize:PxFont(18)];
            
            _contentLabel.frame =CGRectMake(17, 74+KHEIGHT_COMPANY*11+66+keyContent, 280, content+15);
            
           
            UILabel *sdLagel;
            sdLagel =[[UILabel alloc]init];
            [_companyHomeScrollView addSubview:sdLagel];
            sdLagel.frame =CGRectMake((kWidth-100)/2, 74+KHEIGHT_COMPANY*13+100+keyContent+content,100, 20);
            sdLagel.text = @"暂无近期供求！";
            sdLagel.textColor =HexRGB(0x666666);
            sdLagel.font = [UIFont systemFontOfSize:PxFont(17)];
            sdLagel.hidden = NO;
            
            for (int a=0; a<comArr.count; a++) {
                //        近期供求
                
                if (comArr.count>0)
                {
                    sdLagel.hidden =YES;
                    comPanyModel *comArrModel =[comArr objectAtIndex:a];

                    
                    UIButton * comandImage =[UIButton buttonWithType:UIButtonTypeCustom];
                    comandImage.frame =CGRectMake (20, 74+KHEIGHT_COMPANY*14+86+keyContent+content+a%comArr.count*(30), 20, 20);
                    [_companyHomeScrollView addSubview:comandImage];

                    if ([comArrModel.type isEqualToString:@"1"]) {
                        [comandImage setImage:[UIImage imageNamed:@"company1.png"] forState:UIControlStateNormal];
                    }else {
                        [comandImage setImage:[UIImage imageNamed:@"company2.png"] forState:UIControlStateNormal];
                    }
                    [comandImage addTarget:self action:@selector(comandBtnClick:) forControlEvents:UIControlEventTouchUpInside];

                    UIButton * _comandBtn =[UIButton buttonWithType:UIButtonTypeCustom];
                    [_companyHomeScrollView addSubview:_comandBtn];
                    _comandBtn.titleLabel.font =[UIFont systemFontOfSize:PxFont(18)];
                    [_comandBtn setTitleColor:HexRGB(0x808080) forState:UIControlStateNormal];
                    [_comandBtn setTitle:comArrModel.name forState:UIControlStateNormal];
                    _comandBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
                    
                    _comandBtn.frame =CGRectMake (30, 74+KHEIGHT_COMPANY*14+86+keyContent+content+a%comArr.count*(30), 220, 20);
                    _comandBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    
                    _comandBtn.tag =1000+a;
                    comandImage.tag = _comandBtn.tag;
                    UILabel *dateLabel =[[UILabel alloc]init];
                    
                    dateLabel.text = comArrModel.time;
                    dateLabel.frame =CGRectMake (260, 74+KHEIGHT_COMPANY*14+86+keyContent+content+a%comArr.count*(30), 50, 20);
                    [_companyHomeScrollView addSubview:dateLabel];
                    dateLabel.font =[UIFont systemFontOfSize:PxFont(18)];
                    dateLabel.textColor =HexRGB(0x808080);
                    [_comandBtn addTarget:self action:@selector(comandBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                   
                }else {
                    
                    
                    
                }
                
                //    线条
                for (int l=0; l<comArr.count; l++)
                {
                    UIView *lin =[[UIView alloc]init];
                    lin.backgroundColor =HexRGB(0xe6e3e4);
                    lin.alpha = 0.5;
                    lin.frame=CGRectMake (5,74+KHEIGHT_COMPANY*14+106+keyContent+content+l%comArr.count*(30), 310, 1);
                    
                    [_companyHomeScrollView addSubview:lin];
                    if (nameCompanww== 180) {
                        lin.frame=CGRectMake (5,74+KHEIGHT_COMPANY*14+106+keyContent+content+l%comArr.count*(30)+35, 310, 1);
                        
                    }
                }
            }
        }
    }
    
    
    
}
#pragma mark -----ebingoo-E
-(void)ebingooE{
    comHomeModel *comHomeModel =[[_companyHomeArray objectAtIndex:0]objectAtIndex:0];

    EbingooView *ebingView =[[EbingooView alloc]init];
    ebingView.ebingooID =comHomeModel.e_url;
    [self.navigationController pushViewController:ebingView animated:YES];
    
  }
-(void)comandBtnClick:(UIButton *)comand
{
    if (comArr.count > 0)
    {
        comPanyModel *model = [comArr objectAtIndex:comand.tag-1000];
        if ([model.type isEqualToString:@"1"]) {
            qiugouXQ *detailVC = [[qiugouXQ alloc] init];
            detailVC.demandIndex = model.comid;
            [self.navigationController pushViewController:detailVC animated:YES];
        }else{
            xiangqingViewController *xiq =[[xiangqingViewController alloc]init];
            xiq.supplyIndex = model.comid;
            [self.navigationController pushViewController:xiq animated:YES];
        }
        
    }
    else{return;}
}

//供求信息
#pragma mark ------addCompanySupplyANDDemandUI


-(void)addChooseBtn
{
    
    chooseBackView =[[UIView alloc]initWithFrame:CGRectMake(0, suplyANDdemandView.frame.size.height-44, kWidth, 44)];
    [suplyANDdemandView addSubview:chooseBackView];
    chooseBackView.backgroundColor =[UIColor whiteColor];
    UIView *linview =[[UIView alloc]initWithFrame:CGRectMake(0,0, kWidth, 1)];
    [chooseBackView addSubview:linview];
    
    linview.backgroundColor =[UIColor lightGrayColor];
    linview.alpha = 0.5;
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
        [self demandRequest];
    }
    
    [_conditionTableView reloadData];
    
}


#pragma mark threeButton
-(void)addCompanyButton
{
    companyBackView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 30)];
    [self.view addSubview:companyBackView];
    companyBackView.backgroundColor =HexRGB(0xe1e9e9);
    for (int i=0; i<2; i++) {
        UIView *companyBackLine =[[UIView alloc]initWithFrame:CGRectMake(kWidth/3+i%3*(75+32), 5, 1, 20)];
        [companyBackView addSubview:companyBackLine];
        
        companyBackLine.backgroundColor =[UIColor lightGrayColor];
        
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
        _BigCompanyScrollView.contentOffset = CGPointMake(0, 0);
       // [_BigCompanyScrollView scrollRectToVisible:CGRectMake(0, 0, kWidth, _BigCompanyScrollView.frame.size.height) animated:YES];
    }
    else if(company.tag ==21)
    {
        _BigCompanyScrollView.contentOffset = CGPointMake(kWidth, 0);
        //[_BigCompanyScrollView scrollRectToVisible:CGRectMake(kWidth, 0, kWidth, _BigCompanyScrollView.frame.size.height) animated:YES];
        [self companyRequest];
    }
    else if(company.tag ==22)
    {
        _BigCompanyScrollView.contentOffset = CGPointMake(kWidth*2, 0);
        //[_BigCompanyScrollView scrollRectToVisible:CGRectMake(kWidth*2, 0, kWidth, _BigCompanyScrollView.frame.size.height) animated:YES];
        if (_chooseSelected.tag == 31)
        {
            [self demandRequest];
        }else{
            [self supplyRequest];
        }
    }
    
    
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint center =_orangLin.center;
        center.x = company.center.x;
        _orangLin.center = center;
    }];
    
}


- (void)tableReloadData
{
    [_refreshView endRefreshing];
    [_conditionTableView reloadData];
    [_supplyANDdemandTableView reloadData];
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
    return 90  ;
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
    return 10;
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
            supplyCell.read_numLabel.text = [NSString stringWithFormat:@"%@件起供应",item.min_supply_num];
            supplyCell.dateLabel.text = item.date;
            [supplyCell.supplyImage setImageWithURL:[NSURL URLWithString:item.image] placeholderImage:[UIImage imageNamed:@"loading1.png"]];
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10,89, kWidth-20, 1)];
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
            
            if (_companyNEWArray.count > 0)
            {
                comContent *conNew =[_companyNEWArray objectAtIndex:indexPath.row];
                
                cell.TitleLabel.text =conNew.title;
                cell.dateLabel.text =conNew.create_time;
                cell.contentLabel.text =conNew.description;
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}



@end

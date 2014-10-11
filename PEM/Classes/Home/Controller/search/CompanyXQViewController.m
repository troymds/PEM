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
@interface CompanyXQViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    UIButton *_selectedBtn;
    UIView *_orangLin;
    
    UITableView *_conditionTableView;
    UIView *conditionView;
    UIButton *_chooseSelected;
    
    UIView *chooseBackView;
    
    NSMutableArray *_conditionArray;
    MJRefreshBaseView *_refreshView;
}

@end

@implementation CompanyXQViewController

@synthesize companyHom,companyID ,comArr;
@synthesize companyHomeArray=_companyHomeArray ;


- (void)viewDidLoad
{
    [super viewDidLoad];
    ChosseSelectedBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _companySupplyArray =[[NSMutableArray alloc]init];
    _companyDemandArray =[[NSMutableArray alloc]init];
    
    _companyHomeArray =[[NSMutableArray alloc]init];
    _companyNEWArray =[[NSMutableArray alloc]init];
    _conditionArray =[[NSMutableArray alloc]init];
    comArr =[[NSMutableArray alloc]init];
    
    self.title=_companyName;
    
    [self addRefreshViews];
    [self loadViewStatusesHome];
    [self addCompanyButton];
    
    UIView *lin =[[UIView alloc]init];
    [self.view addSubview:lin];
    lin.frame = CGRectMake(0, 30, 320, 1);
    lin.backgroundColor =[UIColor lightGrayColor];
    lin.alpha = 0.5;
    
    _orangLin =[[UIView alloc]init];
    [self.view addSubview:_orangLin];
    _orangLin.frame =CGRectMake(0, 30, 107, 2);
    _orangLin.backgroundColor =HexRGB(0x069dd4);
    
    _selectedBtn = [[UIButton alloc]init];
    
    [self addCompanyConditionTableView];
    //[self addCompanyHome];
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
            
            if ([statuModel.infoarray isKindOfClass:[NSNull class]]){
                
            }else
            {
                for (NSDictionary *dict in statuModel.infoarray)
                {
                    comPanyModel *hotModel = [[comPanyModel alloc]initWithDictionaryForComapnyBtn:dict];
                    [comArr addObject:hotModel];
                }
            }
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
        }else if(_selectedBtn.tag == 21)
        {
            [self companyRequest];
        }else if(_selectedBtn.tag == 22)
        {
            [self demandRequest];
        }
    }else{
        [refreshLoading endRefreshing];
        return;
    }
    //[refreshLoading endRefreshing];
    
    _refreshView = refreshLoading;
}

- (void)supplyRequest
{
    //供求
    [supplyTool CompanyStatusesWithSuccesscategory:^(NSArray *statues) {
        
        if (_companySupplyArray.count > 0)
        {
            [_companySupplyArray removeAllObjects];
        }
        [_companySupplyArray addObjectsFromArray:statues];
        
        //[_conditionTableView reloadData];
        [self tableReloadData];
    } CompanyId:companyID CompanyFailure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
}
- (void)demandRequest
{
    [demandTool DemandCompanyStatusesWithSuccess:^(NSArray *statues) {
        
        if (_companyDemandArray.count>0)
        {
            [_companyDemandArray removeAllObjects];
        }
        [_companyDemandArray addObjectsFromArray:statues];
        
        [self tableReloadData];
    } DemandCompanyFailure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } DemandCompanyId:companyID];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
}
- (void)companyRequest
{
    //    公司企业
    [comPanyNEWTool statusesWithSuccessNew:^(NSArray *statues) {
        
        if (_companyNEWArray.count > 0)
        {
            [_companyNEWArray removeAllObjects];
        }
        [_companyNEWArray addObjectsFromArray:statues];
//        [_conditionTableView reloadData];
        [self tableReloadData];
    } NewFailure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } CompanyID:companyID ];
    
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
}

//公司首页
-(void)addCompanyHome
{
    companyHom=[[UIView alloc]init];
    companyHom.frame =CGRectMake(0, 35, 320, self.view.frame.size.height-30);
    companyHom.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:companyHom];
    [self addCompahyHomeUI];
}



#pragma mark ------companyHomeUI
-(void)addCompahyHomeUI
{
    if (_companyHomeArray.count>0)
    {
        comHomeModel *comHomeModel =[[_companyHomeArray objectAtIndex:0]objectAtIndex:0];
        
        CGFloat keyContent =[comHomeModel.mainRun sizeWithFont:[UIFont systemFontOfSize:PxFont(18)] constrainedToSize:CGSizeMake(280, MAXFLOAT) ].height;
        CGFloat content =[comHomeModel.introduction sizeWithFont:[UIFont systemFontOfSize:PxFont(18)] constrainedToSize:CGSizeMake(280, MAXFLOAT)].height;
        CGFloat nameCompanyw =[comHomeModel.name sizeWithFont:[UIFont systemFontOfSize:PxFont(20)] constrainedToSize:CGSizeMake(180, 50)].width;
        CGFloat nameCompanyy =[comHomeModel.name sizeWithFont:[UIFont systemFontOfSize:PxFont(20)] constrainedToSize:CGSizeMake(180, 50)].height;
        CGFloat urlHeight =[comHomeModel.website sizeWithFont:[UIFont systemFontOfSize:PxFont(15)] constrainedToSize:CGSizeMake(165, 40)].height;
        
        _companyHomeScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        [companyHom addSubview:_companyHomeScrollView];
        _companyHomeScrollView.contentSize = CGSizeMake(kWidth, content+keyContent+comArr.count*40+310);
        _companyHomeScrollView.showsVerticalScrollIndicator=NO;
        _companyHomeScrollView.userInteractionEnabled = YES;
        for (int li=0; li<3; li++) {
            UIImageView *linView =[[UIImageView alloc]init];
            [_companyHomeScrollView addSubview:linView];
            linView.image =[UIImage imageNamed:@"bg_homeCodition.png"];
            if (li==0) {
                linView.frame =CGRectMake(0,30+nameCompanyy+urlHeight+20, 320, 16);
                
            }
            if (li==1) {
                linView.frame =CGRectMake(0,30+nameCompanyy+urlHeight+80+keyContent, 320, 16);
            }if (li==2) {
                linView.frame =CGRectMake(0,30+nameCompanyy+urlHeight+135+keyContent+content, 320, 16);;
            }
        }
        
        
        UIImageView*  _companyImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 6, 106, 67)];
        [_companyImage setImageWithURL:[NSURL URLWithString:comHomeModel.image] placeholderImage:[UIImage imageNamed:@"loading.png"] options:(SDWebImageLowPriority||SDWebImageRetryFailed)];
        [_companyHomeScrollView addSubview:_companyImage];
        //名字
        UILabel* _nameCompany = [[UILabel alloc] initWithFrame:CGRectMake(130, 6, nameCompanyw, nameCompanyy)];
        _nameCompany.text = comHomeModel.name;
        _nameCompany.numberOfLines = 2;
        _nameCompany.font =[UIFont systemFontOfSize:PxFont(20)];
        [_companyHomeScrollView addSubview:_nameCompany];
        
        //vip
        UIImageView * _companyImgVip = [[UIImageView alloc] initWithFrame:CGRectMake(130+nameCompanyw, 8, 10, 10)];
        if ([comHomeModel.viptype isEqualToString:@"1"]) {
            NSLog(@"%@",comHomeModel.viptype);
            [_companyImgVip setImageWithURL:[NSURL URLWithString:comHomeModel.viptype] placeholderImage:[UIImage imageNamed:@"Vip1.png"] options:(SDWebImageLowPriority||SDWebImageRetryFailed)];
        }
        else  if ([comHomeModel.viptype isEqualToString:@"2"]) {
            [_companyImgVip setImageWithURL:[NSURL URLWithString:comHomeModel.viptype] placeholderImage:[UIImage imageNamed:@"Vip2.png"] options:(SDWebImageLowPriority||SDWebImageRetryFailed)];
        } else if([comHomeModel.viptype isEqualToString:@"3"]) {
            [_companyImgVip setImageWithURL:[NSURL URLWithString:comHomeModel.viptype] placeholderImage:[UIImage imageNamed:@"Vip3.png"] options:(SDWebImageLowPriority||SDWebImageRetryFailed)];
        }else{
            [_companyImgVip setImageWithURL:[NSURL URLWithString:nil] ];
        }
        
        
        
        [_companyHomeScrollView addSubview:_companyImgVip];
        
        
        //地址
        UILabel*  _addessLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 7+nameCompanyy, 180, 20)];
        _addessLabel.text =[NSString stringWithFormat:@"地址:%@",comHomeModel.addr] ;
        _addessLabel.textColor=HexRGB(0x666666);
        _addessLabel.font =[UIFont systemFontOfSize:PxFont(15)];
        [_companyHomeScrollView addSubview:_addessLabel];
        //    网址
        UILabel * _urlLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 25+nameCompanyy, 180, urlHeight)];
        _urlLabel.font =[UIFont systemFontOfSize:PxFont(15)];
        
        _urlLabel.numberOfLines = 2;
        _urlLabel.text =[NSString stringWithFormat:@"网址:%@",comHomeModel.website];
        [_companyHomeScrollView addSubview:_urlLabel];
        _urlLabel.textColor=HexRGB(0x666666);
        
        
        
        //    电话
        UILabel*  _telphoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 23+nameCompanyy+urlHeight, 180, 20)];
        _telphoneLabel.text =[NSString stringWithFormat:@"电话:%@",comHomeModel.tel];
        _telphoneLabel.font =[UIFont systemFontOfSize:PxFont(15)];
        _telphoneLabel.textColor=HexRGB(0x666666);
        
        [_companyHomeScrollView addSubview:_telphoneLabel];
        
        
        NSArray *array =@[@"【主营范围】",@"【公司简介】",@"【近期供求】",];
        for (int s =0; s<3; s++) {
            UILabel *titleLabel =[[UILabel alloc]init];
            titleLabel.textColor = HexRGB(0x3a3a3a);
            titleLabel.font =[UIFont systemFontOfSize:PxFont(20)];
            [_companyHomeScrollView addSubview:titleLabel];
            titleLabel.text =array[s];
            
            titleLabel.frame =CGRectMake(17, nameCompanyy+urlHeight+60, 150, 40);
            if (s==1) {
                titleLabel.frame =CGRectMake(17, nameCompanyy+urlHeight+120+keyContent, 150, 40);
                
            }
            if (s==2) {
                titleLabel.frame =CGRectMake(17,nameCompanyy+urlHeight+175+keyContent+content, 150, 40 );
            }
            //        主营范围
            UILabel * _keyLabel =[[UILabel alloc]init];
            _keyLabel.text =comHomeModel.mainRun;
            [_companyHomeScrollView addSubview:_keyLabel];
            _keyLabel.numberOfLines = 0;
            _keyLabel.frame =CGRectMake(17, nameCompanyy+urlHeight+90, 280, keyContent+15);
            _keyLabel.font =[UIFont systemFontOfSize:PxFont(18)];
            _keyLabel.textColor = HexRGB(0x666666);
            
            
            //        内容简介
            UILabel* _contentLabel =[[UILabel alloc]init];
            _contentLabel.text =comHomeModel.introduction;
            [_companyHomeScrollView addSubview:_contentLabel];
            _contentLabel.numberOfLines = 0;
            _contentLabel.textColor = HexRGB(0x666666);
            _contentLabel.font =[UIFont systemFontOfSize:PxFont(18)];
            
            _contentLabel.frame =CGRectMake(17, nameCompanyy+urlHeight+110+keyContent+40, 280, content+15);
            for (int a=0; a<comArr.count; a++) {
                //        近期供求
                if (comArr.count>0)
                {
                    
                    comPanyModel *comArrModel =[comArr objectAtIndex:a];
                    UIButton * _comandBtn =[UIButton buttonWithType:UIButtonTypeCustom];
                    
                    
                    [_companyHomeScrollView addSubview:_comandBtn];
                    CGFloat cmwith =[comArrModel.name sizeWithFont:[UIFont systemFontOfSize:PxFont(18)] constrainedToSize:CGSizeMake(200, 20)].width;
                    if ([comArrModel.type isEqualToString:@"1"]) {
                        [_comandBtn setImage:[UIImage imageNamed:@"company1.png"] forState:UIControlStateNormal];
                    }else {
                        [_comandBtn setImage:[UIImage imageNamed:@"company2.png"] forState:UIControlStateNormal];
                    }
                    
                    _comandBtn.titleLabel.font =[UIFont systemFontOfSize:PxFont(18)];
                    [_comandBtn setTitleColor:HexRGB(0x808080) forState:UIControlStateNormal];
                    [_comandBtn setTitle:comArrModel.name forState:UIControlStateNormal];
                    _comandBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
                    
                    _comandBtn.frame =CGRectMake (20, nameCompanyy+urlHeight+keyContent+content+210+a%comArr.count*(30), cmwith+20, 20);
                    
                    _comandBtn.tag =1000+a;
                    UILabel *dateLabel =[[UILabel alloc]init];
                    dateLabel.text = comArrModel.time;
                    dateLabel.frame =CGRectMake (260, nameCompanyy+ urlHeight+keyContent+content+210+a%comArr.count*(30), 50, 20);
                    [_companyHomeScrollView addSubview:dateLabel];
                    dateLabel.font =[UIFont systemFontOfSize:PxFont(18)];
                    dateLabel.textColor =HexRGB(0x808080);
                    [_comandBtn addTarget:self action:@selector(comandBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                }else{return;}
                
                //    线条
                for (int l=0; l<comArr.count; l++)
                {
                    UIView *lin =[[UIView alloc]init];
                    lin.backgroundColor =HexRGB(0xe6e3e4);
                    lin.alpha = 0.5;
                    lin.frame=CGRectMake (5,nameCompanyy+urlHeight+ keyContent+content+230+l%comArr.count*(30), 310, 1);
                    [_companyHomeScrollView addSubview:lin];
                }
            }
        }
    }
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
-(void)companySDIndexClick:(UIButton *)sender{
}
//企业动态
-(void)addCompanyConditionTableView
{
    conditionView =[[UIView alloc]initWithFrame:CGRectMake(0, 35, kWidth, kHeight-30)];
    conditionView.backgroundColor =[UIColor greenColor];
    
    
    [self.view addSubview:conditionView];
    
    
    _conditionTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, conditionView.frame.size.height-68) style:UITableViewStylePlain];

    [conditionView addSubview:_conditionTableView];
    
    _conditionTableView.delegate =self;
    _conditionTableView.dataSource = self;
    
}
//供求信息
#pragma mark ------addCompanySupplyANDDemandUI


-(void)addChooseBtn
{
    int height = 0;
    height = _conditionTableView.frame.origin.y+_conditionTableView.frame.size.height;
    chooseBackView =[[UIView alloc]initWithFrame:CGRectMake(0, height, 320, self.view.frame.size.height-height)];
    [self.view addSubview:chooseBackView];
    chooseBackView.backgroundColor =[UIColor whiteColor];
    UIView *linview =[[UIView alloc]initWithFrame:CGRectMake(0,0, 320, 1)];
    [chooseBackView addSubview:linview];
    
    linview.backgroundColor =[UIColor lightGrayColor];
    linview.alpha = 0.5;
    for (int btn=0; btn<2; btn++)
    {
        NSArray *titleArray =@[@"供应信息",@"求购信息"];
        
        UIButton *chooseBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [chooseBackView addSubview:chooseBtn];
        [chooseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [chooseBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        chooseBtn.frame =CGRectMake(20+btn%3*130, 10, 140, 20);
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
    for (int p=0; p<3; p++)
    {
        NSArray *companyArr =@[@"公司首页",@"企业动态",@"供求信息"];
        UIButton *companyBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:companyBtn];
        
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
    UIButton *button = (UIButton *)[self.view viewWithTag:20];
    [button setTitleColor:HexRGB(0x808080) forState:UIControlStateSelected];
    
    _selectedBtn.selected = NO;
    _selectedBtn = company;
    company.selected = YES;
    
    if (company.tag == 20)
    {
        [_refreshView endRefreshing];
        //[conditionView removeFromSuperview];
        
        conditionView.hidden = YES;
        self.companyHom.hidden = NO;
        
        [button setTitleColor:HexRGB(0x069dd4) forState:UIControlStateSelected];
        //[_companyHomeScrollView removeFromSuperview];
        
        _companyHomeScrollView.hidden = NO;
        
        
        //chooseBackView.hidden = YES;
        
    }else if(company.tag ==21)
    {
        _conditionTableView.frame = CGRectMake(0, 0, kWidth, conditionView.frame.size.height-68);
        [self.view bringSubviewToFront:conditionView];
        //[self.companyHom removeFromSuperview];
        self.companyHom.hidden = YES;
        
        
        //chooseBackView.hidden = YES;
        _companyHomeScrollView.hidden = YES;

        conditionView.hidden = NO;
        [self companyRequest];
        
        
    }else if(company.tag ==22){
        
        _conditionTableView.frame =CGRectMake(0, 0, kWidth, conditionView.frame.size.height-100);
        [self.view bringSubviewToFront:conditionView];
        [self.view bringSubviewToFront:chooseBackView];
        //[self.companyHom removeFromSuperview];
        _companyHomeScrollView.hidden = YES;
        
        self.companyHom.hidden = YES;
        
        conditionView.hidden = NO;
        
        chooseBackView.hidden = NO;
        
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
}


#pragma mark --tableViewDatasource
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
            [supplyCell.supplyImage setImageWithURL:[NSURL URLWithString:item.image] placeholderImage:[UIImage imageNamed:@"loading.png"]];
            supplyCell.selectionStyle = UITableViewCellSelectionStyleNone;
            supplyCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            if (_companyNEWArray.count > 0)
            {
                comContent *conNew =[_companyNEWArray objectAtIndex:indexPath.row];
                
                cell.TitleLabel.text =conNew.title;
                cell.dateLabel.text =conNew.create_time;
                cell.contentLabel.text =conNew.description;
            }
        }
        
        return cell;
    }
    
}



@end

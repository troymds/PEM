//
//  findViewController.m
//  PEM
//
//  Created by YY on 14-8-27.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "findViewController.h"
#import "findSupplyCel.h"
#import "findDemandCell.h"
#import "xiangqingViewController.h"
#import "qiugouXQ.h"
#import "supplyTool.h"
#import "yySupplyModel.h"
#import "demandTool.h"
#import "yyDemandModel.h"
#import "MJRefresh.h"
#import "HttpTool.h"
#import "hotOrderMoedl.h"
#import "RemindView.h"
#import "UIImageView+WebCache.h"
@interface findViewController ()<MJRefreshBaseViewDelegate>
{
    UIButton *_leftBtn;
    UIButton *_rigthBtn;
    UIButton *_rightBtnDemand;
    UIView * rightBackViw;
    UIView *rightBackViewDemand;
    UIView *leftBackView;
    BOOL isLeft;
    BOOL isRight;
    
    UIView *linBackView;
    MJRefreshHeaderView *MJHeadView;
    MJRefreshFooterView *MJFootView;
    
    UILabel *dataLabel;

    
}
@end

@implementation findViewController
@synthesize tableView=_tableView;
@synthesize selectedFind=_selectedFind,CateDemandArray=_CateDemandArray,CateSupplyArray=_CateSupplyArray,CetCategoryListArray =_CetCategoryListArray;
@synthesize cateIndex;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (IsIos7) {
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }

    self.title = [NSString stringWithFormat:@"%@分类",_titleLabel];
    self.view.backgroundColor =[UIColor whiteColor];
    _selectedFind =[[UIButton alloc]init];
    _supplyBtnPice =[[UIButton alloc]init];

    _CateSupplyArray =[[NSMutableArray alloc]init];
    _CateDemandArray =[[NSMutableArray alloc]init];
   
   
    [self addRefreshViews];
    
    [self addTableView];
    [self addShowNoDataView];

    linBackView =[[UIView alloc]init];
    linBackView.frame=CGRectMake(0, 0, 320, 30);
    linBackView.backgroundColor =HexRGB(0xe1e9e9);
    [self.view addSubview:linBackView];
    [self addLeftSegment];
    [self addRigthSegment];
    // 显示指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载中...";
    hud.dimBackground = YES;
    [supplyTool CategoryStatusesWithSuccesscategory:^(NSArray *statues) {
        if (statues.count > 0) {
            dataLabel.hidden = YES;
            _tableView.hidden = NO;
        }else
        {if (statues.count==0){
            _tableView.hidden = YES;
            dataLabel.hidden = NO;
        }
        else {
            [RemindView showViewWithTitle:@"数据已全部加载完毕" location:BELLOW];
        }
        }
        
        [_CateSupplyArray addObjectsFromArray:statues];
        
        [_tableView reloadData];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        
        
        
    } CategoryId:cateIndex lastID:0? 0:[NSString stringWithFormat:@"%lu",[_CateSupplyArray count]-0] CategoryFailure:^(NSError *error) {
        
    }];



}

//#pragma mark 集成刷新控件
- (void)addRefreshViews
{
    NSLog(@"1111111");

    // 1.下拉刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.delegate = self;

    // 2.上拉加载更多
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.delegate = self;
}

//#pragma mark 刷新代理方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    NSLog(@"222222");

    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) {
        // 上拉加载更多
        [self loadViewStatuses:refreshView];
    } else {
        // 下拉刷新
        [self loadViewStatuses:refreshView];
    }
    
    
}


-(void)loadViewStatuses:(MJRefreshBaseView *)refreshView{
    
    [supplyTool CategoryStatusesWithSuccesscategory:^(NSArray *statues) {
        if (statues.count > 0) {
            dataLabel.hidden = YES;
            _tableView.hidden = NO;
        }else
        {if (statues.count==0){
            _tableView.hidden = YES;
            dataLabel.hidden = NO;
        }
        else {
            [RemindView showViewWithTitle:@"数据已全部加载完毕" location:BELLOW];
        }
        }

        [_CateSupplyArray addObjectsFromArray:statues];

        [demandTool DemandStatusesWithSuccess:^(NSArray *statues) {
            
            if (statues.count > 0) {
                dataLabel.hidden = YES;
                _tableView.hidden = NO;
            }else
            {if (statues.count==0){
                _tableView.hidden = YES;
                dataLabel.hidden = NO;
            }
            else{
                [RemindView showViewWithTitle:@"数据已全部加载完毕" location:BELLOW];
            }
            }
            [_CateDemandArray addObjectsFromArray:statues];
            
            [_tableView reloadData];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
        } DemandId:cateIndex lastID:0? 0:[NSString stringWithFormat:@"%u",[_CateDemandArray count]-0] DemandFailure:^(NSError *error) {
            
        }];
        

        
        
       

    } CategoryId:cateIndex lastID:0? 0:[NSString stringWithFormat:@"%u",[_CateSupplyArray count]-0] CategoryFailure:^(NSError *error) {
        
    }];
    [_tableView reloadData];

    [refreshView endRefreshing];

    
    
    
  

}
- (void)addShowNoDataView
{
    
    dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 320, 44)];
    dataLabel.textAlignment = NSTextAlignmentCenter;
    dataLabel.backgroundColor = [UIColor clearColor];
    dataLabel.text = @"没有数据！";
    dataLabel.hidden = YES;
    dataLabel.enabled = NO;
    [self.view addSubview:dataLabel];
}
-(void)addLeftSegment
{

    //   左边 选项
    _leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_leftBtn];
    _leftBtn.frame =CGRectMake(0, 0, kWidth/2, 30);
    [_leftBtn setTitle:@"供应信息" forState:UIControlStateNormal];
    
    [_leftBtn setTitleColor:HexRGB(0x666666) forState:UIControlStateNormal];
    _leftBtn.selected = YES;
    _leftBtn.titleLabel.font =[UIFont systemFontOfSize:14];
    [_leftBtn addTarget:self action:@selector(leftXuankaBtn:) forControlEvents:UIControlEventTouchUpInside];
    
     [_leftBtn setImage:[UIImage imageNamed:@"nav_under.png"] forState:UIControlStateSelected];

     [_leftBtn setImage:[UIImage imageNamed:@"nav_under_btnselected.png"] forState:UIControlStateNormal];
   
    _leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    _leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,-120);

  }
-(void)leftSegment{
    leftBackView =[[UIView alloc]initWithFrame:CGRectMake(kWidth/7, 30, 95, 50)];
    [self.view addSubview:leftBackView];
    [self.view bringSubviewToFront:leftBackView];
    UIImageView *kuangImage =[[UIImageView alloc]init];
    kuangImage.frame = CGRectMake(-15, -37, 130, 110);
    kuangImage.image =[UIImage imageNamed:@"xialakuang.png"];
    [leftBackView addSubview:kuangImage];
    kuangImage.userInteractionEnabled = YES;
    UIView *lin =[[UIView alloc]init];
    lin.frame=CGRectMake(15, 61, 97, 1);
    lin.backgroundColor =HexRGB(0xefeded);
    [kuangImage addSubview:lin];

    NSArray *sea =@[@"供应信息",@"求购信息"];
    for (int l=0; l<2; l++)
    {
        UIButton * sear =[UIButton buttonWithType:UIButtonTypeCustom];
        [kuangImage addSubview:sear];
        [sear setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        sear.frame =CGRectMake(15, 39+l%3*(17+5), 97, 22);
        sear.titleLabel.font =[UIFont systemFontOfSize:14];
        [sear setTitle:sea[l] forState:UIControlStateNormal];
        sear.tag = 10+l;
        if (sear.tag ==10) {
        }
        [sear setBackgroundImage:[UIImage imageNamed:@"blackBg.png"] forState:UIControlStateHighlighted];
        [sear addTarget:self action:@selector(leftSegmentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }

}
-(void)addRigthSegment{
    //   右边 选项
    _rigthBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_rigthBtn];
    _rigthBtn.frame =CGRectMake(kWidth/2, 0, kWidth/2, 30);
    [_rigthBtn setTitle:@"浏览量" forState:UIControlStateNormal];
    [_rigthBtn setTitleColor:HexRGB(0x666666) forState:UIControlStateNormal];
    _rigthBtn.selected = YES;
    _rigthBtn.titleLabel.font =[UIFont systemFontOfSize:14];
    [_rigthBtn addTarget:self action:@selector(rightXuanka:) forControlEvents:UIControlEventTouchUpInside];
    [_rigthBtn setImage:[UIImage imageNamed:@"nav_under_btnselected.png"] forState:UIControlStateNormal];
    [_rigthBtn setImage:[UIImage imageNamed:@"nav_under.png"] forState:UIControlStateSelected];
    _rigthBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -80, 0, 0);
    _rigthBtn.imageEdgeInsets = UIEdgeInsetsMake(0,13,0,-30);
    
}

-(void)addRigthSegmentDemand{
    //   右边 选项
    _rightBtnDemand =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_rightBtnDemand];
    _rightBtnDemand.frame =CGRectMake(160, 0, 140, 30);
    [_rightBtnDemand setTitle:@"浏览量" forState:UIControlStateNormal];
    [_rightBtnDemand setTitleColor:HexRGB(0x666666) forState:UIControlStateNormal];
    _rightBtnDemand.selected = YES;
    _rightBtnDemand.titleLabel.font =[UIFont systemFontOfSize:14];
    [_rightBtnDemand addTarget:self action:@selector(rightXuankaDemand:) forControlEvents:UIControlEventTouchUpInside];
    [_rightBtnDemand setImage:[UIImage imageNamed:@"nav_under_btnselected.png"] forState:UIControlStateNormal];
    [_rightBtnDemand setImage:[UIImage imageNamed:@"nav_under.png"] forState:UIControlStateSelected];
    _rightBtnDemand.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    _rightBtnDemand.imageEdgeInsets = UIEdgeInsetsMake(0,13,0,-80);
    
}
-(void)rightSegment{
    rightBackViw =[[UIView alloc]initWithFrame:CGRectMake(kWidth/2+15, 30, 95, 50)];
    [self.view addSubview:rightBackViw];
    
    [self.view bringSubviewToFront:rightBackViw];
    UIImageView *rightImage =[[UIImageView alloc]init];
    rightImage.frame = CGRectMake(-15, -37, 130, 110);
    rightImage.image =[UIImage imageNamed:@"xialakuang.png"];
    [rightBackViw addSubview:rightImage];
    rightImage.userInteractionEnabled = YES;
    
    UIView *lin =[[UIView alloc]init];
    lin.frame=CGRectMake(15, 61, 97, 1);
    lin.backgroundColor =HexRGB(0xefeded);
    [rightImage addSubview:lin];

    NSArray *supply =@[@"浏览量",@"价   格"];


    for (int r=0; r<2; r++)
    {
        UIButton *supplyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [rightImage addSubview:supplyBtn];
        [supplyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        supplyBtn.frame =CGRectMake(15, 39+r%3*(17+5), 97, 22);
        supplyBtn.titleLabel.font =[UIFont systemFontOfSize:14];
        [supplyBtn setBackgroundImage:[UIImage imageNamed:@"blackBg.png"] forState:UIControlStateHighlighted];
        supplyBtn.tag = 50+r;

        [supplyBtn setTitle:supply[r] forState:UIControlStateNormal];

        
        [supplyBtn addTarget:self action:@selector(rightSegmentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }

    
}



-(void)rightSegmentDemand{
    rightBackViewDemand =[[UIView alloc]initWithFrame:CGRectMake(kWidth/2+15, 30, 95, 50)];
    [self.view addSubview:rightBackViewDemand];
    
    [self.view bringSubviewToFront:rightBackViewDemand];
    UIImageView *rightImage =[[UIImageView alloc]init];
    rightImage.frame = CGRectMake(-15, -37, 130, 110);
    rightImage.image =[UIImage imageNamed:@"xialakuang.png"];
    [rightBackViewDemand addSubview:rightImage];
    rightImage.userInteractionEnabled = YES;
    
    UIView *lin =[[UIView alloc]init];
    lin.frame=CGRectMake(15, 61, 97, 1);
    lin.backgroundColor =HexRGB(0xefeded);
    [rightImage addSubview:lin];
    
    NSArray *demand =@[@"浏览量",@"时   间"];
    
    
    for (int r=0; r<2; r++)
    {
        UIButton *demandBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [rightImage addSubview:demandBtn];
        [demandBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        demandBtn.frame =CGRectMake(15, 39+r%3*(17+5), 97, 22);
        demandBtn.titleLabel.font =[UIFont systemFontOfSize:14];
        [demandBtn setBackgroundImage:[UIImage imageNamed:@"blackBg.png"] forState:UIControlStateHighlighted];
        demandBtn.tag = 60+r;
        [demandBtn setTitle:demand[r] forState:UIControlStateNormal];
        
        
        [demandBtn addTarget:self action:@selector(rightSegmentDemandBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
}
#pragma mark addBigButton手势触摸
-(void)addBigButton{
   bigbutton =[UIButton buttonWithType:UIButtonTypeCustom];
    bigbutton.frame = CGRectMake(0, 30, kWidth, kHeight-30);

    bigbutton.backgroundColor =[UIColor whiteColor];
    bigbutton.alpha =0.1;
    bigbutton.selected = YES;
    [self.view addSubview:bigbutton];
    [bigbutton addTarget:self action:@selector(bigButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(void)addTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 30, kWidth, kHeight-90) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.backgroundColor =[UIColor whiteColor];
    
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;

    [self.view addSubview:_tableView];
}
#pragma mark --选择卡
-(void)leftXuankaBtn:(UIButton *)leftbtn
{

    
    leftbtn.selected=!leftbtn.selected;

    if (leftbtn.selected ==NO) {
        [self addBigButton];
        _rightBtnDemand.selected = YES;
        _rigthBtn.selected = YES;
        [rightBackViw removeFromSuperview];
        [rightBackViewDemand removeFromSuperview];
        [self leftSegment];

    }else{
        [bigbutton removeFromSuperview];

        [leftBackView removeFromSuperview];

    }
    
    
}

-(void)bigButtonClick:(UIButton *)bigSender{
    if (bigSender.selected==YES) {

        _leftBtn.selected = YES;
        _rigthBtn.selected = YES;
        _rightBtnDemand.selected = YES;
        [bigbutton removeFromSuperview];
        
        [leftBackView removeFromSuperview];
        [rightBackViw removeFromSuperview];
        [rightBackViewDemand removeFromSuperview];

    }else{
        _leftBtn.selected = NO;
        _rightBtnDemand.selected = NO;
        _rightBtnDemand.selected = NO;
        [bigbutton removeFromSuperview];
        
        [leftBackView removeFromSuperview];
        [rightBackViw removeFromSuperview];
        [rightBackViewDemand removeFromSuperview];


    }
    
    

}
-(void)rightXuanka:(UIButton *)rightBtn{
    rightBtn.selected = !rightBtn.selected;
    if (rightBtn.selected ==NO) {
        _leftBtn.selected =YES;
        [bigbutton removeFromSuperview];
        [leftBackView removeFromSuperview];
        [self addBigButton];
        [self rightSegment];



    }else{

        [rightBackViw removeFromSuperview];
        [bigbutton removeFromSuperview];
    }
}
-(void)rightXuankaDemand:(UIButton *)demand{
    demand.selected = !demand.selected;
    if (demand.selected ==NO) {
        _leftBtn.selected = YES;

        [bigbutton removeFromSuperview];
        [leftBackView removeFromSuperview];
        [self addBigButton];
        [self rightSegmentDemand];

       

    }else{
        [rightBackViewDemand removeFromSuperview];
        [bigbutton removeFromSuperview];
       
    }

}
-(void)leftSegmentBtnClick:(UIButton *)sender{
    
    
    if (sender.tag ==11) {
        
        [_rigthBtn removeFromSuperview];
        [_rightBtnDemand removeFromSuperview];

        [self addRigthSegmentDemand];
        [_rigthBtn removeFromSuperview];
        [rightBackViw removeFromSuperview];
        [bigbutton removeFromSuperview];
       
    }else{
        
        [_rigthBtn removeFromSuperview];
        [_rightBtnDemand removeFromSuperview];
       [self addRigthSegment];
        [_rightBtnDemand removeFromSuperview];
        [rightBackViewDemand removeFromSuperview];
        [bigbutton removeFromSuperview];

    }
    
   _selectedFind.tag = sender.tag;
    sender.selected =!sender.selected;
    if (sender.selected==YES) {
        _leftBtn.selected = YES;
    }else{
        _leftBtn.selected = NO;
    }

    [_tableView reloadData];
    sender.selected =!sender.selected;
    
    [leftBackView removeFromSuperview];
    NSString *currentTitle = sender.currentTitle;
    [_leftBtn setTitle:currentTitle forState:UIControlStateNormal];
    [_leftBtn setTitleColor:HexRGB(0x069dd4) forState:UIControlStateSelected];
    [_leftBtn setImage:[UIImage imageNamed:@"up_pre.png"] forState:UIControlStateSelected];
    [_leftBtn setImage:[UIImage imageNamed:@"nav_under.png"] forState:UIControlStateNormal];

    
    
    
    
}

-(void)rightSegmentBtnClick:(UIButton *)sender
{
    
    _supplyBtnPice.tag = sender.tag;

    sender.selected =!sender.selected;
    if (sender.selected==YES) {
        _rigthBtn.selected = YES;
        _leftBtn.selected = YES;
        [bigbutton removeFromSuperview];
            }
    else{
        _rigthBtn.selected = NO;
        [bigbutton removeFromSuperview];


    }
    [rightBackViw removeFromSuperview];

    NSString *currentTitle = sender.currentTitle;
    [_rigthBtn setTitle:currentTitle forState:UIControlStateNormal];
    [_rigthBtn setTitleColor:HexRGB(0x069dd4) forState:UIControlStateSelected];
    [_rigthBtn setImage:[UIImage imageNamed:@"up_pre.png"] forState:UIControlStateSelected];
    [_rigthBtn setImage:[UIImage imageNamed:@"nav_under.png"] forState:UIControlStateNormal];

    
    if (sender.tag ==50) {
        NSLog(@"%ld",(long)sender.tag);
//        // 显示指示器
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"正在加载中...";
        hud.dimBackground = YES;

        [_CateSupplyArray removeAllObjects];
        [_tableView reloadData];
        [hotOrderMoedl CategoryStatusesWithSuccesscategory:^(NSArray *statues) {
            
            [_CateSupplyArray addObjectsFromArray:statues];
            [_tableView reloadData];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }cateId:cateIndex supplyHot:@"read_num" lastID:0?0:[NSString stringWithFormat:@"%u",[_CateSupplyArray count]-0] CategoryFailure:^(NSError *error) {
            
        }];

        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"正在加载中...";
        hud.dimBackground = YES;

        [_CateSupplyArray removeAllObjects];
        [_tableView reloadData];

        [hotOrderMoedl CategoryStatusesWithSuccesscategory:^(NSArray *statues) {
            
                [_CateSupplyArray addObjectsFromArray:statues];
                [_tableView reloadData];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
            
            
            
        }cateId:cateIndex supplyHot:@"price" lastID:0?0:[NSString stringWithFormat:@"%u",[_CateSupplyArray count]-0] CategoryFailure:^(NSError *error) {
            
        }];
        


    }
    
}

-(void)rightSegmentDemandBtnClick:(UIButton *)demand{
    

    demand.selected =!demand.selected;
    if (demand.selected==YES) {
        _rightBtnDemand.selected = YES;
        [bigbutton removeFromSuperview];
        [rightBackViewDemand removeFromSuperview];

    }else{
        _rightBtnDemand.selected = NO;
        [bigbutton removeFromSuperview];
//        [rightBackViewDemand removeFromSuperview];

    }
    NSString *currentTitle = demand.currentTitle;
    [_rightBtnDemand setTitle:currentTitle forState:UIControlStateNormal];
    [_rightBtnDemand setTitleColor:HexRGB(0x069dd4) forState:UIControlStateSelected];
    [_rightBtnDemand setImage:[UIImage imageNamed:@"up_pre.png"] forState:UIControlStateSelected];
    [_rightBtnDemand setImage:[UIImage imageNamed:@"nav_under.png"] forState:UIControlStateNormal];
    

    
    if (demand.tag ==60) {
        //    // 显示指示器
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"正在加载中...";
        hud.dimBackground = YES;

        [_CateDemandArray removeAllObjects];
        [_tableView reloadData];

            [hotOrderMoedl CategoryStatusesWithSuccesscategory:^(NSArray *statues) {
           
                [_CateDemandArray addObjectsFromArray:statues];

                [_tableView reloadData];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            
            
        }cateId:cateIndex demandHot:@"read_num" lastID:0?0:[NSString stringWithFormat:@"%u",[_CateDemandArray count]-0] CategoryFailure:^(NSError *error) {
            
        }];

        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }else{
        //    // 显示指示器
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"正在加载中...";
        hud.dimBackground = YES;
        [_CateDemandArray removeAllObjects];
        [_tableView reloadData];

        [hotOrderMoedl CategoryStatusesWithSuccesscategory:^(NSArray *statues) {
            
                [_CateDemandArray addObjectsFromArray:statues];
                [_tableView reloadData];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            
            
        }cateId:cateIndex demandHot:@"time" lastID:0?0:[NSString stringWithFormat:@"%u",[_CateDemandArray count]-0] CategoryFailure:^(NSError *error) {
            
        
            
        }];
        
        
        
    }

    
    

}
#pragma mark----tableView
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     if (_selectedFind.tag ==11) {
         qiugouXQ  *xiangq =[[qiugouXQ alloc]init];
         yyDemandModel *demand =[_CateDemandArray objectAtIndex:indexPath.row];
         xiangq.demandIndex = demand.demandid;

    [self.navigationController pushViewController:xiangq animated:YES];
     }else{
        xiangqingViewController *supply =[[xiangqingViewController alloc]init];

         
         yySupplyModel *model = [_CateSupplyArray objectAtIndex:indexPath.row];
         supply.supplyIndex = model.supplyId;
         [self.navigationController pushViewController:supply animated:YES];
     }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_selectedFind.tag ==11) {
        return _CateDemandArray.count;
        
    }else{
        return _CateSupplyArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_selectedFind.tag ==11) {
        static NSString *cellIndexfider =@"cell";
        findDemandCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIndexfider];
        if (!cell) {
            cell =[[findDemandCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
        }
        
        if (_CateDemandArray.count>0) {
            yyDemandModel *d =_CateDemandArray [indexPath.row];
            cell.dateLabel.text =d.demandDate;
            cell.demand_numLabel.text =[NSString stringWithFormat:@"求购数量:%@",d.buy_num];
            cell.nameLabel.text =d.name;
            cell.contentLabel.text = d.Introduction;
            cell.read_numLabel.text = [NSString stringWithFormat:@"浏览量%@次",d.read_num];
            dataLabel.hidden = YES;
            _tableView.hidden = NO;
        }else{
            dataLabel.hidden = NO;
            _tableView.hidden = YES;
            
        }
        
              return cell;

    }else{
        
        static NSString *cellIndexfider =@"cell1";
        findSupplyCel *cell =[tableView dequeueReusableCellWithIdentifier:cellIndexfider];
        if (!cell) {
            cell =[[findSupplyCel alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
        }
        

        if (_CateSupplyArray.count>0) {

        yySupplyModel *s =_CateSupplyArray [indexPath.row];

        cell.companyLabel.text =s.company;
        cell.nameLabel.text =s.name;
        cell.read_numLabel.text =[NSString stringWithFormat:@"浏览量%@次",s.read_num];
        [cell.supplyImage setImageWithURL:[NSURL URLWithString:s.image] placeholderImage:[UIImage imageNamed:@"log.png"]];
        cell.supply_numLabel.text =[NSString stringWithFormat:@"%@起批",s.min_supply_num];
        cell.priceLabel.text =[NSString stringWithFormat:@"￥%@",s.price];
            dataLabel.hidden = YES;
            _tableView.hidden = NO;
        }else {
            dataLabel.hidden = NO;
            _tableView.hidden = YES;
        }
      return cell;
        
    }
   
   }
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72 ;
}

@end

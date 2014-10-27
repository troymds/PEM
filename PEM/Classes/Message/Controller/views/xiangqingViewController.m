//
//  xiangqingViewController.m
//  PEM
//
//  Created by YY on 14-8-27.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "xiangqingViewController.h"
#import "XQgetInfoTool.h"
#import "XQgetInfoDetailModel.h"
#import "phoneView.h"
#import "UIImageView+WebCache.h"
#import "CompanyXQViewController.h"
#import "collocetAddToWishlistTool.h"
#import "SupplyController.h"
#import "supplyWishlistidModel.h"
#import "SystemConfig.h"
#import "RemindView.h"
#import "RegisterContrller.h"
#import "FindSecretController.h"

@interface phoneView ()

@end
@interface xiangqingViewController ()
{
    UIScrollView *_backScrollView;
    UIImageView *bImag;
    
    
}
@end

@implementation xiangqingViewController
@synthesize supplyIndex,XQArray,phoneLabel,hearImage,company_Id;
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
    
    // xingQingId 发送请求的参数
    XQArray =[[NSMutableArray alloc]init];
    _wishlistidArray =[[NSMutableArray alloc]initWithCapacity:0];
    [self loadStatusView];
    self.view.backgroundColor =[UIColor whiteColor];
    
    
    UIView *navBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth-90, 44)];
    self.navigationItem.titleView =navBgView;
    navBgView.backgroundColor =[UIColor clearColor];
    UILabel *titleLabele =[[UILabel alloc]init];
    [navBgView addSubview:titleLabele];
    titleLabele.frame = CGRectMake((kWidth-90-80)*0.5, 0, 80, 44);
    titleLabele.backgroundColor =[UIColor clearColor];

    titleLabele.text =@"产品详情";
    titleLabele.font = [UIFont systemFontOfSize:PxFont(26)];
    

}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    webheight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    _gyWebView.frame = CGRectMake(0, 325, kWidth, webheight+10);
    _backScrollView.contentSize = CGSizeMake(kWidth,webheight+380);
    
    
    
}

-(void)loadStatusView{
    
    // 显示指示器

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载中...";
    hud.dimBackground = YES;
    
    [XQgetInfoTool statusesWithSuccess:^(NSArray *statues) {
        
        [XQArray addObject:statues];
        [self addAabstract];
        [self showNewStatusCount];
        XQgetInfoDetailModel *xq = [statues objectAtIndex:0];
        _wishlist_id = xq.wishlistid;
        //判断收藏按钮的应该显示的状态
        UIButton *button = (UIButton *)[self.view viewWithTag:2000];
        if ([xq.xqinwishlist isEqualToString:@"1"]) {
            button.selected = YES;
        }else{
            button.selected = NO;
        }
        
        

        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(NSError *error) {
        
    } infoID:supplyIndex];
    
 
}



#pragma mark 展示错误提示
- (void)showNewStatusCount
{
    
    XQgetInfoDetailModel *xqModel =[[XQArray objectAtIndex:0]objectAtIndex:0];
    
    if ([xqModel.verify_result isEqualToString:@"0"])
    {
        UIView *failView=[[UIView alloc]initWithFrame:CGRectMake(0, -35, kWidth, 35)];
        [self.view addSubview:failView];
        UIView *failLin =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 5)];
        failLin.backgroundColor =HexRGB(0xe6e3e4);
        failView.backgroundColor =HexRGB(0xffffff);
        [failView addSubview:failLin];
        
        UIButton *failBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [failView addSubview:failBtn];
        failBtn.frame =CGRectMake(20, 5, 260, 30);
        [failBtn setTitle:@"  等待审核。。。" forState:UIControlStateNormal];
        [failBtn setImage:[UIImage imageNamed:@"home_btn.png"] forState:UIControlStateNormal];
        failBtn.titleLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        [failBtn setTitleColor:HexRGB(0xff7300) forState:UIControlStateNormal];
        
    }else if([xqModel.verify_result isEqualToString:@"2"]){
        UIView *failView=[[UIView alloc]initWithFrame:CGRectMake(0, -35, kWidth, 35)];
        [self.view addSubview:failView];
        UIView *failLin =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 5)];
        failLin.backgroundColor =HexRGB(0xe6e3e4);
        failView.backgroundColor =HexRGB(0xffffff);
        [failView addSubview:failLin];
        
        UIButton *failBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [failView addSubview:failBtn];
        failBtn.frame =CGRectMake(20, 5, 260, 30);
        [failBtn setTitle:xqModel.verify_reason forState:UIControlStateNormal];
        [failBtn setImage:[UIImage imageNamed:@"home_btn.png"] forState:UIControlStateNormal];
        failBtn.titleLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        [failBtn setTitleColor:HexRGB(0xff7300) forState:UIControlStateNormal];
        
        UIButton *goBackBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [failView addSubview:goBackBtn];
        goBackBtn.frame =CGRectMake(270, 5, 40, 30);
        [goBackBtn setImage:[UIImage imageNamed:@"home_Jump.png"] forState:UIControlStateNormal];
        [goBackBtn addTarget:self action:@selector(goBackFalseClick) forControlEvents:UIControlEventTouchUpInside];
        [UIView animateWithDuration:0.5 animations:^{
            failView.frame =CGRectMake(0, 0, kWidth, 35);
        }];
        
        
    }else{
        
    }
}
-(void)goBackFalseClick{
    SupplyController *supply =[[SupplyController alloc]init];
   supply.title = @"编辑供应信息";
    supply.info_id =supplyIndex;
    [self.navigationController pushViewController:supply animated:YES];
    
}


-(void)addAabstract{
#pragma mark计算宽高
    XQgetInfoDetailModel *xqModel =[[XQArray objectAtIndex:0]objectAtIndex:0];
    CGFloat nameWeight;
    if ([[SystemConfig sharedInstance].company_id isEqualToString:xqModel.company_id]) {
        
        nameWeight =[xqModel.titleGetInfo sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(300, 60)].height;
        
    }else{
        nameWeight =[xqModel.titleGetInfo sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(125, 60)].height;
        
    }

    _backScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    _backScrollView.userInteractionEnabled=YES;
    _backScrollView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_backScrollView];
    _backScrollView.bounces = NO;
    _backScrollView.showsVerticalScrollIndicator = NO;
    _backScrollView.showsHorizontalScrollIndicator = NO;

   
    
    hearImage =[[UIImageView alloc]init];
    hearImage.frame =CGRectMake(0,0, kWidth, 160);
    hearImage.userInteractionEnabled = YES;
    [_backScrollView addSubview:hearImage];
    
    
    if (xqModel.url_3d ==nil) {
        [hearImage setImageWithURL:[NSURL URLWithString:xqModel.imageGetInfo] placeholderImage:[UIImage imageNamed:@"load_big.png"] options:(SDWebImageLowPriority||SDWebImageRetryFailed)];

    }else{
        
        UIWebView *webview_3d = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 160)];
        webview_3d.userInteractionEnabled = NO;
        [_backScrollView addSubview:webview_3d];
        [webview_3d loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:xqModel.url_3d]]];
   }
    
#pragma mark-----收藏
    
    
     collectBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [_backScrollView addSubview:collectBtn];
    [collectBtn setImage:[UIImage imageNamed:@"home_favorite.png"] forState:UIControlStateNormal];
    [collectBtn setImage:[UIImage imageNamed:@"xunjia_selecte2.png"] forState:UIControlStateSelected];

    collectBtn.tag = 2000;
    [collectBtn addTarget:self action:@selector(collectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    collectBtn.frame =CGRectMake(280, 185, 35, 35);
    
    
    
     phonBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [_backScrollView addSubview:phonBtn];
    [phonBtn setImage:[UIImage imageNamed:@"xunji1.png"] forState:UIControlStateNormal];
    [phonBtn setImage:[UIImage imageNamed:@"xunjia_selecte1.png"] forState:UIControlStateHighlighted];

    phonBtn.frame =CGRectMake(240, 185, 35, 35);
    [phonBtn addTarget:self action:@selector(bodaBtn:) forControlEvents:UIControlEventTouchUpInside];
  
       
    
    
    

     //标题
    nameLable =[[UILabel alloc]init];
    nameLable.text = xqModel.titleGetInfo;
    nameLable.backgroundColor =[UIColor clearColor];
    nameLable.numberOfLines = 3;
    nameLable.font =[UIFont systemFontOfSize:15];

    [_backScrollView addSubview:nameLable];
    nameLable.textColor =HexRGB(0x3a3a3a);
    
      //价格
    UILabel *picLabel =[[UILabel alloc]init];
    
    
    if ([xqModel.price isEqualToString:@"0"]) {
        picLabel.text=@"价格:面议";
    }else{
        picLabel.text =[NSString stringWithFormat:@"￥%@",xqModel.price];
        
    }

    picLabel.textColor =HexRGB(0xff7300);
    picLabel.frame =CGRectMake(10,175+nameWeight,180, 20);
    [_backScrollView addSubview:picLabel];
    picLabel.font =[UIFont systemFontOfSize:PxFont(30)];

    //    起价
    for (int l=0; l<3; l++) {
        NSArray *labelArray =@[[NSString stringWithFormat:@"%@起供应",xqModel.min_sell_num],[NSString stringWithFormat:@"浏览%@次",xqModel.read_num],[NSString stringWithFormat:@"%@",xqModel.region]];
        UILabel *linLabel =[[UILabel alloc]init];
        linLabel.text =labelArray[l];
        linLabel.backgroundColor =[UIColor clearColor];
        linLabel.textAlignment =NSTextAlignmentCenter;
        
        linLabel.frame =CGRectMake(20+l%3*((kWidth-30)/3),210+nameWeight, (kWidth-40)/3, 20);
        [_backScrollView addSubview:linLabel];
        
        linLabel.font =[UIFont systemFontOfSize:10];
        linLabel.textColor =HexRGB(0x666666);
    }
    
//线条
    
    for (int i =0; i<2; i++) {
        UIView *line=[[UIView alloc]init];
        line.frame =CGRectMake(0, 205+nameWeight+i%3*(30), kWidth, 1);
        [_backScrollView addSubview:line];
        line.alpha = 0.5;
        line.backgroundColor =[UIColor lightGrayColor];
    }
    
    
     li =[[UIView alloc]init];
    li.frame =CGRectMake(230, 185, 1, 10+nameWeight);
    [_backScrollView addSubview:li];
    li.backgroundColor =[UIColor lightGrayColor];
    li.alpha = 0.5;
    
    UILabel *xinagq =[[UILabel alloc]init];
    xinagq.text =@"【产品详情】";
    xinagq.frame =CGRectMake(5,245+nameWeight, 200, 20);
    [_backScrollView addSubview:xinagq];
    xinagq.font =[UIFont systemFontOfSize:PxFont(24)];
    
    _gyWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 280+nameWeight, kWidth, 400)];
    [_gyWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:xqModel.description]]];
    _gyWebView.userInteractionEnabled = NO;
    _gyWebView.delegate =self;
    
    [_backScrollView addSubview:_gyWebView];


    //底部
    UIButton  *forImage =[UIButton buttonWithType:UIButtonTypeCustom];
    forImage.frame =CGRectMake(0, self.view.frame.size.height-44, kWidth, 44);
    [forImage addTarget:self action:@selector(goCompanyBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:forImage];
    forImage.backgroundColor =backGroundColor;
    
    
    UILabel *nameCopany =[[UILabel alloc]init];
    nameCopany.text = xqModel.company_name;
    nameCopany.backgroundColor =[UIColor clearColor];
    CGFloat nameCompanyw =[xqModel.company_name sizeWithFont:[UIFont systemFontOfSize:PxFont(18)] constrainedToSize:CGSizeMake(210, 30)].width;
    [forImage addSubview:nameCopany];
    nameCopany.frame =CGRectMake(18, 0, 210, 44);
    nameCopany.font =[UIFont systemFontOfSize:PxFont(18)];
    
    UIButton *goCompany =[UIButton buttonWithType:UIButtonTypeCustom];
    [forImage addSubview:goCompany];
    [goCompany setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    goCompany.frame = CGRectMake(280, 0, 40, 44);
    [goCompany setImage:[UIImage imageNamed:@"home_Jump_Black_btn.png"] forState:UIControlStateNormal];
       [goCompany addTarget:self action:@selector(goCompanyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //vip
    UIImageView * _companyImgVip = [[UIImageView alloc] initWithFrame:CGRectMake(nameCompanyw+20,10, 18, 25)];
    
    if ([xqModel.vip_type isEqualToString:@"1"]) {
        _companyImgVip.image =[UIImage imageNamed:@"Vip4.png"];
    }
    else  if ([xqModel.vip_type isEqualToString:@"2"]) {
        _companyImgVip.image =[UIImage imageNamed:@"Vip3.png"];
        
    } else if([xqModel.vip_type isEqualToString:@"3"]) {
        _companyImgVip.image =[UIImage imageNamed:@"Vip2.png"];
        
    }else if([xqModel.vip_type isEqualToString:@"0"]){
        
        _companyImgVip.image =[UIImage imageNamed:@"Vip1.png"];
    }
    else if([xqModel.vip_type isEqualToString:@"0"]){
        
        _companyImgVip.image =[UIImage imageNamed:@"Vip5.png"];
    }else if([xqModel.vip_type isEqualToString:@"-1"]){
        
        _companyImgVip.image =[UIImage imageNamed:@"Vip6.png"];
    }
    
  
    
    [forImage addSubview:_companyImgVip];

    if ([[SystemConfig sharedInstance].company_id isEqualToString:xqModel.company_id]) {
        
        collectBtn.hidden =YES;
        phonBtn.hidden = YES;
        li.hidden = YES;

        nameLable.frame =CGRectMake(10,170, 300, nameWeight);
        
        
    }else{
        collectBtn.hidden =NO;
        phonBtn.hidden = NO;
        li.hidden = NO;

        nameLable.frame =CGRectMake(10,170, 220, nameWeight);
        
        
    }

  }
#pragma mark webView



-(void)goCompanyBtnClick:(UIButton *)go{
    
    CompanyXQViewController *xqVC = [[CompanyXQViewController alloc]init];
    
    XQgetInfoDetailModel *comID =[[XQArray objectAtIndex:0]objectAtIndex:0];
    xqVC.companyName = comID.company_name;
    xqVC.companyID =comID.company_id;
    
    [self.navigationController pushViewController:xqVC animated:YES];

    
}
#pragma mark 收藏产品信息
-(void)collectionBtnClick:(UIButton *)collect{

       if (collect.selected ==YES) {
           NSLog(@"%@",_wishlist_id);
        [collocetAddToWishlistTool cancleWishlistStatusesWithSuccesscategory:^(NSArray *statues) {
            [_wishlistidArray addObjectsFromArray:statues];
            

             supplyWishlistidModel *supWishlist =[_wishlistidArray objectAtIndex:0];
            if ([supWishlist.code isEqualToString:@"100"]) {
                [RemindView showViewWithTitle:@"取消收藏成功!" location:BELLOW];
                
                //如果是从我的收藏页面进来的  取消收藏时刷新我的收藏页面
                if ([self.delegate respondsToSelector:@selector(reloadData)]) {
                    [self.delegate reloadData];
                }
                
                collect.selected = !collect.selected;
                
            }else{
                [RemindView showViewWithTitle:supWishlist.msg location:BELLOW];

            }
            
        }companyID:[SystemConfig sharedInstance].company_id wishlistidID:_wishlist_id wishlistFailure:^(NSError *error) {
            
        }];

    }else{
        if (![SystemConfig sharedInstance].isUserLogin){
            CGRect frame = [UIScreen mainScreen].bounds;
            _loginView = [[LoginView alloc] initWithFrame:frame];
            _loginView.delegate = self;
            [_loginView showView];
        }else{
            
            [collocetAddToWishlistTool CategoryStatusesWithSuccesscategory:^(NSArray *statues) {
                supplyWishlistidModel *model = [statues objectAtIndex:0];
                if ([model.code intValue] == 100) {
                    collect.selected = !collect.selected;
                    _wishlist_id = model.wishlistId;
                    [RemindView showViewWithTitle:@"收藏成功!" location:BELLOW];
                    
                    if ([self.delegate respondsToSelector:@selector(reloadData)]) {
                        [self.delegate reloadData];
                    }

                }else{
                    [RemindView showViewWithTitle:model.msg location:BELLOW];
                }
                
                
            } companyID:[SystemConfig sharedInstance].company_id infoID:supplyIndex CategoryFailure:^(NSError *error) {
                
            }];
            
        }
       }
}

- (void)btnDown:(UIButton *)btn
{
    switch (btn.tag){
            //登陆
        case LOGIN_TYPE:
        {
            NSDictionary *parms = [NSDictionary dictionaryWithObjectsAndKeys:_loginView.userField.text,@"phonenum",_loginView.passwordField.text,@"password", nil];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"登录中...";
            [HttpTool postWithPath:@"login" params:parms success:^(id JSON){
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
                NSDictionary *dic = [result objectForKey:@"response"];
                if (dic) {
                    NSString *code = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"code"] intValue]];
                    if ([code isEqualToString:@"100"]){
                        
                        [[NSUserDefaults standardUserDefaults] setObject:_loginView.userField.text forKey:@"userName"];
                        [[NSUserDefaults standardUserDefaults] setObject:_loginView.passwordField.text forKey:@"secret"];
                        
                        NSDictionary *data = [dic objectForKey:@"data"];
                        [SystemConfig sharedInstance].isUserLogin = YES;
                        if (isNull(data, @"company_id")){
                            [SystemConfig sharedInstance].company_id = @"-1";
                        }else{
                            int company_id = [[data objectForKey:@"company_id"] intValue];
                            [SystemConfig sharedInstance].company_id = [NSString stringWithFormat:@"%d",company_id];
                        }
                        if (isNull(data, @"viptype")) {
                            [SystemConfig sharedInstance].viptype = @"-3";
                        }else{
                            NSInteger vipType = [[data objectForKey:@"viptype"] intValue];
                            [SystemConfig sharedInstance].viptype = [NSString stringWithFormat:@"%ld",(long)vipType];
                        }
                        CompanyInfoItem *item = [[CompanyInfoItem alloc] initWithDictionary:data];
                        [SystemConfig sharedInstance].companyInfo = item;
                        
                        [self getVipInfo:[SystemConfig sharedInstance].company_id];
                        
                    }else{
                        [RemindView showViewWithTitle:@"用户名或密码错误" location:MIDDLE];
                    }
                }
            }failure:^(NSError *error){
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
            }];
        }
            break;
            //寻找密码
        case FIND_TYPE:
        {
            FindSecretController *fsc = [[FindSecretController alloc] init];
            [self.navigationController pushViewController:fsc animated:YES];
        }
            break;
            //注册
        case REGIST_TYPE:
        {
            RegisterContrller *rsc = [[RegisterContrller alloc] init];
            [self.navigationController pushViewController:rsc animated:YES];
        }
            break;
        default:
            break;
    }
    
}

//获取用户VIP信息
- (void)getVipInfo:(NSString *)company_id
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = NO;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:company_id,@"company_id",nil];
    [HttpTool postWithPath:@"getCompanyVipInfo" params:params success:^(id JSON) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic = [result objectForKey:@"response"];
        if (dic) {
            if (!isNull(result, @"response")) {
                if ([[dic objectForKey:@"code"] intValue] ==100) {
                    NSDictionary *data = [dic objectForKey:@"data"];
                    VipInfoItem *vipInfo = [[VipInfoItem alloc] initWithDictionary:data];
                    [SystemConfig sharedInstance].vipInfo = vipInfo;
                    [_loginView dismissView];
                }else{
                    [_loginView dismissView];
                }
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"%@",error);
    }];
    
}

-(void)bodaBtn:(UIButton *)sender
{
    if (![SystemConfig sharedInstance].isUserLogin) {
        if (!_loginView) {
            CGRect frame = [UIScreen mainScreen].bounds;
            _loginView = [[LoginView alloc] initWithFrame:frame];
            _loginView.delegate = self;
        }
        [_loginView showView];
    }else{
    XQgetInfoDetailModel *xqModel =[[XQArray objectAtIndex:0]objectAtIndex:0];
           [phoneView callPhoneNumber:xqModel.phone_num
                              call:^(NSTimeInterval duration) {
                                  NSLog(@"User made a call of %.1f seconds", duration);
                                  
                              } cancel:^{
                                  NSLog(@"User cancelled the call");
                              } finish:^{
                                  NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[SystemConfig sharedInstance].company_id,@"call_id",xqModel.company_id,@"to_id",xqModel.info_id,@"info_id", nil];
                                  [HttpTool postWithPath:@"addCallRecord" params:param success:^(id JSON) {
                                      
                                  } failure:^(NSError *error) {
                                      
                                  }];
                              }];
        
        

   }
}


@end

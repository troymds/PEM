//
//  qiugouXQ.m
//  PEM
//
//  Created by YY on 14-8-28.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "qiugouXQ.h"
#import "XQgetInfoDetailModel.h"
#import "XQgetInfoTool.h"
#import "CompanyXQViewController.h"
#import "phoneView.h"
#import "SystemConfig.h"
#import "DemandController.h"
#import "PrivilegeController.h"
@interface qiugouXQ ()<UIWebViewDelegate>
{
    UIScrollView *_backScrollView;
}
@end

@implementation qiugouXQ
@synthesize demandIndex,demandArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor =HexRGB(0xffffff);
    demandArray =[[NSMutableArray alloc]init];
    self.title = @"求购详情";
    [self loadStatusView];

}
-(void)loadStatusView{
    
    // 显示指示器
//    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"正在加载中...";
//    hud.dimBackground = YES;
//    
    [XQgetInfoTool statusesWithSuccess:^(NSArray *statues) {
        [demandArray addObjectsFromArray:statues];
        [self addAabstract];
        [self showNewStatusCount];
    } failure:^(NSError *error) {
        
    } infoID:demandIndex];
}

#pragma mark 展示错误提示
- (void)showNewStatusCount
{
    
    
    XQgetInfoDetailModel *xqModel =[demandArray objectAtIndex:0];
    if ([xqModel.verify_result isEqualToString:@"0"])
    {
        UIView *failView=[[UIView alloc]initWithFrame:CGRectMake(0, -35, 320, 35)];
        [self.view addSubview:failView];
        UIView *failLin =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 5)];
        failLin.backgroundColor =HexRGB(0xe6e3e4);
        failView.backgroundColor =HexRGB(0xffffff);
        [failView addSubview:failLin];
        
        UIButton *failBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [failView addSubview:failBtn];
        failBtn.frame =CGRectMake(20, 5, 260, 30);
        [failBtn setTitle:@"等待审核。。。" forState:UIControlStateNormal];
        [failBtn setImage:[UIImage imageNamed:@"home_btn.png"] forState:UIControlStateNormal];
        failBtn.titleLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        [failBtn setTitleColor:HexRGB(0xff7300) forState:UIControlStateNormal];
        
    }else if([xqModel.verify_result isEqualToString:@"2"]){
        UIView *failView=[[UIView alloc]initWithFrame:CGRectMake(0, -35, 320, 35)];
        [self.view addSubview:failView];
        UIView *failLin =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 5)];
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
            failView.frame =CGRectMake(0, 0, 320, 35);
        }];
        
        
    }else{
        
    }
}
-(void)goBackFalseClick{
    DemandController *demand =[[DemandController alloc]init];
  demand.title = @"编辑求购信息";
    demand.info_id = demandIndex;
    [self.navigationController pushViewController:demand animated:YES];
}
-(void)addAabstract{
    XQgetInfoDetailModel *xqModel =[demandArray objectAtIndex:0];
    CGFloat contentHeight =[xqModel.description sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(300, MAXFLOAT)].height;
    CGFloat titleHeight =[xqModel.titleGetInfo sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(300, MAXFLOAT)].height;
    
    _backScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    _backScrollView.userInteractionEnabled=YES;
    _backScrollView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_backScrollView];
    
    _backScrollView.showsVerticalScrollIndicator = NO;
    _backScrollView.showsHorizontalScrollIndicator = NO;

    UILabel *nameLable =[[UILabel alloc]init];
    nameLable.text =xqModel.titleGetInfo;
    nameLable.frame =CGRectMake(5,5, 300, titleHeight);
    nameLable.font =[UIFont systemFontOfSize:17];
    nameLable.numberOfLines = 2;
    [_backScrollView addSubview:nameLable];
    nameLable.textColor = HexRGB(0x3a3a3a);
    
    
    UILabel *timer =[[UILabel alloc]init];
    timer.text =[NSString stringWithFormat:@"发布时间:%@",xqModel.create_time];
    timer.frame =CGRectMake(8,titleHeight+25, 170, 20);
    [_backScrollView addSubview:timer];
    timer.font =[UIFont systemFontOfSize:12];
    
    UILabel *numberLabel =[[UILabel alloc]init];
    numberLabel.frame =CGRectMake(5,titleHeight+5, 200, 20);
    numberLabel.text =[NSString stringWithFormat:@"求购数量:%@",xqModel.buy_num];
    numberLabel.font =[UIFont systemFontOfSize:15];
    [_backScrollView addSubview:numberLabel];
    numberLabel.textColor=HexRGB(0xff7300);
    
    
    UILabel *readLabel =[[UILabel alloc]init];
    readLabel.text =[NSString stringWithFormat:@"查看%@次",xqModel.read_num];
    readLabel.frame =CGRectMake(210,titleHeight+25, 100, 20);
    [_backScrollView addSubview:readLabel];
    readLabel.font =[UIFont systemFontOfSize:12];
    
    UIView *line=[[UIView alloc]init];
    line.frame =CGRectMake(0, titleHeight+53, 320, 1);
    [_backScrollView addSubview:line];
    line.backgroundColor =[UIColor lightGrayColor];
    
    UILabel *xinagq =[[UILabel alloc]init];
    xinagq.text =@"【产品详情】";
    xinagq.frame =CGRectMake(5,titleHeight+60, 200, 20);
    [_backScrollView addSubview:xinagq];
    xinagq.font =[UIFont systemFontOfSize:15];
    xinagq.textColor =RGBNAVbackGroundColor;
    
    UILabel *xinagLabel =[[UILabel alloc]init];
    xinagLabel.text =xqModel.description;
    xinagLabel.numberOfLines =0;
    xinagLabel.frame =CGRectMake(5,titleHeight+80, 300, contentHeight+40);
    [_backScrollView addSubview:xinagLabel];
    xinagLabel.font =[UIFont systemFontOfSize:15];
    
    demandWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 120, 320, kHeight+100)];
    
    [_backScrollView addSubview:demandWebView];
    demandWebView.userInteractionEnabled = NO;
    [demandWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:xqModel.description]]];
    demandWebView.delegate = self;

    

    //底部
    
    UIView *backView =[[UIView alloc]init];
    backView.backgroundColor =[UIColor whiteColor];
     backView .frame=CGRectMake(0, self.view.frame.size.height-80, 320, 80);

    backView.backgroundColor =HexRGB(0xefeded);

    [self.view addSubview:backView];
    
    
    
  
    
    UIView *lbackView =[[UIView alloc]init];
    lbackView.frame =CGRectMake(0, 0, kWidth, 44);
    lbackView.backgroundColor =[UIColor whiteColor];
    [backView addSubview:lbackView];
    
    UIButton *phoneBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    
    phoneBtn .frame=CGRectMake(45, 4, 230, 35);
    [phoneBtn setImage:[UIImage imageNamed:@"home_phone_pre.png"] forState:UIControlStateHighlighted];
    
    [phoneBtn setImage:[UIImage imageNamed:@"home_phone.png"] forState:UIControlStateNormal];
    [phoneBtn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [lbackView addSubview:phoneBtn];

    UIView *l =[[UIView alloc]init];
    [backView addSubview:l];
    l.frame =CGRectMake(0, 44, 320, 1);
    l.backgroundColor =HexRGB(0xe6e3e4);
    
    UIButton *goCompany =[UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:goCompany];
    goCompany.titleLabel.font =[UIFont systemFontOfSize:PxFont(15)];
    [goCompany setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    goCompany.frame = CGRectMake(280, 40, 40, 44);
    [goCompany setImage:[UIImage imageNamed:@"home_Jump_Black_btn.png"] forState:UIControlStateNormal];
   
    [goCompany addTarget:self action:@selector(gotoCompanyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //name
    UILabel *nameCopany =[[UILabel alloc]init];
//    nameCopany.text = xqModel.company_name;
    NSLog(@"%@",nameCopany);
    nameCopany.backgroundColor =[UIColor clearColor];
//    CGFloat nameCompanyw ;
//    if (![nameCopany isKindOfClass:[NSNull class]]) {
//        nameCompanyw =[xqModel.company_name sizeWithFont:[UIFont systemFontOfSize:PxFont(16)] constrainedToSize:CGSizeMake(MAXFLOAT, 30)].width;
//
//    }else{
//    }
    [backView addSubview:nameCopany];
    nameCopany.frame =CGRectMake(20, 40, 210, 44);
//    nameCopany.font =[UIFont systemFontOfSize:PxFont(16)];

    //vip
    UIImageView * _companyImgVip = [[UIImageView alloc] initWithFrame:CGRectMake(20,50, 18, 25)];
    
    if ([xqModel.vip_type isEqualToString:@"1"]) {
        _companyImgVip.image =[UIImage imageNamed:@"Vip4.png"];
    }
    else  if ([xqModel.vip_type isEqualToString:@"2"]) {
        _companyImgVip.image =[UIImage imageNamed:@"Vip2.png"];
        
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
    [backView addSubview:_companyImgVip];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    float demandWebheight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    _backScrollView.contentSize = CGSizeMake(320,demandWebheight+160);
    demandWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 120, 320, demandWebheight)];
    
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    
    return YES;
}


-(void)phoneBtnClick:(UIButton *)sentder
{
    
    if (![SystemConfig sharedInstance].viptype) {
    
    
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"尊敬的体验会员:" message:@"只有普通会员及以上会员可以拨打求购电话，您需要升级才能使用本功能!" delegate:self cancelButtonTitle:@"立即升级" otherButtonTitles:@"取消", nil];
        [alert show];

    }else{

        XQgetInfoDetailModel *xqModel =[demandArray objectAtIndex:0];
        
        [phoneView callPhoneNumber:xqModel.phone_num
                              call:^(NSTimeInterval duration) {
                                  NSLog(@"User made a call of %.1f seconds", duration);
                                  
                              } cancel:^{
                                  NSLog(@"User cancelled the call");
                              }];

    }

    
    

    
}


-(void)gotoCompanyBtnClick:(UIButton *)goCompany{
    XQgetInfoDetailModel *comID =[demandArray objectAtIndex:0];

    if ([comID.vip_type isEqualToString:@"0"]) {
        
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"尊敬的体验会员" message:@"抱歉，体验会员不能查看求购的公司信息，请立即升级!" delegate:self cancelButtonTitle:@"立即升级" otherButtonTitles:@"取消", nil];
        [alert show];
        
    }else{
    CompanyXQViewController *xqVC = [[CompanyXQViewController alloc]init];
    
    xqVC.companyID =comID.company_id;
    [self.navigationController pushViewController:xqVC animated:YES];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex ==0) {
        PrivilegeController *lvc =[[PrivilegeController alloc] init];
        [self.navigationController pushViewController:lvc animated:YES];
    }
}
@end

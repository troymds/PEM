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
#import "LoginController.h"
#import "HttpTool.h"
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
  
    [self loadStatusView];
    
    UIView *navBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth-90, 44)];
    self.navigationItem.titleView =navBgView;
    navBgView.backgroundColor =[UIColor clearColor];
    UILabel *titleLabele =[[UILabel alloc]init];
    [navBgView addSubview:titleLabele];
    titleLabele.frame = CGRectMake((kWidth-90-80)*0.5, 0, 80, 44);
    titleLabele.backgroundColor =[UIColor clearColor];
    
    titleLabele.text =@"求购详情";
    titleLabele.font = [UIFont systemFontOfSize:PxFont(26)];


}
-(void)loadStatusView{
    
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
        UIView *failView=[[UIView alloc]initWithFrame:CGRectMake(0, -35, kWidth, 35)];
        [self.view addSubview:failView];
        UIView *failLin =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 5)];
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
    DemandController *demand =[[DemandController alloc]init];
  demand.title = @"编辑求购信息";
    demand.info_id = demandIndex;
    [self.navigationController pushViewController:demand animated:YES];
}
-(void)addAabstract{
    XQgetInfoDetailModel *xqModel =[demandArray objectAtIndex:0];
    CGFloat contentHeight =[xqModel.description sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(300, MAXFLOAT)].height;
    CGFloat titleHeight =[xqModel.titleGetInfo sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(300, MAXFLOAT)].height;
    
    _backScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, self.view.frame.size.height)];
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
    line.frame =CGRectMake(0, titleHeight+53, kWidth, 1);
    [_backScrollView addSubview:line];
    line.backgroundColor =HexRGB(0xe6e3e4);
    
    UILabel *xinagq =[[UILabel alloc]init];
    xinagq.text =@"【产品详情】";
    xinagq.frame =CGRectMake(5,titleHeight+60, 200, 20);
    [_backScrollView addSubview:xinagq];
    xinagq.font =[UIFont systemFontOfSize:15];
    xinagq.textColor =HexRGB(0x69dd4);;

    UILabel *xinagLabel =[[UILabel alloc]init];
    xinagLabel.text =xqModel.description;
    xinagLabel.numberOfLines =0;
    xinagLabel.frame =CGRectMake(5,titleHeight+80, 300, contentHeight+40);
    [_backScrollView addSubview:xinagLabel];
    xinagLabel.font =[UIFont systemFontOfSize:15];
    
    demandWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 120, kWidth, kHeight-164)];
    
    [_backScrollView addSubview:demandWebView];
    demandWebView.userInteractionEnabled = NO;
    [demandWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:xqModel.description]]];
    demandWebView.delegate = self;

    

    //底部
    
    UIView *backView =[[UIView alloc]init];
    backView.backgroundColor =[UIColor whiteColor];
     backView .frame=CGRectMake(0, self.view.frame.size.height-80, kWidth, 80);

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
    l.frame =CGRectMake(0, 44, kWidth, 1);
    l.backgroundColor =HexRGB(0xe6e3e4);
    
    UIButton *goCompany =[UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:goCompany];
    goCompany.titleLabel.font =[UIFont systemFontOfSize:PxFont(15)];
    [goCompany setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    goCompany.frame = CGRectMake(0, 40, kWidth, 44);
    [goCompany setImage:[UIImage imageNamed:@"home_Jump_Black_btn.png"] forState:UIControlStateNormal];
    goCompany.imageEdgeInsets =UIEdgeInsetsMake(0, 280, 0, 0);
    [goCompany addTarget:self action:@selector(gotoCompanyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    

    //vip
    
    UIImageView * _companyImgVip;
    CGFloat nameCompanyw=0 ;
     _companyImgVip = [[UIImageView alloc] initWithFrame:CGRectMake(70,50, 18, 25)];
    
    if ([xqModel.vip_type isEqualToString:@"1"]) {
        _companyImgVip.image =[UIImage imageNamed:@"Vip4.png"];
    }
    else  if ([xqModel.vip_type isEqualToString:@"2"]) {
        _companyImgVip.image =[UIImage imageNamed:@"Vip3.png"];
        
    } else if([xqModel.vip_type isEqualToString:@"3"]) {
        _companyImgVip.image =[UIImage imageNamed:@"Vip2.png"];
        
    }else if([xqModel.vip_type isEqualToString:@"4"]){
        
        _companyImgVip.image =[UIImage imageNamed:@"Vip1.png"];
    }
    else if([xqModel.vip_type isEqualToString:@"0"]){
        
        _companyImgVip.image =[UIImage imageNamed:@"Vip5.png"];
    }else if([xqModel.vip_type isEqualToString:@"-1"]){
        
        _companyImgVip.image =[UIImage imageNamed:@"Vip6.png"];
    }
    [backView addSubview:_companyImgVip];
    
    //name
    if (![xqModel.company_name isKindOfClass:[NSNull class]]){
        nameCompanyw =[xqModel.company_name sizeWithFont:[UIFont systemFontOfSize:PxFont(18)] constrainedToSize:CGSizeMake(250, 50)].width;

    }else{
        
    }
    UILabel *nameCopany =[[UILabel alloc]init];
    
    nameCopany.backgroundColor =[UIColor clearColor];
    
    [backView addSubview:nameCopany];
    nameCopany.frame =CGRectMake(20, 40, nameCompanyw, 44);
    nameCopany.font =[UIFont systemFontOfSize:PxFont(18)];
    if (![xqModel.company_name isKindOfClass:[NSNull class]]){
        nameCopany.text = xqModel.company_name;

    }else{
        nameCopany.text = @"";
    }
    
    if ([[SystemConfig sharedInstance].viptype isEqualToString:@"1"]) {
        _companyImgVip.frame =CGRectMake(20+nameCompanyw,50, 18, 25);
        
        if (![xqModel.company_name isKindOfClass:[NSNull class]]){
            nameCopany.text = xqModel.company_name;
            
        }else{
            nameCopany.text = @"";
        }
    }else if ([[SystemConfig sharedInstance].viptype isEqualToString:@"2"]) {
        _companyImgVip.frame =CGRectMake(20+nameCompanyw,50, 18, 25);
        
        if (![xqModel.company_name isKindOfClass:[NSNull class]]){
            nameCopany.text = xqModel.company_name;
            
        }else{
            nameCopany.text = @"";
        }
    }
    else if ([[SystemConfig sharedInstance].viptype isEqualToString:@"3"]) {
        _companyImgVip.frame =CGRectMake(20+nameCompanyw,50, 18, 25);
        
        if (![xqModel.company_name isKindOfClass:[NSNull class]]){
            nameCopany.text = xqModel.company_name;
            
        }else{
            nameCopany.text = @"";
        }
    }
    else if ([[SystemConfig sharedInstance].viptype isEqualToString:@"4"]) {
        _companyImgVip.frame =CGRectMake(20+nameCompanyw,50, 18, 25);
        
        if (![xqModel.company_name isKindOfClass:[NSNull class]]){
            nameCopany.text = xqModel.company_name;
            
        }else{
            nameCopany.text = @"";
        }
    }else {
        nameCopany.text = @"xxx公司";
        nameCopany.frame =CGRectMake(20, 40, 250, 44);

        
    }
    

    
}

#pragma mark 拨号蒙版
-(void)addphoneViewName
{
    XQgetInfoDetailModel *xqModel =[demandArray objectAtIndex:0];
    
    _phoneViewName = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    _phoneViewName.backgroundColor =[UIColor lightGrayColor];
    _phoneViewName.alpha = 0.3;
    [self.view addSubview:_phoneViewName];
    
    nameView =[[UIView alloc]initWithFrame:CGRectMake((kWidth-260)/2, (kHeight-100)/2, 260, 100)];
    nameView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:nameView];
    
    
    UILabel *nameLabel =[[UILabel alloc]initWithFrame:CGRectMake(15, 10, 260, 30)];
    nameLabel.textColor = HexRGB(0x069dd4);
    [nameView addSubview:nameLabel];
    nameLabel.font =[UIFont systemFontOfSize:20];
    if (![xqModel.contacts isKindOfClass:[NSNull class]]){
        nameLabel.text =xqModel.contacts;
        
    }else{
        nameLabel.text = @"";
    }
    
    UIView *nameLine =[[UIView alloc]initWithFrame:CGRectMake(0, 50, 260, 1)];
    nameLine.backgroundColor =HexRGB(0x069dd4);
    [nameView addSubview:nameLine];
    
    
    
    for (int p=0; p<2; p++) {
        NSArray *sureArr =@[@"确定",@"取消"];
        
        UIButton *phoneBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [nameView addSubview:phoneBtn];
        
        phoneBtn.frame =CGRectMake(35+p%3*100, 50, 70, 50);
        [phoneBtn addTarget:self action:@selector(surePhoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [phoneBtn setTitle:sureArr[p] forState:UIControlStateNormal];
        
        [phoneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        phoneBtn.tag = 44+p;
        
        
        UIView *leftLine =[[UIView alloc]initWithFrame:CGRectMake(p%3*259,0, 1, 100)];
        leftLine.backgroundColor =HexRGB(0xe6e3e4);
        
        [nameView addSubview:leftLine];
        
        
        UIView *upLine =[[UIView alloc]initWithFrame:CGRectMake(0,p%3*99, 260, 1)];
        upLine.backgroundColor =HexRGB(0xe6e3e4);
        
        [nameView addSubview:upLine];
        
        
        
        
    }
    
    
    UIView *upLine =[[UIView alloc]initWithFrame:CGRectMake(130,51, 1, 49)];
    upLine.backgroundColor =HexRGB(0xe6e3e4);
    
    [nameView addSubview:upLine];
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    float demandWebheight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    demandWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 120, kWidth, demandWebheight)];
    
    
    if (demandWebheight<500) {
        _backScrollView.contentSize = CGSizeMake(kWidth,kHeight);
        
    }else {
        _backScrollView.contentSize = CGSizeMake(kWidth,demandWebheight+160);
        
    }

    
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    
    return YES;
}

-(void)surePhoneBtnClick:(UIButton *)sure{
    if (sure.tag ==44) {
        if (![SystemConfig sharedInstance].isUserLogin) {
            
            LoginController *lvc =[[LoginController alloc] init];
            [self.navigationController pushViewController:lvc animated:YES];
            
            
        }else if ([[SystemConfig sharedInstance].viptype isEqualToString:@"0"]) {
            [_phoneViewName removeFromSuperview];
            [nameView removeFromSuperview];
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"尊敬的体验会员:" message:@"只有普通会员及以上会员可以拨打求购电话，您需要升级才能使用本功能!" delegate:self cancelButtonTitle:@"立即升级" otherButtonTitles:@"取消", nil];
            [alert show];
            
            
            
        }else if ([[SystemConfig sharedInstance].viptype isEqualToString:@"-1"]) {
            [_phoneViewName removeFromSuperview];
            [nameView removeFromSuperview];
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"尊敬的体验会员:" message:@"只有普通会员及以上会员可以拨打求购电话，您需要升级才能使用本功能!" delegate:self cancelButtonTitle:@"立即升级" otherButtonTitles:@"取消", nil];
            [alert show];
            
            
            
        }
        else{
            
            XQgetInfoDetailModel *xqModel =[demandArray objectAtIndex:0];
            
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
        

    }else {
        [_phoneViewName removeFromSuperview];
        [nameView removeFromSuperview];
    }
}

-(void)phoneBtnClick:(UIButton *)sentder
{
    
    [self addphoneViewName];
    
    

    
}


-(void)gotoCompanyBtnClick:(UIButton *)goCompany{
    XQgetInfoDetailModel *comID =[demandArray objectAtIndex:0];
    if (![SystemConfig sharedInstance].isUserLogin) {
        
        
        LoginController *lvc =[[LoginController alloc] init];
        [self.navigationController pushViewController:lvc animated:YES];

        
    }else  if([[SystemConfig sharedInstance].viptype isEqualToString:@"-1"]) {
       
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"尊敬的体验会员" message:@"抱歉，体验会员不能查看求购的公司信息，请立即升级!" delegate:self cancelButtonTitle:@"立即升级" otherButtonTitles:@"取消", nil];
        [alert show];
                
        
        
    }else  if([[SystemConfig sharedInstance].viptype isEqualToString:@"3"]) {
       
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"尊敬的体验会员" message:@"抱歉，体验会员不能查看求购的公司信息，请立即升级!" delegate:self cancelButtonTitle:@"立即升级" otherButtonTitles:@"取消", nil];
        [alert show];
        
        
        
    }
    else{
    CompanyXQViewController *xqVC = [[CompanyXQViewController alloc]init];
    
    xqVC.companyID =comID.company_id;
    [self.navigationController pushViewController:xqVC animated:YES];
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex ==0) {
        PrivilegeController *lvc =[[PrivilegeController alloc] init];
        [self.navigationController pushViewController:lvc animated:YES];
      
    }else{
            }
}
@end

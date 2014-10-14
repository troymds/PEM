//
//  SpuareController.m
//  PEM
//
//  Created by jch on 14-8-13.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "SpuareController.h"
#import "HeaderView.h"
#import "UIBarButtonItem+MJ.h"
#import "LoginController.h"
#import "MySupplyController.h"
#import "MyPurchaseController.h"
#import "MyFavoriteController.h"
#import "SubscribController.h"
#import "PrivilegeController.h"
#import "DialRecordController.h"
#import "CompanyInfoController.h"
#import "CompanySetController.h"
#import "SystemConfig.h"
#import "LoginController.h"
#import "UIImageView+WebCache.h"
#import "HttpTool.h"
#import "BaseNumItem.h"
#import "UMSocial.h"

@interface SpuareController ()

@end

@implementation SpuareController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    if ([SystemConfig sharedInstance].isUserLogin){
        //登录状态 显示企业头像等信息
        CompanyInfoItem *item = [SystemConfig sharedInstance].companyInfo;
        if (item.image&&item.image.length!=0){
            [_headView.headerImage setImageWithURL:[NSURL URLWithString:item.image] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
        }
        [_headView setName:item.company_name];
        _headView.nameLabel.hidden = NO;
        _headView.registerBtn.hidden = YES;
        
        //请求并显示基本数据
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[SystemConfig sharedInstance].company_id,@"company_id", nil];
        [HttpTool postWithPath:@"getCurrentCompanyBaseNum" params:params success:^(id JSON) {
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dic = [result objectForKey:@"response"];
            NSInteger code = [[dic objectForKey:@"code"] intValue];
            if (code == 100){
                NSDictionary *data = [dic objectForKey:@"data"];
                BaseNumItem *item = [[BaseNumItem alloc] initWithDictionary:data];
                _headView.supplayLabel.text = item.supply;
                _headView.purchaseLabel.text = item.demand;
                _headView.favoriteLabel.text = item.wishlist;
                _headView.messageLabel.text = item.news;
            }
        }failure:^(NSError *error){
            NSLog(@"error:%@",error);
        }];
    }else{
        _headView.headerImage.image = [UIImage imageNamed:@"user_default.png"];
        _headView.supplayLabel.text = @"0";
        _headView.purchaseLabel.text = @"0";
        _headView.favoriteLabel.text = @"0";
        _headView.messageLabel.text = @"0";
        _headView.nameLabel.hidden = YES;
        _headView.registerBtn.hidden = NO;
        _headView.markImg.image = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = HexRGB(0xffffff);
    
    self.title = @"个人中心";
    
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth,kHeight-44-64)];
    _scrollView.delegate = self;
    _scrollView.backgroundColor =  HexRGB(0xe6e6e6);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _headView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 182)];
    _headView.bgView.image = [UIImage imageNamed:@"individual_bg.png"];
    _headView.headerImage.image = [UIImage imageNamed:@"user_default.png"];
    _headView.delegate = self;
    [_scrollView addSubview:_headView];
    _squareView = [[Square alloc] initWithFrame:CGRectMake(0,_headView.frame.size.height, kWidth, 396)];
    _squareView.delegate = self;
    [_scrollView addSubview:_squareView];
    [self.view addSubview:_scrollView];
    [_scrollView setContentSize:CGSizeMake(kWidth, _headView.frame.size.height+_squareView.frame.size.height)];
    
}



#pragma mark Square delegate
- (void)buttonClicked:(UIButton *)btn{
    if (btn.tag == PRIVILEGE_TYPE) {
        PrivilegeController *pvc = [[PrivilegeController alloc] init];
        [self.navigationController pushViewController:pvc animated:YES];
    }else if(btn.tag == SHARE_TYPE){
        [UMSocialSnsService presentSnsIconSheetView:self
                                            appKey:nil
                                          shareText:@"Ebingoo--指尖商机 用手指做生意.打造全新电商平台。网址：www.ebingoo.com"
                                         shareImage:nil
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToQzone,UMShareToSms,nil]
                                           delegate:nil];

    }else{
        if (![SystemConfig sharedInstance].isUserLogin){
            LoginController *loginVC = [[LoginController alloc] init];
            loginVC.pushType = MENU_TYPE;
            [self.navigationController pushViewController:loginVC animated:YES];
        }else{
            switch (btn.tag) {
                case SUPPLY_TYPE:
                {
                    MySupplyController *sc = [[MySupplyController alloc] init];
                    [self.navigationController pushViewController:sc animated:YES];
                }
                    break;
                case PURCHASE_TYPE:
                {
                    MyPurchaseController *pc = [[MyPurchaseController alloc] init];
                    [self.navigationController pushViewController:pc animated:YES];
                }
                    break;
                case FAVORITE_TYPE:
                {
                    MyFavoriteController *fc = [[MyFavoriteController alloc] init];
                    [self.navigationController pushViewController:fc animated:YES];
                }
                    break;
                case SUBSCRIPE_TYPE:
                {
                    SubscribController *svc = [[SubscribController alloc] init];
                    [self.navigationController pushViewController:svc animated:YES];
                }
                    break;
                case DIALRECORD_TYPE:
                {
                    DialRecordController *dvc = [[DialRecordController alloc] init];
                    [self.navigationController pushViewController:dvc animated:YES];
                }
                    break;
                case SET_TYPE:
                {
                    SettingController *sc = [[SettingController alloc] init];
                    [self.navigationController pushViewController:sc animated:YES];
                }
                    break;
                case INFO_TYPE:
                {
                    CompanyInfoController *cvc = [[CompanyInfoController alloc] init];
                    [self.navigationController pushViewController:cvc animated:YES];
                }
                    break;
                    
                    default:
                    break;
            }
        }
    }
}


#pragma mark headerView delegate
- (void)buttonClick:(UIButton *)btn{
    if (btn.tag == 20000) {
        LoginController *loginVc = [[LoginController alloc] init];
        loginVc.pushType = DIRECT_TYPE;
        [self.navigationController pushViewController:loginVc animated:YES];
    }else if (btn.tag == 40000){
        MySupplyController *msc = [[MySupplyController alloc] init];
        [self.navigationController pushViewController:msc animated:YES];
    }else if (btn.tag == 40001){
        MyPurchaseController *mpc = [[MyPurchaseController alloc] init];
        [self.navigationController pushViewController:mpc animated:YES];
    }else if (btn.tag == 40002){
        MyFavoriteController *mfc = [[MyFavoriteController alloc] init];
        [self.navigationController pushViewController:mfc animated:YES];
    }else{
        SubscribController *sc = [[SubscribController alloc] init];
        [self.navigationController pushViewController:sc animated:YES];
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

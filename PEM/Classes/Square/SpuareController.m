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
#import <ShareSDK/ShareSDK.h>

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
        //判断是否是登录状态 若是 显示企业头像等信息
        CompanyInfoItem *item = [SystemConfig sharedInstance].companyInfo;
        if (item.image&&item.image.length!=0){
            [_headView.headerImage setImageWithURL:[NSURL URLWithString:item.image] placeholderImage:[UIImage imageNamed:@"company_default.png"]];
        }
        NSString *name;
        if (item.company_name.length==0) {
            name = @"未设置公司名";
        }else{
            name = item.company_name;
        }
        [_headView setName:name];
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
        _headView.headerImage.image = [UIImage imageNamed:@"company_default.png"];
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
    _headView.headerImage.image = [UIImage imageNamed:@"company_default.png"];
    _headView.headerImage.delegate = self;
    _headView.nameLabel.delegate = self;
    _headView.delegate = self;
    [_scrollView addSubview:_headView];
    _squareView = [[Square alloc] initWithFrame:CGRectMake(0,_headView.frame.size.height, kWidth, 396)];
    _squareView.delegate = self;
    [_scrollView addSubview:_squareView];
    [self.view addSubview:_scrollView];
    [_scrollView setContentSize:CGSizeMake(kWidth, _headView.frame.size.height+_squareView.frame.size.height)];
    
}

//点击头像触发
#pragma mark ---proImageView_delegate
- (void)imageClicked:(ProImageView *)image
{
    if (![SystemConfig sharedInstance].isUserLogin){
        LoginController *loginVC = [[LoginController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }else{
        CompanySetController *csc = [[CompanySetController alloc] init];
        [self.navigationController pushViewController:csc animated:YES];
    }
}

//点击用户名触发
#pragma mark  prolabel_delegate  
- (void)proLabelClick:(ProLabel *)label
{
    CompanySetController *scs = [[CompanySetController alloc] init];
    [self.navigationController pushViewController:scs animated:YES];
}

#pragma mark Square delegate
- (void)buttonClicked:(UIButton *)btn{
    if (btn.tag == PRIVILEGE_TYPE) {
        PrivilegeController *pvc = [[PrivilegeController alloc] init];
        [self.navigationController pushViewController:pvc animated:YES];
    }else if(btn.tag == SHARE_TYPE){
//         NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK"  ofType:@"jpg"];
        
//        构造分享内容
        
        [self share];
        
//        id<ISSContent> publishContent = [ShareSDK content:@"Ebingoo--指尖商机 用手指做生意.打造全新电商平台。网址：www.ebingoo.com"
//                                           defaultContent:@"Ebingoo--指尖商机 用手指做生意.打造全新电商平台。网址：www.ebingoo.com"
//                                                    image:nil
//                                                    title:@"Ebingoo"
//                                                      url:@"www.ebingoo.com"
//                                              description:@"Ebingoo--指尖商机 用手指做生意.打造全新电商平台。网址：www.ebingoo.com"
//                                                mediaType:SSPublishContentMediaTypeNews];
//        
//        [ShareSDK showShareActionSheet:nil
//                             shareList:nil
//                               content:publishContent
//                         statusBarTips:YES
//                           authOptions:nil
//                          shareOptions: nil
//                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                    if (state == SSPublishContentStateSuccess)
//                                    {
//                                        
//                                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功!" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                                        [alertView show];
//                                    }
//                                    else if (state == SSPublishContentStateFail)
//                                    {
//                                        UIAlertView *alertView  = [[UIAlertView alloc] initWithTitle:@"分享失败" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                                        [alertView show];
//                                        NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
//                                    }
//                                }];
    }else{
        if (![SystemConfig sharedInstance].isUserLogin){
            LoginController *loginVC = [[LoginController alloc] init];
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

- (void)share
{
    //分享的 底ViewControoler
    id<ISSContainer> container = [ShareSDK container];
    
    [container setIPhoneContainerWithViewController:self];
    
    NSArray *shareList = [ShareSDK getShareListWithType:
                          ShareTypeSinaWeibo,
                          ShareTypeQQ,
                          ShareTypeQQSpace,
                          ShareTypeWeixiSession,
                          ShareTypeWeixiTimeline,
                          ShareTypeWeixiFav,
                          ShareTypeSMS,
                          nil];
    
    //分享的内容
    id<ISSContent> publishContent = nil;
    NSString *contentString = @"Ebingoo--指尖商机 用手指做生意.打造全新电商平台。网址：www.ebingoo.com";
    NSString *urlString     = @"www.ebingoo.com";
    NSString *description   = @"Ebingoo--指尖商机 用手指做生意.打造全新电商平台。网址：www.ebingoo.com";
    id<ISSCAttachment> shareImage = nil;
    UIImage *img = [UIImage imageNamed:@"http://pic.hxygchina.com:15001/35f131a1f4f94fd5b3e973deff452800_20x20.jpg"];//[activityObj.images firstObject];
    SSPublishContentMediaType shareType = SSPublishContentMediaTypeText;
    if (img) {
        shareImage = [ShareSDK jpegImageWithImage:img quality:1.0];
        shareType = SSPublishContentMediaTypeNews;
    }
    
    publishContent = [ShareSDK content:contentString
                        defaultContent:@""
                                 image:nil
                                 title:@"易宾购"
                                   url:urlString
                           description:description
                             mediaType:shareType];
    
    id<ISSShareOptions> shareOptions =
    [ShareSDK defaultShareOptionsWithTitle:@""
                           oneKeyShareList:shareList
                        cameraButtonHidden:YES
                       mentionButtonHidden:NO
                         topicButtonHidden:NO
                            qqButtonHidden:NO
                     wxSessionButtonHidden:NO
                    wxTimelineButtonHidden:NO
                      showKeyboardOnAppear:NO
                         shareViewDelegate:nil
                       friendsViewDelegate:nil
                     picViewerViewDelegate:nil];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:shareOptions
                            result:^(ShareType type,
                                     SSResponseState state,
                                     id<ISSPlatformShareInfo> statusInfo,
                                     id<ICMErrorInfo> error, BOOL end)
     {
         if (state == SSPublishContentStateSuccess)
         {
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
             [alertView show];
         }
         else if (state == SSPublishContentStateFail)
         {

             NSString *msg = [error errorDescription];
             if ([msg rangeOfString:@"WeChat"].location !=NSNotFound) {
                 if ([error errorCode] == -22003) {
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败" message:@"尚未安装微信,请安装后重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                     [alertView show];
                 }
             }
             if ([msg rangeOfString:@"QQ"].location !=NSNotFound) {
                 if ([error errorCode] == -24002) {
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败" message:@"尚未安装QQ,请安装后重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                     [alertView show];
                 }
             }
             if ([msg rangeOfString:@"QZONE"].location !=NSNotFound) {
                 if ([error errorCode] == 6004) {
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败" message:@"尚未安装QQ或者QQ空间客户端，请安装后重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                     [alertView show];
                 }
             }
         }
     }];
}


#pragma mark headerView delegate
- (void)buttonClick:(UIButton *)btn{
    if (![SystemConfig sharedInstance].isUserLogin){
        LoginController *loginVC = [[LoginController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }else{
        if (btn.tag == 20000) {
            LoginController *loginVc = [[LoginController alloc] init];
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

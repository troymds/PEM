//
//  CompanyInfoController.m
//  PEM
//
//  Created by tianj on 14-8-29.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "CompanyInfoController.h"
#import "HttpTool.h"
#import "SystemConfig.h"
#import "CompanyInfoItem.h"
#import "UIImageView+WebCache.h"
#import "CompanyInfoItem.h"
#import "CompanySetController.h"

@interface CompanyInfoController ()

@end

@implementation CompanyInfoController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = HexRGB(0xffffff);

    self.title = @"企业资料";
    // Do any additional setup after loading the view.
    
    // 创建按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 设置普通背景图片
    [btn setTitle:@"修 改" forState:UIControlStateNormal];
    [btn setTitleColor:HexRGB(0x3a3a3a) forState:UIControlStateNormal];
    // 设置尺寸
    btn.frame = CGRectMake(10, 10,52, 24);
    [btn addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;

    
    [self addView];
    [self loadData];
}

- (void)edit
{
    CompanySetController *csc = [[CompanySetController alloc] init];
    [self.navigationController pushViewController:csc animated:YES];
}

- (void)addView{
    _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(25,35, 77, 77)];
    _iconImage.image = [UIImage imageNamed:@"company_default@2x.png"];
    [self.view addSubview:_iconImage];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 35, 200, 20)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont systemFontOfSize:16];
    _nameLabel.textColor = HexRGB(0x069dd4);
    [self.view addSubview:_nameLabel];
    
    _regionLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 60, 150, 20)];
    _regionLabel.backgroundColor = [UIColor clearColor];
    _regionLabel.font = [UIFont systemFontOfSize:14];
    _regionLabel.textColor = HexRGB(0x808080);
    [self.view addSubview:_regionLabel];
    
    _vipTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 85, 150, 20)];
    _vipTypeLabel.backgroundColor = [UIColor clearColor];
    _vipTypeLabel.font = [UIFont systemFontOfSize:14];
    _vipTypeLabel.textColor = HexRGB(0x808080);
    [self.view addSubview:_vipTypeLabel];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(23, 125, kWidth-46, 160)];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius  = 6.0;
    bgView.layer.borderWidth = 1.0;
    bgView.layer.borderColor = HexRGB(0xced2d8).CGColor;
    [self.view addSubview:bgView];
    
    for (int i = 0; i < 3; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40+40*i, kWidth-46, 1)];
        lineView.backgroundColor = HexRGB(0xced2d8);
        [bgView addSubview:lineView];
    }
    
    _regionView = [[InfoCellView alloc] initWithFrame:CGRectMake(0, 0, kWidth-46, 40)];
    _regionView.titleLabel.text = @"企业地区";
    [bgView addSubview:_regionView];
    
    _websiteView = [[InfoCellView alloc] initWithFrame:CGRectMake(0, 40, kWidth-46, 40)];
    _websiteView.titleLabel.text = @"企业网址";
    [bgView addSubview:_websiteView];
    
    _emailView = [[InfoCellView alloc] initWithFrame:CGRectMake(0, 80, kWidth-46, 40)];
    _emailView.titleLabel.text = @"企业邮箱";
    [bgView addSubview:_emailView];
    
    _phoneView = [[InfoCellView alloc] initWithFrame:CGRectMake(0, 120, kWidth-46, 40)];
    _phoneView.titleLabel.text = @"电话号码";
    [bgView addSubview:_phoneView];
    
}

- (void)loadData{
    CompanyInfoItem *item = [SystemConfig sharedInstance].companyInfo;
    _nameLabel.text = item.company_name;
    NSString *address = [NSString stringWithFormat:@"%@%@",item.province_name,item.city_name];
    _regionLabel.text = address;
    _regionView.infoLabel.text = item.address;
    _websiteView.infoLabel.text = item.website;
    _emailView.infoLabel.text = item.email;
    _phoneView.infoLabel.text = item.company_tel;
    if ([SystemConfig sharedInstance].vipInfo) {
        _vipTypeLabel.text = [NSString stringWithFormat:@"等级:%@",[SystemConfig sharedInstance].vipInfo.vip_name];
    }else{
        [self getVipInfo];
    }
 }

- (void)getVipInfo
{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[SystemConfig sharedInstance].company_id,@"company_id", nil];
    [HttpTool postWithPath:@"getCompanyVipInfo" params:param success:^(id JSON) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic = [result objectForKey:@"response"];
        if ([[dic objectForKey:@"code"] intValue] ==100) {
            NSDictionary *data = [dic objectForKey:@"data"];
            VipInfoItem *vipInfo = [[VipInfoItem alloc] initWithDictionary:data];
            [SystemConfig sharedInstance].vipInfo = vipInfo;
            
            _vipTypeLabel.text = [NSString stringWithFormat:@"等级:%@",[SystemConfig sharedInstance].vipInfo.vip_name];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

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

//
//  PrivilegeController.m
//  PEM
//
//  Created by tianj on 14-8-29.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "PrivilegeController.h"
#import "PriImageView.h"
#import "VisitorView.h"
#import "NomalVipView.h"
#import "VipView.h"
#import "VVipView.h"
#import "HttpTool.h"
#import "RegisterContrller.h"
#import "SystemConfig.h"

@interface PrivilegeController ()

@end

@implementation PrivilegeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated{
    for (UIView *subView in _scrollView.subviews) {
        [subView removeFromSuperview];
    }
    [self addButton];
    [self addRightView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = HexRGB(0xffffff);

    self.title = @"我的特权";
    // Do any additional setup after loading the view.
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, kWidth,320)];
    
    [_scrollView setContentSize:CGSizeMake(kWidth,320)];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 420, 60,kHeight-64-100-320)];
    view.backgroundColor = HexRGB(0xe0e0e0);
    [self.view addSubview:view];

    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    _headView =[[PriHeadView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 100)];
    _headView.bgView.image = [UIImage imageNamed:@"individual_bg.png"];
    _headView.iconImg.image =[UIImage imageNamed:@"user_default.png"];
    _headView.descripLabel.text = @"未注册用户";
    _headView.typeLabel.text = @"游客";
    [self.view addSubview:_headView];
}

- (void)addButton{
    NSArray *array = [NSArray arrayWithObjects:@"游客",@"普通会员",@"vip会员",@"vvip会员", nil];
    NSArray *nomalImg = [NSArray arrayWithObjects:[UIImage imageNamed:@"visitor.png"],[UIImage imageNamed:@"nomal.png"],[UIImage imageNamed:@"vip.png"],[UIImage imageNamed:@"vvip.png"],nil];
    NSArray *selectedImg = [NSArray arrayWithObjects:[UIImage imageNamed:@"visitor_pre.png"],[UIImage imageNamed:@"nomal_pre.png"],[UIImage imageNamed:@"vip_pre.png"],[UIImage imageNamed:@"vvip_pre.png"],nil];
    for (int i =0; i < [nomalImg count]; i++){
        PriImageView *img = [[PriImageView alloc] initWithFrame:CGRectMake(0, 80*i, 60, 80)];
        [img setIconNomalImg:[nomalImg objectAtIndex:i] selectedImg:[selectedImg objectAtIndex:i] withTitle:[array objectAtIndex:i]];
        if ([SystemConfig sharedInstance].viptype){
            NSInteger vipType = [[SystemConfig sharedInstance].viptype integerValue];
            if (vipType+1 == i){
                img.isSelected = YES;
            }
        }else{
            if (i == 0){
                img.isSelected = YES;
            }
        }
        img.tag = 1000+i;
        img.delegate = self;
        [_scrollView addSubview:img];
    }


}

- (void)addRightView{
    NSInteger vipType = [[SystemConfig sharedInstance].viptype integerValue];
    if (![SystemConfig sharedInstance].isUserLogin) {
        _visitorView = [[VisitorView alloc] initWithFrame:CGRectMake(60, 0, kWidth-60, 280)];
        [_scrollView addSubview:_visitorView];
    }else{
        if (vipType == 0){
            _nomalVipView = [[NomalVipView alloc] initWithFrame:CGRectMake(60, 0, kWidth-60, 280)];
            _nomalVipView.upGradeBtn.hidden = YES;
            _nomalVipView.delegate =self;
            [_scrollView addSubview:_nomalVipView];
            
        }else if(vipType == 1){
            _vipView = [[VipView alloc] initWithFrame:CGRectMake(60, 0, kWidth-60, 280)];
            _vipView.upGradeBtn.hidden = YES;
            _vipView.delegate =self;
            [_scrollView addSubview:_vipView];
        }else if(vipType == 2){
            _vvipView = [[VVipView alloc] initWithFrame:CGRectMake(60, 0, kWidth-60, 280)];
            _vvipView.upGradeBtn.hidden = YES;
            _vvipView.delegate = self;
            [_scrollView addSubview:_vvipView];
        }
    }
}
//左边的按钮点击事件
- (void)imageClicked:(ProImageView *)image{
    NSInteger vipType = [[SystemConfig sharedInstance].viptype integerValue];
    //先将右边的试图移除
    for (UIView *subView in _scrollView.subviews) {
        if ([subView isKindOfClass:[PriImageView class]]) {
            PriImageView *view = (PriImageView *)subView;
            if (view.tag == image.tag) {
                view.isSelected = YES;
            }else{
                view.isSelected = NO;
            }
        }else{
            [subView removeFromSuperview];
        }
    }
    //根据左边的按钮添加右边对应的试图
    switch (image.tag) {
        case 1000:
        {
            _visitorView = [[VisitorView alloc] initWithFrame:CGRectMake(60, 0, kWidth-60, 320)];
            [_scrollView addSubview:_visitorView];

        }
            break;
        case 1001:
        {
            _nomalVipView = [[NomalVipView alloc] initWithFrame:CGRectMake(60, 0, kWidth-60, 320)];
            //判断是否需要升级按钮
            if ([SystemConfig sharedInstance].viptype) {
                if (vipType ==0 || vipType == 1||vipType == 2) {
                    _nomalVipView.upGradeBtn.hidden = YES;
                }
            }
            _nomalVipView.delegate =self;
            [_scrollView addSubview:_nomalVipView];
        }
            break;
        case 1002:
        {
            _vipView = [[VipView alloc] initWithFrame:CGRectMake(60, 0, kWidth-60, 320)];
            if (vipType == 1||vipType == 2){
                _vipView.upGradeBtn.hidden = YES;
            }
            _vipView.delegate =self;
            [_scrollView addSubview:_vipView];

        }
            break;
        case 1003:
        {
            _vvipView = [[VVipView alloc] initWithFrame:CGRectMake(60, 0, kWidth-60, 320)];
            if (vipType == 2){
                _vvipView.upGradeBtn.hidden = YES;
            }
            _vvipView.delegate = self;
            [_scrollView addSubview:_vvipView];

        }
            break;
      
        default:
            break;
    }
}


- (void)privilegeBtnDown:(UIButton *)btn{
    switch (btn.tag) {
        case NOMAL_TYPE:
        {
            RegisterContrller *rc = [[RegisterContrller alloc] init];
            rc.pushType = UPDATE_TYPE;
            [self.navigationController pushViewController:rc animated:YES];
        }
            break;
        case VIP_TYPE:
        {
            //如果登录了直接进行升级
            if ([SystemConfig sharedInstance].isUserLogin){
                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[SystemConfig sharedInstance].company_id,@"company_id",@"1",@"apply_type", nil];
                [HttpTool postWithPath:@"applyVip" params:params success:^(id JSON) {
                    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
                    if ([[[result objectForKey:@"response"] objectForKey:@"code"] intValue] ==100){
                        [self showRemindView];
                    }
                } failure:^(NSError *error) {
                    NSLog(@"%@",error);
                }];
            }else{
                RegisterContrller *rc = [[RegisterContrller alloc] init];
                rc.pushType = UPDATE_TYPE;
                [self.navigationController pushViewController:rc animated:YES];
            }
        }
            break;
        case VVIP_TYPE:
        {
            //如果登录了直接进行升级
            if ([SystemConfig sharedInstance].isUserLogin) {
                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[SystemConfig sharedInstance].company_id,@"company_id",@"2",@"apply_type", nil];
                [HttpTool postWithPath:@"applyVip" params:params success:^(id JSON) {
                    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
                    if ([[[result objectForKey:@"response"] objectForKey:@"code"] intValue] ==100) {
                        [self showRemindView];
                    }
                } failure:^(NSError *error) {
                    NSLog(@"%@",error);
                }];
            }else{
                RegisterContrller *rc = [[RegisterContrller alloc] init];
                rc.pushType = UPDATE_TYPE;
                [self.navigationController pushViewController:rc animated:YES];
            }

        }
            break;
        
        default:
            break;
    }
}

- (void)showRemindView{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"我们已收到您的请求,会尽快安排人员与您联系,请您耐心等候" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
    [alertView show];
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

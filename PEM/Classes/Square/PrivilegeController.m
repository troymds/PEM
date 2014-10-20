//
//  PrivilegeController.m
//  PEM
//
//  Created by tianj on 14-8-29.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "PrivilegeController.h"
#import "PriImageView.h"
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
    [self addButton];
    [self addRightView];
    if (![SystemConfig sharedInstance].isUserLogin) {
        _headView.nameLabel.text = @"未注册用户";
        _headView.typeLabel.text = @"游客";
    }else{
        [_headView.iconImg setImageWithURL:[NSURL URLWithString:[SystemConfig sharedInstance].companyInfo.image]];
        _headView.nameLabel.text = [SystemConfig sharedInstance].companyInfo.company_name;
        NSLog(@"-----%@",[SystemConfig sharedInstance].vipInfo.vip_name);
        if ([SystemConfig sharedInstance].vipInfo) {
            _headView.typeLabel.text = [SystemConfig sharedInstance].vipInfo.vip_name;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = HexRGB(0xffffff);

    self.title = @"我的特权";
    // Do any additional setup after loading the view.
    
    
    _headView =[[PriHeadView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 100)];
    _headView.bgView.image = [UIImage imageNamed:@"individual_bg.png"];
    _headView.iconImg.image =[UIImage imageNamed:@"user_default.png"];
    [self.view addSubview:_headView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,_headView.frame.origin.y+_headView.frame.size.height,60,kHeight-_headView.frame.size.height-64)];
    bgView.backgroundColor = HexRGB(0xe0e0e0);
    [self.view addSubview:bgView];

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(bgView.frame.size.width,bgView.frame.origin.y,kWidth-bgView.frame.size.width,kHeight-_headView.frame.size.height-64)];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(22,24,0,0)];
    [_scrollView addSubview:rightImg];
    
    upPowerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [upPowerBtn setTitle:@"立即升级" forState:UIControlStateNormal];
    [upPowerBtn setBackgroundImage:[UIImage imageNamed:@"finish.png"] forState:UIControlStateNormal];
    [upPowerBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [upPowerBtn setBackgroundImage:[UIImage imageNamed:@"finish_pre.png"] forState:UIControlStateHighlighted];
    [_scrollView addSubview:upPowerBtn];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
}

//升级按钮
- (void)btnClick:(UIButton *)btn
{
    if (![SystemConfig sharedInstance].isUserLogin) {
        RegisterContrller *rc = [[RegisterContrller alloc] init];
        rc.pushType = UPDATE_TYPE;
        [self.navigationController pushViewController:rc animated:YES];
    }else{
        NSLog(@"%@",updateType);
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[SystemConfig sharedInstance].company_id,@"company_id",updateType,@"apply_type", nil];
        [HttpTool postWithPath:@"applyVip" params:params success:^(id JSON) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        if ([[[result objectForKey:@"response"] objectForKey:@"code"] intValue] ==100) {
            [self showRemindView];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
 
    }
}

- (void)addButton{
    NSArray *array = [NSArray arrayWithObjects:@"游客",@"体验会员",@"普通会员",@"银牌会员",@"金牌会员",@"铂金会员", nil];
    for (int i =0; i < [array count]; i++){
        PriImageView *img = [[PriImageView alloc] initWithFrame:CGRectMake(0, _headView.frame.origin.y+_headView.frame.size.height+52*i, 60, 52)];
        [img setVipName:[array objectAtIndex:i]];
        //如果没登陆 默认显示游客
        if (![SystemConfig sharedInstance].isUserLogin) {
            if (i == 0) {
                img.isSelected = YES;
            }
        }else{
            if ([SystemConfig sharedInstance].viptype){
                NSInteger vipType = [[SystemConfig sharedInstance].viptype integerValue];
                if (vipType+1 == i){
                    img.isSelected = YES;
                }
            }
        }
        img.tag = 1000+i;
        img.delegate = self;
        [self.view addSubview:img];
    }


}

- (void)addRightView{
    int vipType = [[SystemConfig sharedInstance].viptype intValue];
    if (![SystemConfig sharedInstance].isUserLogin) {
        rightImg.image = [UIImage imageNamed:@"vip_visitor.png"];
        rightImg.frame = CGRectMake(22,24,234,128);
        upPowerBtn.hidden = YES;
        if (rightImg.frame.origin.y < _scrollView.frame.size.height) {
            [_scrollView setContentSize:CGSizeMake(kWidth-60,_scrollView.frame.size.height)];
        }else{
            [_scrollView setContentSize:CGSizeMake(kWidth-60,rightImg.frame.origin.y+rightImg.frame.size.height+20)];
        }
    }else{
        if (vipType == 0){
            rightImg.image = [UIImage imageNamed:@"vip_0_info.png"];
            rightImg.frame = CGRectMake(22,24,229,229);
            if (rightImg.frame.origin.y < _scrollView.frame.size.height) {
                [_scrollView setContentSize:CGSizeMake(kWidth-60,_scrollView.frame.size.height)];
            }else{
                [_scrollView setContentSize:CGSizeMake(kWidth-60,rightImg.frame.origin.y+rightImg.frame.size.height+20)];
            }
            upPowerBtn.hidden = YES;
            
        }else if(vipType == 1){
            rightImg.image = [UIImage imageNamed:@"vip_1_info.png"];
            rightImg.frame = CGRectMake(22,24,229,369);
            upPowerBtn.hidden = YES;
            if (rightImg.frame.origin.y < _scrollView.frame.size.height) {
                [_scrollView setContentSize:CGSizeMake(kWidth-60,_scrollView.frame.size.height)];
            }else{
                [_scrollView setContentSize:CGSizeMake(kWidth-60,rightImg.frame.origin.y+rightImg.frame.size.height+20)];
            }
        }else if(vipType == 2){
            rightImg.image = [UIImage imageNamed:@"vip_2_info.png"];
            rightImg.frame = CGRectMake(22,24,229,369);
            upPowerBtn.hidden = YES;
            if (rightImg.frame.origin.y < _scrollView.frame.size.height) {
                [_scrollView setContentSize:CGSizeMake(kWidth-60,_scrollView.frame.size.height)];
            }else{
                [_scrollView setContentSize:CGSizeMake(kWidth-60,rightImg.frame.origin.y+rightImg.frame.size.height+20)];
            }
        }else if(vipType == 3){
            rightImg.image = [UIImage imageNamed:@"vip_3_info.png"];
            rightImg.frame = CGRectMake(22,24,229,369);
            upPowerBtn.hidden = YES;
            if (rightImg.frame.origin.y < _scrollView.frame.size.height) {
                [_scrollView setContentSize:CGSizeMake(kWidth-60,_scrollView.frame.size.height)];
            }else{
                [_scrollView setContentSize:CGSizeMake(kWidth-60,rightImg.frame.origin.y+rightImg.frame.size.height+20)];
            }
        }else if(vipType == 4){
            rightImg.image = [UIImage imageNamed:@"vip_4_info.png"];
            rightImg.frame = CGRectMake(22,24,229,369);
            upPowerBtn.hidden = YES;
            if (rightImg.frame.origin.y < _scrollView.frame.size.height) {
                [_scrollView setContentSize:CGSizeMake(kWidth-60,_scrollView.frame.size.height)];
            }else{
                [_scrollView setContentSize:CGSizeMake(kWidth-60,rightImg.frame.origin.y+rightImg.frame.size.height+20)];
            }
        }
    }
}


//左边的按钮点击事件
- (void)imageClicked:(ProImageView *)image{
    int vipType = [[SystemConfig sharedInstance].viptype intValue];
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[PriImageView class]]) {
            PriImageView *view = (PriImageView *)subView;
            if (view.tag == image.tag) {
                view.isSelected = YES;
            }else{
                view.isSelected = NO;
            }
        }
    }
    updateType = [NSString stringWithFormat:@"%d",image.tag-1000-1];
    //根据左边的按钮添加右边对应的试图
    switch (image.tag) {
        case 1000:
        {
            rightImg.image = [UIImage imageNamed:@"vip_visitor.png"];
            rightImg.frame = CGRectMake(22,24,234,128);
            upPowerBtn.hidden = YES;
            if (rightImg.frame.origin.y < _scrollView.frame.size.height) {
                [_scrollView setContentSize:CGSizeMake(kWidth-60,_scrollView.frame.size.height)];
            }else{
                [_scrollView setContentSize:CGSizeMake(kWidth-60,rightImg.frame.origin.y+rightImg.frame.size.height+20)];
            }
        }
            break;
        case 1001:
        {
            
            rightImg.image = [UIImage imageNamed:@"vip_0_info.png"];
            rightImg.frame = CGRectMake(22,24,229,229);
            
            upPowerBtn.frame = CGRectMake(22,rightImg.frame.origin.y+rightImg.frame.size.height,_scrollView.frame.size.width-22*2,35);
            if (upPowerBtn.frame.origin.y+upPowerBtn.frame.size.height +10 < _scrollView.frame.size.height) {
                [_scrollView setContentSize:CGSizeMake(kWidth-60, _scrollView.frame.size.height)];
            }else{
                [_scrollView setContentSize:CGSizeMake(kWidth-60,upPowerBtn.frame.origin.y+upPowerBtn.frame.size.height+20)];
            }
            upPowerBtn.hidden = NO;
            //判断是否需要升级按钮
            if ([SystemConfig sharedInstance].viptype) {
                if (vipType ==0 ||vipType ==1 || vipType == 2||vipType == 3||vipType == 4) {
                    upPowerBtn.hidden = YES;
                }
            }
            if (upPowerBtn.hidden) {
                if (rightImg.frame.size.height < _scrollView.frame.size.height) {
                    [_scrollView setContentSize:CGSizeMake(kWidth-60, _scrollView.frame.size.height)];
                }else{
                    [_scrollView setContentSize:CGSizeMake(kWidth-60,rightImg.frame.origin.y+rightImg.frame.size.height)];
                }
            }else{
                if (upPowerBtn.frame.origin.y+upPowerBtn.frame.size.height+20 < _scrollView.frame.size.height) {
                    [_scrollView setContentSize:CGSizeMake(kWidth-60, _scrollView.frame.size.height)];
                }else{
                    [_scrollView setContentSize:CGSizeMake(kWidth-60,upPowerBtn.frame.origin.y+upPowerBtn.frame.size.height+20)];
                }
            }
            
        }
            break;
        case 1002:
        {
            rightImg.image = [UIImage imageNamed:@"vip_1_info.png"];
            rightImg.frame = CGRectMake(22,24,229,369);
            
            upPowerBtn.frame = CGRectMake(22,rightImg.frame.origin.y+rightImg.frame.size.height,_scrollView.frame.size.width-22*2,35);
            upPowerBtn.hidden = NO;
            
            //判断是否需要升级按钮
            if ([SystemConfig sharedInstance].viptype) {
                if (vipType ==1 || vipType == 2||vipType == 3||vipType == 4) {
                    upPowerBtn.hidden = YES;
                }
            }
            if (upPowerBtn.hidden) {
                if (rightImg.frame.size.height < _scrollView.frame.size.height) {
                    [_scrollView setContentSize:CGSizeMake(kWidth-60, _scrollView.frame.size.height)];
                }else{
                    [_scrollView setContentSize:CGSizeMake(kWidth-60,rightImg.frame.origin.y+rightImg.frame.size.height)];
                }
            }else{
                if (upPowerBtn.frame.origin.y+upPowerBtn.frame.size.height+20 < _scrollView.frame.size.height) {
                    [_scrollView setContentSize:CGSizeMake(kWidth-60, _scrollView.frame.size.height)];
                }else{
                    [_scrollView setContentSize:CGSizeMake(kWidth-60,upPowerBtn.frame.origin.y+upPowerBtn.frame.size.height+20)];
                }
            }

        }
            break;
        case 1003:
        {
            rightImg.image = [UIImage imageNamed:@"vip_2_info.png"];
            rightImg.frame = CGRectMake(22,24,229,369);
            
            upPowerBtn.frame = CGRectMake(22,rightImg.frame.origin.y+rightImg.frame.size.height,_scrollView.frame.size.width-22*2,35);
            upPowerBtn.hidden = NO;
 
            //判断是否需要升级按钮
            if ([SystemConfig sharedInstance].viptype) {
                if (vipType == 2||vipType == 3||vipType == 4) {
                    upPowerBtn.hidden = YES;
                }
            }
            if (upPowerBtn.hidden) {
                if (rightImg.frame.size.height < _scrollView.frame.size.height) {
                    [_scrollView setContentSize:CGSizeMake(kWidth-60, _scrollView.frame.size.height)];
                }else{
                    [_scrollView setContentSize:CGSizeMake(kWidth-60,rightImg.frame.origin.y+rightImg.frame.size.height)];
                }
            }else{
                if (upPowerBtn.frame.origin.y+upPowerBtn.frame.size.height+20 < _scrollView.frame.size.height) {
                    [_scrollView setContentSize:CGSizeMake(kWidth-60, _scrollView.frame.size.height)];
                }else{
                    [_scrollView setContentSize:CGSizeMake(kWidth-60,upPowerBtn.frame.origin.y+upPowerBtn.frame.size.height+20)];
                }
            }


        }
            break;
        case 1004:
        {
            rightImg.image = [UIImage imageNamed:@"vip_3_info.png"];
            rightImg.frame = CGRectMake(22,24,229,369);
            
            upPowerBtn.frame = CGRectMake(22,rightImg.frame.origin.y+rightImg.frame.size.height,_scrollView.frame.size.width-22*2,35);
            upPowerBtn.hidden = NO;

            //判断是否需要升级按钮
            if ([SystemConfig sharedInstance].viptype) {
                if (vipType == 3||vipType == 4) {
                    upPowerBtn.hidden = YES;
                }
            }
            if (upPowerBtn.hidden) {
                if (rightImg.frame.size.height < _scrollView.frame.size.height) {
                    [_scrollView setContentSize:CGSizeMake(kWidth-60, _scrollView.frame.size.height)];
                }else{
                    [_scrollView setContentSize:CGSizeMake(kWidth-60,rightImg.frame.origin.y+rightImg.frame.size.height)];
                }
            }else{
                if (upPowerBtn.frame.origin.y+upPowerBtn.frame.size.height+20 < _scrollView.frame.size.height) {
                    [_scrollView setContentSize:CGSizeMake(kWidth-60, _scrollView.frame.size.height)];
                }else{
                    [_scrollView setContentSize:CGSizeMake(kWidth-60,upPowerBtn.frame.origin.y+upPowerBtn.frame.size.height+20)];
                }
            }

        }
            break;
        case 1005:
        {
            rightImg.image = [UIImage imageNamed:@"vip_4_info.png"];
            rightImg.frame = CGRectMake(22,24,229,369);
            
            upPowerBtn.frame = CGRectMake(22,rightImg.frame.origin.y+rightImg.frame.size.height,_scrollView.frame.size.width-22*2,35);
            upPowerBtn.hidden = NO;
            
            //判断是否需要升级按钮
            if ([SystemConfig sharedInstance].viptype) {
                if (vipType == 4) {
                    upPowerBtn.hidden = YES;
                }
            }
            if (upPowerBtn.hidden) {
                if (rightImg.frame.size.height < _scrollView.frame.size.height) {
                    [_scrollView setContentSize:CGSizeMake(kWidth-60, _scrollView.frame.size.height)];
                }else{
                    [_scrollView setContentSize:CGSizeMake(kWidth-60,rightImg.frame.origin.y+rightImg.frame.size.height)];
                }
            }else{
                if (upPowerBtn.frame.origin.y+upPowerBtn.frame.size.height+20 < _scrollView.frame.size.height) {
                    [_scrollView setContentSize:CGSizeMake(kWidth-60, _scrollView.frame.size.height)];
                }else{
                    [_scrollView setContentSize:CGSizeMake(kWidth-60,upPowerBtn.frame.origin.y+upPowerBtn.frame.size.height+20)];
                }
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

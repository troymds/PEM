//
//  YZMController.m
//  PEM
//
//  Created by tianj on 14-9-1.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "YZMController.h"
#import "HttpTool.h"
#import "SystemConfig.h"
#import "CompanySetController.h"
#import "RemindView.h"
#import "LoginController.h"


@interface YZMController ()

@end

@implementation YZMController


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
    self.title = @"免费注册";
    self.view.backgroundColor = HexRGB(0xffffff);

    // Do any additional setup after loading the view.
    // 创建按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 设置普通背景图片
    UIImage *image = [UIImage imageNamed:@"nav_login_btn.png"];
    [btn setTitle:@"登 录" forState:UIControlStateNormal];
    [btn setTitleColor:HexRGB(0x3a3a3a) forState:UIControlStateNormal];
    // 设置尺寸
    btn.bounds = (CGRect){CGPointZero, image.size};
    btn.frame = CGRectMake(10, 10,52, 24);
    [btn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;

    [self getYZM];
    [self addView];
    
}

- (void)login{
    if ([self.pushType isEqualToString:UPDATE_TYPE]) {
        LoginController *loginVC = [[LoginController alloc] init];
        loginVC.pushType = UPDATE_TYPE;
        [self.navigationController pushViewController:loginVC animated:YES];
    }else if([self.pushType isEqualToString:PUBLISH_TYPE]){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:1];
        [self.navigationController popToViewController:vc animated:YES];
    }
}

- (NSString *)getYZM{
    NSString *yzmStr;
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 2; i++) {
        int num = arc4random()%9+1;
        [arr addObject:[NSString stringWithFormat:@"%d",num]];
    }
    int a = [[arr objectAtIndex:0] intValue];
    int b = [[arr objectAtIndex:1] intValue];
    if (a > b) {
        yzmStr = [NSString stringWithFormat:@"%d - %d =",a,b];
        yzmResult = [NSString stringWithFormat:@"%d",a-b];
    }else{
        yzmStr = [NSString stringWithFormat:@"%d + %d =",a,b];
        yzmResult = [NSString stringWithFormat:@"%d",a+b];
    }
    return yzmStr;
}

- (void)addView{
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 211, 46)];
    image.image = [UIImage imageNamed:@"logo.png"];
    image.center = CGPointMake(kWidth/2, 45);
    [self.view addSubview:image];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(25, 91, kWidth-25*2, 86)];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 6.0;
    bgView.layer.borderColor = HexRGB(0xced2d8).CGColor;
    bgView.layer.borderWidth = 1.0f;
    [self.view addSubview:bgView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, bgView.frame.size.width, 1)];
    lineView.backgroundColor = HexRGB(0xced2d8);
    [bgView addSubview:lineView];
    
    UIImageView *verifyView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 9.5, 20, 24)];
    verifyView.image = [UIImage imageNamed:@"regsiter_verify.png"];
    [bgView addSubview:verifyView];
    
    yzmField = [[UITextField alloc] initWithFrame:CGRectMake(40,0,kWidth-25*2-40-61-8, 43)];
    yzmField.delegate = self;
    yzmField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    yzmField.placeholder = @"请输入正确结果";
    [bgView addSubview:yzmField];
    
    //验证码数字展示
    yzmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    yzmBtn.frame = CGRectMake(bgView.frame.size.width-61-8, 4, 61, 35);
    yzmBtn.backgroundColor = [UIColor colorWithRed:209 green:212 blue:217 alpha:1];
    [yzmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    yzmBtn.tag = 8000;
    yzmBtn.titleLabel.font = [UIFont fontWithName:@"Chalkboard SE" size:16];
    [self getYZM];
    [yzmBtn setTitle:[self getYZM] forState:UIControlStateNormal];
    [yzmBtn addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:yzmBtn];
    
    UIImageView *passwordView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 53.5, 17, 22)];
    passwordView.image = [UIImage imageNamed:@"regsiter_Password_btn.png"];
    [bgView addSubview:passwordView];
    
    secretField = [[UITextField alloc] initWithFrame:CGRectMake(40, 43, kWidth-25*2-40-61-8, 43)];
    secretField.delegate = self;
    secretField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    secretField.placeholder = @"请输入密码";
    secretField.secureTextEntry = YES;
    [bgView addSubview:secretField];
    
    playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.backgroundColor = HexRGB(0x069dd4);
    [playBtn setTitleColor:HexRGB(0xffffff) forState:UIControlStateNormal];
    playBtn.frame = CGRectMake(bgView.frame.size.width-38-8,54, 38, 21);
    playBtn.titleLabel.font = [UIFont systemFontOfSize:5];
    isPlay = NO;
    if (!isPlay) {
        [playBtn setTitle:@"显示" forState:UIControlStateNormal];
    }
    [playBtn.titleLabel setFont:[UIFont systemFontOfSize:PxFont(20)]];
    playBtn.tag = 8001;
    [playBtn addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:playBtn];
    
    [self.view addSubview:bgView];
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.frame = CGRectMake(25,200, kWidth-25*2, 35);
    [finishBtn setBackgroundImage:[UIImage imageNamed:@"finish.png"] forState:UIControlStateNormal];
    [finishBtn setBackgroundImage:[UIImage imageNamed:@"finish_pre.png"] forState:UIControlStateHighlighted];
    [finishBtn setTitle:@"完 成" forState:UIControlStateNormal];
    [finishBtn setTitleColor:HexRGB(0xffffff) forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchUpInside];
    finishBtn.tag = 8002;
    [self.view addSubview:finishBtn];
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            [subView resignFirstResponder];
        }else{
            for (UIView *view in subView.subviews) {
                if ([view isKindOfClass:[UITextField class]]) {
                    [view resignFirstResponder];
                }
            }
        }
    }

}


- (void)buttonDown:(UIButton *)btn{
    if (btn.tag == 8000) {
        [btn setTitle:[self getYZM] forState:UIControlStateNormal];
    }else if(btn.tag == 8001){
        isPlay = !isPlay;
        if (!isPlay) {
            [playBtn setTitle:@"显示" forState:UIControlStateNormal];
            secretField.secureTextEntry = YES;
        }else{
            [playBtn setTitle:@"隐藏" forState:UIControlStateNormal];
            secretField.secureTextEntry = NO;
        }
    }else{
        if ([self checkOut]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"";
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_phoneNum,@"phonenum",yzmField.text,@"yzm",secretField.text,@"password",nil];
            [HttpTool postWithPath:@"register" params:param success:^(id JSON){
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
                NSDictionary *dic = [result objectForKey:@"response"];
                int code = [[dic objectForKey:@"code"] intValue];
                if (code == 100){
                    [SystemConfig sharedInstance].company_id = [dic objectForKey:@"company_id"];
                    CompanySetController *csc = [[CompanySetController alloc] init];
                    csc.pushType = self.pushType;
                    [self.navigationController pushViewController:csc animated:YES];
                }else if(code ==103){
                    [RemindView showViewWithTitle:@"该号码已被注册过" location:MIDDLE];
                }else{
                    [RemindView showViewWithTitle:@"注册失败" location:MIDDLE];
                }
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
            }];
        }else{
            [yzmBtn setTitle:[self getYZM] forState:UIControlStateNormal];
        }
    }
}

- (BOOL)checkOut{
    if (yzmField.text.length==0||![yzmField.text isEqualToString:yzmResult]){
        [RemindView showViewWithTitle:@"请输入正确结果" location:MIDDLE];
        return NO;
    }
    if (secretField.text.length==0) {
        [RemindView showViewWithTitle:@"请输入密码" location:MIDDLE];
        return NO;
    }
    return YES;
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

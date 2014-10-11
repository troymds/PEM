//
//  RegisterContrller.m
//  PEM
//
//  Created by tianj on 14-8-27.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "RegisterContrller.h"
#import "HttpTool.h"
#import "YZMController.h"
#import "UIBarButtonItem+MJ.h"
#import "LoginController.h"
#import "RemindView.h"
#import "HttpTool.h"

@interface RegisterContrller ()

@end

@implementation RegisterContrller

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

    
    // 创建按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 设置普通背景图片
    [btn setTitle:@"登 录" forState:UIControlStateNormal];
    [btn setTitleColor:HexRGB(0x3a3a3a) forState:UIControlStateNormal];
    // 设置尺寸
    btn.frame = CGRectMake(10, 10,52, 24);
    [btn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    
    [self addView];
    // Do any additional setup after loading the view.
}

- (void)login{
    if ([self.pushType isEqualToString:UPDATE_TYPE]) {
       LoginController *loginVC =  [[LoginController alloc] init];
        loginVC.pushType = UPDATE_TYPE;
        [self.navigationController pushViewController:loginVC animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
//    NSArray *viewControllers = self.navigationController.viewControllers;
//    for (int i = (int)[viewControllers count]-1; i >= 0; i--) {
//        id vc = [viewControllers objectAtIndex:i];
//        if ([vc isKindOfClass:[PrivilegeController class]]) {
//                LoginController *loginVC =  [[LoginController alloc] init];
//                [self.navigationController pushViewController:loginVC animated:YES];
//            return;
//        }
//    }
//    for (int i = (int)[viewControllers count]-1; i >= 0; i--) {
//        id vc = [viewControllers objectAtIndex:i];
//         if ([vc respondsToSelector:@selector(backFromController:)]) {
//            self.delegate = vc;
//            [self.delegate backFromController:self];
//            break;
//        }
//    }
//
}

- (void)addView{
    //将上一个底图，利于在键盘弹出时整体向上移动
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 211, 46)];
    image.image = [UIImage imageNamed:@"logo.png"];
    image.center = CGPointMake(kWidth/2, 45);
    [self.view addSubview:image];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(25,91, kWidth-25*2, 43)];
    view.layer.borderColor = HexRGB(0xced2d8).CGColor;
    view.layer.borderWidth= 1.0f;
    
    [self.view addSubview:view];
    
    UIImageView *userView = [[UIImageView alloc] initWithFrame:CGRectMake(13,10,14,23)];
    userView.image = [UIImage imageNamed:@"phone.png"];
    [view addSubview:userView];
    
    _phoneNumField = [[UITextField alloc] initWithFrame:CGRectMake(40, 0, kWidth-25*2-30, 43)];
    _phoneNumField.placeholder = @"请输入您的手机号";
    _phoneNumField.delegate = self;
    [view addSubview:_phoneNumField];

    
    UIButton *getBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getBtn.frame = CGRectMake(25, 150, kWidth-25*2, 35);
    [getBtn setTitle:@"下 一 步" forState:UIControlStateNormal];
    [getBtn addTarget:self action:@selector(buttonDown) forControlEvents:UIControlEventTouchUpInside];
    [getBtn setBackgroundImage:[UIImage imageNamed:@"finish.png"] forState:UIControlStateNormal];
    [getBtn setBackgroundImage:[UIImage imageNamed:@"finish_pre.png"] forState:UIControlStateHighlighted];
    [getBtn setTitleColor:HexRGB(0xffffff) forState:UIControlStateNormal];

    [self.view addSubview:getBtn];
}

- (void)buttonDown{
    if (_phoneNumField.text.length == 0) {
        [RemindView showViewWithTitle:@"请输入您的手机号" location:TOP];
    }else{
        if ([self isValidateMobile:_phoneNumField.text]) {
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_phoneNumField.text,@"phonenum", nil];
            [HttpTool postWithPath:@"getYzm" params:param success:^(id JSON) {
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
                NSDictionary *dic = [result objectForKey:@"response"];
                if ([[dic objectForKey:@"code"] intValue] == 100) {
                    YZMController *yzm = [[YZMController alloc] init];
                    yzm.phoneNum = _phoneNumField.text;
                    yzm.pushType = self.pushType;
                    [self.navigationController pushViewController:yzm animated:YES];
                }else{
                    NSString *msg = [dic objectForKey:@"msg"];
                    [RemindView showViewWithTitle:msg location:TOP];
                }
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
            }];
            
        }else{
            [RemindView showViewWithTitle:@"手机号不合法" location:TOP];
        }
    }
}

-(BOOL)isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_phoneNumField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789\n"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
   BOOL basic = [string isEqualToString:filtered];
    if (!basic) {
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            [subView resignFirstResponder];
        }else{
            for (UIView *view in subView.subviews){
                [view resignFirstResponder];
            }
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

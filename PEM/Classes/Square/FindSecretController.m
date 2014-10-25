//
//  FindSecretController.m
//  PEM
//
//  Created by tianj on 14-9-17.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "FindSecretController.h"
#import "RemindView.h"
#import "HttpTool.h"

@interface FindSecretController ()

@end

@implementation FindSecretController

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
    self.title = @"找回密码";
    self.view.backgroundColor = HexRGB(0xffffff);
    // Do any additional setup after loading the view.
    [self addView];
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
    _phoneNumField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _phoneNumField.delegate = self;
    [view addSubview:_phoneNumField];
    
    
    UIButton *getBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getBtn.frame = CGRectMake(25, 150, kWidth-25*2, 35);
    [getBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [getBtn addTarget:self action:@selector(buttonDown) forControlEvents:UIControlEventTouchUpInside];
    [getBtn setBackgroundImage:[UIImage imageNamed:@"finish.png"] forState:UIControlStateNormal];
    [getBtn setBackgroundImage:[UIImage imageNamed:@"finish_pre.png"] forState:UIControlStateHighlighted];
    [getBtn setTitleColor:HexRGB(0xffffff) forState:UIControlStateNormal];
    
    [self.view addSubview:getBtn];
}

- (void)buttonDown{
    if ([self isValidateMobile:_phoneNumField.text]){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = NO;
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_phoneNumField.text,@"phone_num", nil];
        [HttpTool postWithPath:@"sendChangePasswordEmail" params:param success:^(id JSON){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dic = [result objectForKey:@"response"];
            if (dic) {
                
            }
            if ([[dic objectForKey:@"code"] intValue]==100) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"找回密码" message:@"我们已发送修改密码的链接到您的注册邮箱中,请您注意查收" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                alertView.delegate = self;
                [alertView show];
            }
        } failure:^(NSError *error) {
            [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
        }];
    }else{
        [RemindView showViewWithTitle:@"手机号不合法" location:TOP];
    }
}

-(BOOL)isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_phoneNumField resignFirstResponder];
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

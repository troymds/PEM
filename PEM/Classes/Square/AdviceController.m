//
//  AdviceController.m
//  PEM
//
//  Created by tianj on 14-9-12.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "AdviceController.h"
#import "HttpTool.h"
#import "SystemConfig.h"
#import "RemindView.h"

@interface AdviceController ()

@end

@implementation AdviceController

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
    self.title = @"意见反馈";
    self.view.backgroundColor = HexRGB(0xffffff);
    // Do any additional setup after loading the view.
    [self addView];
    
    // 创建按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 设置普通背景图片
    [btn setTitle:@"完 成" forState:UIControlStateNormal];
    [btn setTitleColor:HexRGB(0x3a3a3a) forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"left_item.png"] forState:UIControlStateNormal];
    // 设置尺寸
    btn.frame = CGRectMake(10, 10,52, 24);
    [btn addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;

}

- (void)finish
{
    if (isEdit) {
        if (![_textView.text isEqualToString:@""]) {
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[SystemConfig sharedInstance].company_id,@"company_id",_textView.text,@"content", nil];
            [HttpTool postWithPath:@"addAdvice" params:param success:^(id JSON) {
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
                if ([result objectForKey:@"response"]) {
                    NSDictionary *dic = [result objectForKey:@"response"];
                    if ([[dic objectForKey:@"code"] intValue] ==100){
                        [self.navigationController popViewControllerAnimated:YES];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"advice" object:nil];
                    }else{
                        [RemindView showViewWithTitle:@"反馈失败" location:MIDDLE];
                    }
                }
            } failure:^(NSError *error) {
                [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
            }];
        }else{
            [RemindView showViewWithTitle:@"请输入您的宝贵意见!" location:MIDDLE];
        }
    }else{
        [RemindView showViewWithTitle:@"请输入您的宝贵意见!" location:MIDDLE];
    }

}

- (void)addView{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(23, 20, 150, 20)];
    label.textColor = HexRGB(0x069dd4);
    label.text = @"反馈内容";
    label.font = [UIFont systemFontOfSize:PxFont(26)];
    [self.view addSubview:label];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(23, 50,kWidth-46,158)];
    _textView.delegate = self;
    _textView.selectedRange = NSMakeRange(0, 0);
    _textView.textAlignment = NSTextAlignmentLeft;
    [_textView setFont:[UIFont systemFontOfSize:16]];
    _textView.layer.borderColor = HexRGB(0x93d9f3).CGColor;
    _textView.layer.borderWidth = 0.5f;
    _textView.layer.masksToBounds = YES;
    _textView.layer.cornerRadius = 6.0f;
    _textView.text = @"请输入您的宝贵意见!";
    _textView.textColor = HexRGB(0x808080);
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(23, 221, kWidth-46, 20)];
    label1.textColor = HexRGB(0x808080);
    label1.backgroundColor = [UIColor clearColor];
    label1.text = @"问题反馈QQ群 : 32111452";
    
    [self.view addSubview:label1];
    [self.view addSubview:_textView];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (!isEdit) {
        textView.text = @"";
        isEdit = YES;
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UITextView class]]) {
            [subView resignFirstResponder];
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

//
//  DescriptionController.m
//  PEM
//
//  Created by tianj on 14-8-21.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "DescriptionController.h"
#import "RemindView.h"

#define kScrollWidth self.view.frame.size.width

@interface DescriptionController ()

@end

@implementation DescriptionController

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
    // Do any additional setup after loading the view.
    self.view.backgroundColor = HexRGB(0xffffff);
    self.title = @"产品描述";
    
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

    [self addView];
    
    
}

- (void)addView
{
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(20,10,kWidth-20*2,250)];
    _textView.delegate = self;
    _textView.backgroundColor = [UIColor clearColor];
    _textView.selectedRange = NSMakeRange(0, 0);
    _textView.textAlignment = NSTextAlignmentLeft;
    [_textView setFont:[UIFont systemFontOfSize:16]];
    _textView.layer.borderColor = HexRGB(0xd5d5d5).CGColor;
    _textView.layer.borderWidth = 1.0f;
    _textView.layer.masksToBounds = YES;
    _textView.layer.cornerRadius = 6.0f;
    
    if (_text&&_text.length!=0){
        _textView.text = _text;
        isEidt = YES;
    }else{
        _textView.text = @"请输入产品详细情况";
        _textView.textColor = HexRGB(0x808080);
    }
    
    [self.view addSubview:_textView];
}

- (void)finish{
    if (isEidt) {
        if (![_textView.text isEqualToString:@""]) {
            if (_textView.text.length<10) {
                [RemindView showViewWithTitle:@"描述信息最少为10字" location:MIDDLE];
            }else{
                if (_isSupply) {
                    if ([self.delegate respondsToSelector:@selector(sendValueFromViewController:value:isDemand:)]) {
                        [self.delegate sendValueFromViewController:self value:_textView.text isDemand:NO];
                    }
                }else{
                    if ([self.delegate respondsToSelector:@selector(sendValueFromViewController:value:isDemand:)]) {
                        [self.delegate sendValueFromViewController:self value:_textView.text isDemand:YES];
                    }
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            [RemindView showViewWithTitle:@"请输入产品详细情况" location:MIDDLE];
        }
    }else{
        [RemindView showViewWithTitle:@"请输入产品详细情况" location:MIDDLE];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (!isEidt) {
        _textView.text = @"";
        isEidt = YES;
    }
    _textView.textColor = [UIColor blackColor];
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

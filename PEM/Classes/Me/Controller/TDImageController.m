//
//  TDImageController.m
//  PEM
//
//  Created by tianj on 14-8-26.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "TDImageController.h"

@interface TDImageController ()

@end

@implementation TDImageController

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
    self.title = @"3D图片上传";
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-10*2, 200)];
    bgView.layer.borderColor = HexRGB(0x93d9f3).CGColor;
    bgView.layer.borderWidth = 0.3f;
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 6.0f;
    [self.view addSubview:bgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5,0, bgView.frame.size.width-5*2, 200)];
    NSString *str = @"尊敬的VVIP会员：\n      您好！由于上传3D图片需要大量素材,您可直接点击下方的在线申请与我们联系,我们的工作人员会尽快雨凝联系,为您提供3D图片上传的具体操作步骤！\n     感谢您的配合！";
    label.backgroundColor = [UIColor clearColor];
    label.text = str;
    label.numberOfLines  = 0;
    label.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:label];
    NSArray *arr = [NSArray arrayWithObjects:@"在线申请",@"电话咨询", nil];
    for (int i = 0; i< 2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 2000+i;
        btn.frame = CGRectMake(60, label.frame.origin.y+200+20+i*(40+40), self.view.frame.size.width-60*2, 40);
        [btn setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor orangeColor]];
        [self.view addSubview:btn];
    }
}

- (void)btnClicked:(UIButton *)btn{
    if (btn.tag == 2000) {
        
    }else{
        
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

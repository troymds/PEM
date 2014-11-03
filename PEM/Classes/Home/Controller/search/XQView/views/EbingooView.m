//
//  EbingooView.m
//  PEM
//
//  Created by YY on 14-10-24.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "EbingooView.h"

@interface EbingooView ()<UIWebViewDelegate>

@end

@implementation EbingooView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"企业E平台";
    UIWebView *ebingooWeb =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    [self.view addSubview:ebingooWeb];
    
    [ebingooWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_ebingooID]]];
    ebingooWeb.delegate =self;
    ebingooWeb.backgroundColor =[UIColor whiteColor];
    ebingooWeb.scrollView.bounces = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

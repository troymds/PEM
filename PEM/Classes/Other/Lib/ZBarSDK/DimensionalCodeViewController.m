//
//  DimensionalCodeViewController.m
//  Teddybear
//
//  Created by lifei on 14-10-20.
//  Copyright (c) 2014年 chunxi. All rights reserved.
//

#import "DimensionalCodeViewController.h"

@interface DimensionalCodeViewController ()

@end

@implementation DimensionalCodeViewController

//返回
- (void)setBackNaviItem
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 0,12, 15);
    [button setImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)backBtnPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title= @"二维码说明";
   
    [self setBackNaviItem];
}
-(void)viewWillAppear:(BOOL)animated{
    UIWebView *web =[[UIWebView alloc] initWithFrame:CGRectMake(0,0, kWidth, kHeight-64)];
    web.delegate=self;
    web.scrollView.bounces = NO;
    [self.view addSubview:web];
    
    NSURLRequest *request =[[NSURLRequest alloc] initWithURL:self.url];
    [web loadRequest:request];
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

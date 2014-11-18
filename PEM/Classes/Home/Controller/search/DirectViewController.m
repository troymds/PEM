//
//  DirectViewController.m
//  PEM
//
//  Created by tianj on 14-11-18.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "DirectViewController.h"

@interface DirectViewController ()<UIScrollViewDelegate>
{
    UIWebView *_webView;
}

@end

@implementation DirectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = HexRGB(0xffffff);
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    _webView.scrollView.delegate = self;
    [self.view addSubview:_webView];
    
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    if (scrollView.contentOffset.y > scrollView.contentSize.height-scrollView.frame.size.height) {
        scrollView.contentOffset = CGPointMake(0, scrollView.contentSize.height-scrollView.frame.size.height);
    }
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

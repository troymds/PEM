//
//  EplatFormController.m
//  PEM
//
//  Created by tianj on 14-10-28.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "EplatFormController.h"

@interface EplatFormController ()
@property (nonatomic, strong) NSString * useAgent;

@end

@implementation EplatFormController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"企业E平台";
    // Do any additional setup after loading the view.
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    _webView.delegate = self;
    _webView.userInteractionEnabled = YES;
    _webView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_webView];
    NSString *userAgent = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    self.useAgent = [userAgent stringByAppendingString:@"/ebingoo"];
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"UserAgent"].length == 0) {
        NSDictionary *dictionnary = [[NSDictionary alloc]initWithObjectsAndKeys:self.useAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    }
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_e_url]]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
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

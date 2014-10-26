//
//  bannerWebView.m
//  PEM
//
//  Created by YY on 14-10-24.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "bannerWebView.h"
#import "xiangqingViewController.h"
#import "qiugouXQ.h"

@interface bannerWebView ()<UIWebViewDelegate,UIGestureRecognizerDelegate>
{
    UIWebView *bannerWevView;
}
@end

@implementation bannerWebView

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    如果返回值为一个链接,则通过 webView 加载一下,同时需要点击 webView 中链接里跳回原生态 APP 里。
//    跳转分别调用三种方法
//    ebingoo.jumpToSupply(id)
//    ebingoo.jumpToDemand(id)
//    ebingoo.jumpToCompany(id)
    
    bannerWevView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    [self.view addSubview:bannerWevView];
    
    
    [bannerWevView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_bannerWebid]]];
    bannerWevView.userInteractionEnabled = YES;
    bannerWevView.scrollView.bounces = NO;
    bannerWevView.delegate =self;
    
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.delegate= self;
    singleTap.cancelsTouchesInView = NO;
    
    
    //这个可以加到任何控件上,比如你只想响应WebView，我正好填满整个屏幕
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = title;
     if (webView != bannerWevView) { return; }
    
    
    if (![[bannerWevView stringByEvaluatingJavaScriptFromString:@"typeof WebViewJavascriptBridge == 'object'"] isEqualToString:@"true"]) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ebingoo.jumpToSupply" ofType:@"id"];
        
        

        NSString *js = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        [bannerWevView stringByEvaluatingJavaScriptFromString:js];
    }
    

}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognize
{
    return YES;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    
    CGPoint point = [sender locationInView:self.view];
    NSLog(@"handleSingleTap!pointx:%f,y:%f",point.x,point.y);
}




- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    
    NSLog(@"----dddddd");

    //判断是否是单击
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        NSURL *url = [request URL];
        
        if([[UIApplication sharedApplication]canOpenURL:url])
        {
            [[UIApplication sharedApplication]openURL:url];
        }
        return NO;
    }
    return YES;
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

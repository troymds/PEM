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
#import "CompanyXQViewController.h"

@interface bannerWebView ()<UIWebViewDelegate,UIGestureRecognizerDelegate>
{
    UIWebView *bannerWevView;
}
@end

@implementation bannerWebView

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    bannerWevView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    [self.view addSubview:bannerWevView];
    bannerWevView.backgroundColor =[UIColor clearColor];
    [bannerWevView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_bannerWebid]]];
    bannerWevView.userInteractionEnabled = YES;
    bannerWevView.delegate =self;
    
    [self addTapOnWebView];


}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title =title;
 }


-(void)addTapOnWebView
{
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [bannerWevView addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
}

#pragma mark- TapGestureRecognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
// //这个方法是网页中的每一个请求都会被触发的
{
    NSString *urlString = [[request URL] absoluteString];
    NSArray *urlComps = [urlString componentsSeparatedByString:@"/ebingoo."];
    if([urlComps count]>1)
    {
        NSString *str = [urlComps objectAtIndex:1];
        NSString *info_id = [[str componentsSeparatedByString:@"("] objectAtIndex:1];
        info_id = [[info_id componentsSeparatedByString:@")"] objectAtIndex:0];
        NSArray *arr = [str componentsSeparatedByString:@"("];
        NSString *methordStr = [arr objectAtIndex:0];
        if ([methordStr isEqualToString:@"jumpToSupply"]) {
            xiangqingViewController *xq = [[xiangqingViewController alloc] init];
            xq.supplyIndex = info_id;
            [self.navigationController pushViewController:xq animated:YES];
        }else if ([methordStr isEqualToString:@"jumpToDemand"]){
            qiugouXQ *qx = [[qiugouXQ alloc] init];
            qx.demandIndex = info_id;
            [self.navigationController pushViewController:qx animated:YES];
        }else if ([methordStr isEqualToString:@"jumpToCompany"]){
            CompanyXQViewController *comXQVC = [[CompanyXQViewController alloc] init];
            comXQVC.companyID = info_id;
            [self.navigationController pushViewController:comXQVC animated:YES];

        }
        return NO;
    }; 
    return YES; 
}
-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    CGPoint pt = [sender locationInView:bannerWevView];
    
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).href", pt.x, pt.y];
    _dataStr = [bannerWevView stringByEvaluatingJavaScriptFromString:imgURL];
    
    if (_dataStr.length > 0)
    {
        if ([_dataStr rangeOfString:@"jumpToSupply"].location != NSNotFound )
        {
            NSString *str = [[_dataStr componentsSeparatedByString:@"jumpToSupply"] objectAtIndex:1];
            
            str = [self subStringFromDataStr:str];
            xiangqingViewController *xiangQingVC = [[xiangqingViewController alloc] init];
            
            xiangQingVC.supplyIndex = str;
            [self.navigationController pushViewController:xiangQingVC animated:YES];
            
        }else if ([_dataStr rangeOfString:@"jumpToDemand"].location != NSNotFound )
        {
            NSString *str = [[_dataStr componentsSeparatedByString:@"jumpToDemand"] objectAtIndex:1];
            
            str = [self subStringFromDataStr:str];
            qiugouXQ *qiuGouVC = [[qiugouXQ alloc] init];
            qiuGouVC.demandIndex = str;
            
            [self.navigationController pushViewController:qiuGouVC animated:YES];
        }
        else if([_dataStr rangeOfString:@"jumpToCompany"].location != NSNotFound )
        {
            NSString *str = [[_dataStr componentsSeparatedByString:@"jumpToCompany"] objectAtIndex:1];
            
            str = [self subStringFromDataStr:str];
            CompanyXQViewController *comXQVC = [[CompanyXQViewController alloc] init];
            comXQVC.companyID = str;
            
            [self.navigationController pushViewController:comXQVC animated:YES];
        }else
        {
            
        }
    }
    
}

- (NSString *)subStringFromDataStr:(NSString *)dataStr
{
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@")" withString:@""];
    return dataStr;
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

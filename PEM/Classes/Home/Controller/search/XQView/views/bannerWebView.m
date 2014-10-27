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
    
//    如果返回值为一个链接,则通过 webView 加载一下,同时需要点击 webView 中链接里跳回原生态 APP 里。
//    跳转分别调用三种方法
//    ebingoo.jumpToSupply(id)
//    ebingoo.jumpToDemand(id)
//    ebingoo.jumpToCompany(id)
    
    bannerWevView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    [self.view addSubview:bannerWevView];
    bannerWevView.backgroundColor =[UIColor clearColor];
    [bannerWevView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_bannerWebid]]];
    bannerWevView.userInteractionEnabled = YES;
    bannerWevView.delegate =self;
    
//     
//    WebScriptObject *obj = (WebScriptObject *)JSArray;
//    
//    NSUInteger count = [[obj valueForKey:@"length"] integerValue];
//    
//    NSMutableArray *a = [NSMutableArray array];
//    
//    for (NSUInteger i = 0; i < count; i++) {
//        
//        NSString *item = [obj webScriptValueAtIndex:i];
//        
//        NSLog(@"item:%@", item);
    

    
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
    NSLog(@"iiiiii   %@",urlString);
    NSArray *urlComps = [urlString
                         componentsSeparatedByString:@"/ebingoo."];
    NSLog(@"ddddd%@",urlComps);
    NSLog(@"-------%d",urlComps.count);
    if([urlComps count]>1)
    {
        //    ebingoo.jumpToSupply(id)
        //    ebingoo.jumpToDemand(id)
        //    ebingoo.jumpToCompany(id)
        NSString *str = [urlComps objectAtIndex:1];
        NSString *info_id = [[str componentsSeparatedByString:@"("] objectAtIndex:1];
        info_id = [[info_id componentsSeparatedByString:@")"] objectAtIndex:0];
        NSLog(@"info_id:%@",info_id);
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
    NSLog(@"image url=%@", _dataStr);
    
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

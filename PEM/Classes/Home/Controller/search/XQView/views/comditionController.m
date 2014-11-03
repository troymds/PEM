//
//  comditionController.m
//  PEM
//
//  Created by YY on 14-9-10.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "comditionController.h"
#import "comPanyNEWTool.h"
#import "HttpTool.h"
@interface comditionController ()<UIWebViewDelegate,UIScrollViewDelegate>
{
    UIWebView *newWebView;
    float webheight;
}
@end

@implementation comditionController

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
    _urlNstr = @"";
    self.title =@"企业新闻";
    
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_companyIndex,@"newsid", nil];

   [HttpTool postWithPath:@"getNewsWapUrl" params:dic success:^(id JSON) {
       NSDictionary *d = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
       
       
       NSDictionary *array =d[@"response"];
       _urlNstr = array [@"url"];
       
       
       
        newWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
       

       [self.view addSubview:newWebView];
       [newWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlNstr]]];
       newWebView.delegate = self;
       newWebView.backgroundColor =[UIColor clearColor];
       newWebView.scrollView.bounces = NO;

       
   } failure:^(NSError *error) {
       
   }];
    
    

}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}


@end

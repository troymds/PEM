//
//  comditionController.m
//  PEM
//
//  Created by YY on 14-9-10.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "comditionController.h"
#import "comPanyNEWTool.h"
@interface comditionController ()<UIWebViewDelegate>

@end

@implementation comditionController
@synthesize contentLabel=_contentLabel;
@synthesize  companyImage=_companyImage;
@synthesize  readLabel=_readLabel;
@synthesize  dateLabel=_dateLabel;
@synthesize titleLabel=_titleLabel;
@synthesize backScrollView=_backScrollView;
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
    self.title =@"企业新闻";
    
    
    
    
    
    _backScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    [self.view addSubview:_backScrollView];
    _backScrollView.contentSize = CGSizeMake(320, 800);
    _backScrollView.showsVerticalScrollIndicator=NO;
    _backScrollView.userInteractionEnabled = YES;
    
    
    UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:webView];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://218.244.149.129/eb/index.php?s=/Home/News/preview/id/19.html"]]];
    webView.delegate = self;
    
    

}





-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}


@end

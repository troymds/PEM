//
//  NewfeatureController.m
//  PEM
//
//  Created by jch on 14-8-13.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "NewfeatureController.h"
#import "UIImage+MJ.h"
#import "MainController.h"
#import "RegisterContrller.h"
#import "WBNavigationController.h"
#define kCount 5
@interface NewfeatureController ()<UIScrollViewDelegate,UINavigationControllerDelegate>
{
    UIPageControl *_page;
    UIScrollView *_scroll;

}
@end

@implementation NewfeatureController

- (void)loadView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"Default.png"];
    /*
     以3.5inch为例（320x480）
     1> 当没有状态栏，applicationFrame的值{{0, 0}, {320, 480}}
     2> 当有状态栏，applicationFrame的值{{0, 20}, {320, 460}}
     */
    imageView.frame = [UIScreen mainScreen].applicationFrame;
    // 跟用户进行交互（这样才可以接收触摸事件）
    imageView.userInteractionEnabled = YES;
    self.view = imageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addScrollView];
    [self addScrollImages];
    [self addPageControl];
}

#pragma mark 添加滚动视图
- (void)addScrollView
{
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.frame = self.view.bounds;
    scroll.showsHorizontalScrollIndicator = NO; // 隐藏水平滚动条
    CGSize size = scroll.frame.size;
    scroll.contentSize = CGSizeMake(size.width * kCount, 480); // 内容尺寸
    scroll.pagingEnabled = YES; // 分页
    scroll.delegate = self;
    [self.view addSubview:scroll];
    _scroll = scroll;
}

#pragma mark 添加滚动显示的图片
- (void)addScrollImages
{
    CGSize size = _scroll.frame.size;
    
    for (int i = 0; i<kCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        // 1.显示图片
        NSString *name = [NSString stringWithFormat:@"new_tex%d.jpg", i+1 ];
        imageView.image = [UIImage imageNamed:name];
        // 2.设置frame
        imageView.frame = CGRectMake(i * size.width, 0, size.width, size.height);
        [_scroll addSubview:imageView];
        
        if (i == kCount - 1) { // 最后一页，添加2个按钮
            // 3.立即体验（开始）
            UIButton *start = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *startNormal = [UIImage resizedImage:@"new_enter.png"];
            [start setBackgroundImage:startNormal forState:UIControlStateNormal];
            [start setBackgroundImage:[UIImage resizedImage:@"new_enter_pre.png"] forState:UIControlStateHighlighted];
            start.frame =CGRectMake(45, size.height*0.8, 230, 40);
            [start setTitle:@"立即进入" forState:UIControlStateNormal];
            start.titleLabel.font =[UIFont systemFontOfSize:PxFont(30)];
            
            [start addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:start];
    
            imageView.userInteractionEnabled = YES;
            
            
            UIButton *login = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *loginNormal = [UIImage resizedImage:@"new_login.png"];
            [login setBackgroundImage:loginNormal forState:UIControlStateNormal];
            [login setBackgroundImage:[UIImage resizedImage:@"new_login_pre.png"] forState:UIControlStateHighlighted];
            login.frame =CGRectMake(45, size.height*0.8-60, 230, 40);
            [login setTitle:@"免费注册" forState:UIControlStateNormal];
            login.titleLabel.font =[UIFont systemFontOfSize:PxFont(30)];
            
            [login addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:login];
            
            imageView.userInteractionEnabled = YES;

        }
    }
}
-(void)start
{
    [UIApplication sharedApplication].statusBarHidden =NO;
    self.view.window.rootViewController =[[MainController alloc]init];
}
-(void)login:(UIButton *)btn {
    [UIApplication sharedApplication].statusBarHidden =NO;
    self.view.window.rootViewController =[[RegisterContrller alloc]init];

    
       }
#pragma mark 添加分页指示器
- (void)addPageControl
{
    CGSize size = self.view.frame.size;
    UIPageControl *page = [[UIPageControl alloc] init];
    page.center = CGPointMake(size.width * 0.5, size.height * 0.95);
    page.numberOfPages = kCount;
    page.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_page_on.png"]];
    page.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_page_off.png"]];
    page.bounds = CGRectMake(0, 0, 150, 0);
    [self.view addSubview:page];
    _page = page;
}



#pragma mark - 滚动代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _page.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
}



@end
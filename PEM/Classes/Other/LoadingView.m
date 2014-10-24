//
//  LoadingView.m
//  PEM
//
//  Created by tianj on 14-10-24.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "LoadingView.h"
#import "AFHTTPClient.h"

@implementation LoadingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init
{
    if (self = [super init]) {
        CGRect frame = [UIScreen mainScreen].bounds;
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        UIView *view = [[UIView alloc] initWithFrame:frame];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.4;
        [self addSubview:view];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, kWidth-40, 50)];
        bgView.backgroundColor = HexRGB(0xffffff);
        [self addSubview:bgView];
        bgView.center = self.center;
        
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        activityView.center = CGPointMake(bgView.frame.size.width/2, 15);
        activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [activityView startAnimating];
        [bgView addSubview:activityView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,30,bgView.frame.size.width,20)];
        _titleLabel.backgroundColor= [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.text = @"数据访问中";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor grayColor];
        [bgView addSubview:_titleLabel];
    }
    return self;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.cancelUrl&&self.cancelUrl.length!=0) {
        AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kURL]];
        NSLog(@"%@",self.cancelUrl);
        NSString *pathStr = [NSString stringWithFormat:@"ebingoo/index.php?s=/Home/Api/%@",self.cancelUrl];
        [client cancelAllHTTPOperationsWithMethod:@"POST" path:pathStr];
    
    }
    [self removeFromSuperview];
}


+ (LoadingView *)showViewWithCancelUrl:(NSString *)url title:(NSString *)title
{
    LoadingView *loadingView = [[LoadingView alloc] init];
    loadingView.cancelUrl = url;
    if (title) {
        loadingView.titleLabel.text = title;
    }
    return loadingView;
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

+ (void)hideAllLodingView
{
    for (UIView *subView in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([subView  isKindOfClass:[LoadingView class]]) {
            [subView removeFromSuperview];
        }
    }
}


















@end

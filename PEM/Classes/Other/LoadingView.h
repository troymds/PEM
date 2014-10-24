//
//  LoadingView.h
//  PEM
//
//  Created by tianj on 14-10-24.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView


@property (nonatomic,copy) NSString *cancelUrl;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) UILabel *titleLabel;


- (void)show;


+ (void)hideAllLodingView;


+ (LoadingView *)showViewWithCancelUrl:(NSString *)url title:(NSString *)title;

@end

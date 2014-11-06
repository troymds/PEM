//
//  CategoryView.h
//  PEM
//
//  Created by tianj on 14-11-6.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategoryView;
@protocol CategoryViewDelegate <NSObject>

- (void)categoryViewClicked:(CategoryView *)view;

@end

@interface CategoryView : UIView

@property (nonatomic,strong) UIImageView *iconImg;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *desLabel;
@property (nonatomic,assign) BOOL isSelected;

@property (nonatomic,weak) id <CategoryViewDelegate> delegate;

@end
